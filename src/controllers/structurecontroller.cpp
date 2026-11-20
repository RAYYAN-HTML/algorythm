#include "structurecontroller.h"
#include <QVariant>

void StructureVisualModel::resetValues(const QVariantList &values)
{
    beginResetModel();
    m_values.clear();
    for (const auto &value : values) m_values.append(value.toInt());
    endResetModel();
    emit countChanged();
}

void StructureVisualModel::insertValue(int row, int value)
{
    row = qBound(0, row, static_cast<int>(m_values.size()));
    beginInsertRows({}, row, row);
    m_values.insert(row, value);
    endInsertRows();
    emit countChanged();
}

void StructureVisualModel::removeValue(int row)
{
    if (row < 0 || row >= m_values.size()) return;
    beginRemoveRows({}, row, row);
    m_values.removeAt(row);
    endRemoveRows();
    emit countChanged();
}

QVariant TreeVisualModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_nodes.size()) return {};
    const QVariantMap &node = m_nodes.at(index.row());
    if (role == ValueRole) return node.value("value");
    if (role == PositionXRole) return node.value("x");
    if (role == PositionYRole) return node.value("y");
    return {};
}

void TreeVisualModel::resetNodes(const QVariantList &nodes)
{
    beginResetModel();
    m_nodes.clear();
    for (const auto &node : nodes) m_nodes.append(node.toMap());
    endResetModel();
    emit countChanged();
}

void TreeVisualModel::syncNodes(const QVariantList &nodes)
{
    if (m_nodes.isEmpty()) { resetNodes(nodes); return; }
    QVariantList additions;
    for (const auto &entry : nodes) {
        const QVariantMap next = entry.toMap();
        int row = -1;
        for (int i = 0; i < m_nodes.size(); ++i) if (m_nodes[i].value("value") == next.value("value")) { row = i; break; }
        if (row < 0) { additions.append(next); continue; }
        QVariantMap &current = m_nodes[row];
        if (current.value("x") != next.value("x") || current.value("y") != next.value("y")) {
            current = next;
            emit dataChanged(index(row), index(row), {PositionXRole, PositionYRole});
        }
    }
    if (!additions.isEmpty()) {
        const int first = m_nodes.size();
        beginInsertRows({}, first, first + additions.size() - 1);
        for (const auto &node : additions) m_nodes.append(node.toMap());
        endInsertRows();
        emit countChanged();
    }
}

StructureController::StructureController(QObject*p):QObject(p){m_list.insertEnd(8);m_list.insertEnd(3);m_list.insertEnd(6);m_status="Sample linked list loaded.";m_visualModel.resetValues(values());}

QVariantList StructureController::values()const{
    QVariantList out; std::vector<int> v;
    if(m_kind=="Linked List")v=m_list.values();else if(m_kind=="Stack")v=m_stack.values();else if(m_kind=="Queue")v=m_queue.values();else if(m_kind=="Binary Search Tree")v=m_tree.inorder();
    for(int x:v)out<<x;return out;
}
QVariantList StructureController::treeNodes()const{QVariantList out;for(auto n:m_tree.visual()){QVariantMap m;const int width=1<<n.depth;m["value"]=n.value;m["x"]=(n.position+0.5)/width;m["y"]=n.depth;m["parentX"]=n.depth?((n.position/2+0.5)/(width/2.0)):0.5;m["parentY"]=n.depth-1;out<<m;}return out;}
int StructureController::size()const{return values().size();}
void StructureController::setKind(const QString&k){if(k==m_kind)return;m_kind=k;m_list=SinglyLinkedList{};m_stack=LinkedStack{};m_queue.clear();m_tree=BinarySearchTree{};if(k=="Linked List"){m_list.insertEnd(8);m_list.insertEnd(3);m_list.insertEnd(6);}else if(k=="Stack"){m_stack.push(4);m_stack.push(7);m_stack.push(2);}else if(k=="Queue"){m_queue.enqueue(3);m_queue.enqueue(8);m_queue.enqueue(5);}else if(k=="Binary Search Tree"){for(int v:{8,4,12,2,6,10,14})m_tree.insert(v);}m_visualModel.resetValues(k=="Binary Search Tree"?QVariantList{}:values());m_treeVisualModel.resetNodes(k=="Binary Search Tree"?treeNodes():QVariantList{});m_status="Sample "+k+" loaded.";emit changed();}
void StructureController::reset(){m_list=SinglyLinkedList{};m_stack=LinkedStack{};m_queue.clear();m_tree=BinarySearchTree{};m_visualModel.resetValues({});m_treeVisualModel.resetNodes({});m_status="Structure cleared.";emit changed();}
void StructureController::insert(int value,int position){
    if(m_kind=="Linked List"){
        bool ok=position<0?false:position==0?(m_list.insertBeginning(value),true):position==m_list.size()?(m_list.insertEnd(value),true):m_list.insertAt(static_cast<std::size_t>(position),value);
        if(ok)m_visualModel.insertValue(position,value);
        m_status=ok?QString("Inserted %1 at position %2.").arg(value).arg(position):"Position is outside the list bounds.";
    }else if(m_kind=="Stack"){m_stack.push(value);m_visualModel.insertValue(0,value);m_status=QString("Pushed %1 onto the top.").arg(value);}
    else if(m_kind=="Queue"){m_queue.enqueue(value);m_visualModel.insertValue(m_visualModel.rowCount(),value);m_status=QString("Enqueued %1 at the rear.").arg(value);}
    else {
        constexpr int maximumDepth=3;
        if(m_tree.insertionDepth(value)>maximumDepth)m_status="Cannot insert: the tree visualizer supports at most four levels.";
        else {const bool inserted=m_tree.insert(value);if(inserted)m_treeVisualModel.syncNodes(treeNodes());m_status=inserted?QString("Inserted %1 into the BST.").arg(value):"Duplicate values are ignored in this BST.";}
    }
    emit changed();
}
void StructureController::remove(int position){
    if(m_kind=="Linked List"){const bool ok=m_list.eraseAt(position);if(ok)m_visualModel.removeValue(position);m_status=ok?QString("Deleted the node at position %1.").arg(position):"Position is outside the list bounds.";}
    else if(m_kind=="Stack"){try{const int value=m_stack.pop();m_visualModel.removeValue(0);m_status=QString("Popped %1 from the top.").arg(value);}catch(const std::underflow_error&){m_status="Cannot pop: the stack is empty.";}}
    else if(m_kind=="Queue"){try{const int value=m_queue.dequeue();m_visualModel.removeValue(0);m_status=QString("Dequeued %1 from the front.").arg(value);}catch(const std::underflow_error&){m_status="Cannot dequeue: the queue is empty.";}}
    else m_status="Delete is not included in this Binary Search Tree demo.";
    emit changed();
}
void StructureController::search(int value){if(m_kind=="Linked List"){int i=m_list.find(value);m_status=i<0?QString("%1 is not in the list.").arg(value):QString("Found %1 at position %2.").arg(value).arg(i);}else if(m_kind=="Binary Search Tree")m_status=m_tree.contains(value)?QString("%1 exists in the tree.").arg(value):QString("%1 is not in the tree.").arg(value);else m_status=QString("Front/top value is %1.").arg(values().isEmpty()?QString("(empty)"):values().first().toString());emit changed();}
void StructureController::traverse(const QString&order){if(m_kind!="Binary Search Tree"){m_status=QString("Current order: %1").arg([&]{QStringList x;for(auto v:values())x<<v.toString();return x.join(" → ");}());}else{std::vector<int> v=order=="Preorder"?m_tree.preorder():order=="Postorder"?m_tree.postorder():m_tree.inorder();QStringList x;for(int n:v)x<<QString::number(n);m_status=order+": "+x.join(" → ");}emit changed();}
