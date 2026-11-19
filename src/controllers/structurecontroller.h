#pragma once
#include "datastructures/structures.h"
#include <QObject>
#include <QVariantList>

class StructureController : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString kind READ kind WRITE setKind NOTIFY changed)
    Q_PROPERTY(QVariantList values READ values NOTIFY changed)
    Q_PROPERTY(QVariantList treeNodes READ treeNodes NOTIFY changed)
    Q_PROPERTY(QString status READ status NOTIFY changed)
    Q_PROPERTY(int size READ size NOTIFY changed)
public:
    explicit StructureController(QObject *p=nullptr);
    QString kind()const{return m_kind;}
    void setKind(const QString&k);
    QVariantList values()const;
    QVariantList treeNodes()const;
    QString status()const{return m_status;}
    int size()const;
    Q_INVOKABLE void reset();
    Q_INVOKABLE void insert(int value,int position=0);
    Q_INVOKABLE void remove(int position=0);
    Q_INVOKABLE void search(int value);
    Q_INVOKABLE void traverse(const QString&order="Inorder");
signals:void changed();
private:
    QString m_kind="Linked List",m_status="Ready. Choose an operation.";
    SinglyLinkedList m_list; LinkedStack m_stack; LinkedQueue m_queue; BinarySearchTree m_tree;
};
