#pragma once
#include "datastructures/structures.h"
#include <QObject>
#include <QAbstractListModel>
#include <QVariantList>
#include <QTimer>
#include <QVector>

class StructureVisualModel : public QAbstractListModel {
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged)
public:
    enum Role { ValueRole = Qt::UserRole + 1 };
    explicit StructureVisualModel(QObject *parent = nullptr) : QAbstractListModel(parent) {}
    int rowCount(const QModelIndex &parent = {}) const override { return parent.isValid() ? 0 : m_values.size(); }
    int count() const { return m_values.size(); }
    QVariant data(const QModelIndex &index, int role) const override {
        if (!index.isValid() || index.row() < 0 || index.row() >= m_values.size()) return {};
        return role == ValueRole ? QVariant(m_values.at(index.row())) : QVariant();
    }
    QHash<int, QByteArray> roleNames() const override { return {{ValueRole, "value"}}; }
    void resetValues(const QVariantList &values);
    void insertValue(int row, int value);
    void removeValue(int row);
signals:
    void countChanged();
private:
    QList<int> m_values;
};

class TreeVisualModel : public QAbstractListModel {
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged)
public:
    enum Role { ValueRole = Qt::UserRole + 1, PositionXRole, PositionYRole };
    explicit TreeVisualModel(QObject *parent = nullptr) : QAbstractListModel(parent) {}
    int rowCount(const QModelIndex &parent = {}) const override { return parent.isValid() ? 0 : static_cast<int>(m_nodes.size()); }
    int count() const { return static_cast<int>(m_nodes.size()); }
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override { return {{ValueRole, "value"}, {PositionXRole, "posX"}, {PositionYRole, "posY"}}; }
    void resetNodes(const QVariantList &nodes);
    void syncNodes(const QVariantList &nodes);
signals:
    void countChanged();
private:
    QList<QVariantMap> m_nodes;
};

class StructureController : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString kind READ kind WRITE setKind NOTIFY changed)
    Q_PROPERTY(QVariantList values READ values NOTIFY changed)
    Q_PROPERTY(QVariantList treeNodes READ treeNodes NOTIFY changed)
    Q_PROPERTY(QString status READ status NOTIFY changed)
    Q_PROPERTY(int size READ size NOTIFY changed)
    Q_PROPERTY(int traversalValue READ traversalValue NOTIFY changed)
    Q_PROPERTY(int traversalIndex READ traversalIndex NOTIFY changed)
    Q_PROPERTY(int traversalCount READ traversalCount NOTIFY changed)
    Q_PROPERTY(QVariantList traversal READ traversal NOTIFY changed)
    Q_PROPERTY(StructureVisualModel* visualModel READ visualModel CONSTANT)
    Q_PROPERTY(TreeVisualModel* treeVisualModel READ treeVisualModel CONSTANT)
public:
    explicit StructureController(QObject *p=nullptr);
    QString kind()const{return m_kind;}
    void setKind(const QString&k);
    QVariantList values()const;
    QVariantList treeNodes()const;
    QString status()const{return m_status;}
    int size()const;
    int traversalValue()const{return m_traversalIndex>=0&&m_traversalIndex<m_traversal.size()?m_traversal[m_traversalIndex]:-1;}
    int traversalIndex()const{return m_traversalIndex;}
    int traversalCount()const{return m_traversal.size();}
    QVariantList traversal()const{QVariantList result;for(int value:m_traversal)result<<value;return result;}
    StructureVisualModel *visualModel() { return &m_visualModel; }
    TreeVisualModel *treeVisualModel() { return &m_treeVisualModel; }
    Q_INVOKABLE void reset();
    Q_INVOKABLE void insert(int value,int position=0);
    Q_INVOKABLE void remove(int position=0);
    Q_INVOKABLE void search(int value);
    Q_INVOKABLE void traverse(const QString&order="Inorder");
    Q_INVOKABLE void nextTraversalStep();
    Q_INVOKABLE void previousTraversalStep();
    Q_INVOKABLE void restartTraversal();
signals:void changed();
private:
    QString m_kind="Linked List",m_status="Ready. Choose an operation.";
    SinglyLinkedList m_list; LinkedStack m_stack; LinkedQueue m_queue; BinarySearchTree m_tree;
    QVector<int> m_traversal;
    QString m_traversalOrder;
    int m_traversalIndex=-1;
    QTimer m_traversalTimer;
    StructureVisualModel m_visualModel;
    TreeVisualModel m_treeVisualModel;
};
