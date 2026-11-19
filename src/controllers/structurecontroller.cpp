#include "structurecontroller.h"
#include <QVariant>

StructureController::StructureController(QObject*p):QObject(p){m_list.insertEnd(8);m_list.insertEnd(3);m_list.insertEnd(6);m_status="Sample linked list loaded.";}

QVariantList StructureController::values()const{
    QVariantList out; std::vector<int> v;
    if(m_kind=="Linked List")v=m_list.values();else if(m_kind=="Stack")v=m_stack.values();else if(m_kind=="Queue")v=m_queue.values();else if(m_kind=="Binary Search Tree")v=m_tree.inorder();
    for(int x:v)out<<x;return out;
}
QVariantList StructureController::treeNodes()const{QVariantList out;for(auto n:m_tree.visual()){QVariantMap m;const int width=1<<n.depth;m["value"]=n.value;m["x"]=(n.position+0.5)/width;m["y"]=n.depth;m["parentX"]=n.depth?((n.position/2+0.5)/(width/2.0)):0.5;m["parentY"]=n.depth-1;out<<m;}return out;}
int StructureController::size()const{return values().size();}
void StructureController::setKind(const QString&k){if(k==m_kind)return;m_kind=k;m_list=SinglyLinkedList{};m_stack=LinkedStack{};m_queue.clear();m_tree=BinarySearchTree{};if(k=="Linked List"){m_list.insertEnd(8);m_list.insertEnd(3);m_list.insertEnd(6);}else if(k=="Stack"){m_stack.push(4);m_stack.push(7);m_stack.push(2);}else if(k=="Queue"){m_queue.enqueue(3);m_queue.enqueue(8);m_queue.enqueue(5);}else if(k=="Binary Search Tree"){for(int v:{8,4,12,2,6,10,14})m_tree.insert(v);}m_status="Sample "+k+" loaded.";emit changed();}
void StructureController::reset(){m_list=SinglyLinkedList{};m_stack=LinkedStack{};m_queue.clear();m_tree=BinarySearchTree{};m_status="Structure cleared.";emit changed();}
void StructureController::insert(int value,int position){
    if(m_kind=="Linked List"){
        bool ok=position<0?false:position==0?(m_list.insertBeginning(value),true):position==m_list.size()?(m_list.insertEnd(value),true):m_list.insertAt(static_cast<std::size_t>(position),value);
        m_status=ok?QString("Inserted %1 at position %2.").arg(value).arg(position):"Position is outside the list bounds.";
    }else if(m_kind=="Stack"){m_stack.push(value);m_status=QString("Pushed %1 onto the top.").arg(value);}
    else if(m_kind=="Queue"){m_queue.enqueue(value);m_status=QString("Enqueued %1 at the rear.").arg(value);}
    else {m_status=m_tree.insert(value)?QString("Inserted %1 into the BST.").arg(value):"Duplicate values are ignored in this BST.";}
    emit changed();
}
void StructureController::remove(int position){
    if(m_kind=="Linked List")m_status=m_list.eraseAt(position)?QString("Deleted the node at position %1.").arg(position):"Position is outside the list bounds.";
    else if(m_kind=="Stack"){try{m_status=QString("Popped %1 from the top.").arg(m_stack.pop());}catch(const std::underflow_error&){m_status="Cannot pop: the stack is empty.";}}
    else if(m_kind=="Queue"){try{m_status=QString("Dequeued %1 from the front.").arg(m_queue.dequeue());}catch(const std::underflow_error&){m_status="Cannot dequeue: the queue is empty.";}}
    else m_status="Delete is not included in this Binary Search Tree demo.";
    emit changed();
}
void StructureController::search(int value){if(m_kind=="Linked List"){int i=m_list.find(value);m_status=i<0?QString("%1 is not in the list.").arg(value):QString("Found %1 at position %2.").arg(value).arg(i);}else if(m_kind=="Binary Search Tree")m_status=m_tree.contains(value)?QString("%1 exists in the tree.").arg(value):QString("%1 is not in the tree.").arg(value);else m_status=QString("Front/top value is %1.").arg(values().isEmpty()?QString("(empty)"):values().first().toString());emit changed();}
void StructureController::traverse(const QString&order){if(m_kind!="Binary Search Tree"){m_status=QString("Current order: %1").arg([&]{QStringList x;for(auto v:values())x<<v.toString();return x.join(" → ");}());}else{std::vector<int> v=order=="Preorder"?m_tree.preorder():order=="Postorder"?m_tree.postorder():m_tree.inorder();QStringList x;for(int n:v)x<<QString::number(n);m_status=order+": "+x.join(" → ");}emit changed();}
