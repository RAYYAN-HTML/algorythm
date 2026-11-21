#pragma once
#include <QObject>
#include <QTimer>
#include <QVariantList>
#include <QVariantMap>
#include <QVector>
#include <QStringList>

struct GraphStep { int active=-1; int edgeTo=-1; QVector<int> visited; QVector<int> discovered; QVector<long long> distances; QVector<int> previous; QStringList priorityQueue; int edges=0; QString narration; };

class GraphController : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString algorithm READ algorithm WRITE setAlgorithm NOTIFY changed)
    Q_PROPERTY(QVariantList visited READ visited NOTIFY changed)
    Q_PROPERTY(QVariantList discovered READ discovered NOTIFY changed)
    Q_PROPERTY(int active READ active NOTIFY changed)
    Q_PROPERTY(int edgeTo READ edgeTo NOTIFY changed)
    Q_PROPERTY(QString narration READ narration NOTIFY changed)
    Q_PROPERTY(int edgesExamined READ edgesExamined NOTIFY changed)
    Q_PROPERTY(int stepIndex READ stepIndex NOTIFY changed)
    Q_PROPERTY(int stepCount READ stepCount NOTIFY changed)
    Q_PROPERTY(bool playing READ playing NOTIFY changed)
    Q_PROPERTY(qreal speed READ speed WRITE setSpeed NOTIFY changed)
    Q_PROPERTY(QStringList distances READ distances NOTIFY changed)
    Q_PROPERTY(QStringList previousNodes READ previousNodes NOTIFY changed)
    Q_PROPERTY(QStringList priorityQueue READ priorityQueue NOTIFY changed)
    Q_PROPERTY(QVariantList edgeList READ edgeList NOTIFY changed)
    Q_PROPERTY(int nodeCount READ nodeCount NOTIFY changed)
public:
    explicit GraphController(QObject *parent=nullptr);
    QString algorithm()const{return m_algorithm;}
    void setAlgorithm(const QString&a){if(m_algorithm==a)return;m_algorithm=a;run(m_startNode);}
    QVariantList visited()const;
    QVariantList discovered()const;
    int active()const;
    int edgeTo()const;
    QString narration()const;
    int edgesExamined()const;
    int stepIndex()const{return m_index;}
    int stepCount()const{return m_steps.size();}
    bool playing()const{return m_timer.isActive();}
    qreal speed()const{return m_speed;}
    void setSpeed(qreal speed);
    QStringList distances()const;
    QStringList previousNodes()const;
    QStringList priorityQueue()const;
    QVariantList edgeList()const;
    int nodeCount() const { return m_nodeCount; }
    Q_INVOKABLE void run(int start);
    Q_INVOKABLE void next();
    Q_INVOKABLE void previous();
    Q_INVOKABLE void restart();
    Q_INVOKABLE void playPause();
    Q_INVOKABLE bool addEdge(int from,int to,int weight);
    Q_INVOKABLE bool removeEdge(int from,int to);
    Q_INVOKABLE bool addNode();
    Q_INVOKABLE bool removeNode(int node);
    Q_INVOKABLE QVariantList shortestPathTo(int destination) const;
    Q_INVOKABLE QVariantMap configuration() const;
    Q_INVOKABLE bool restoreConfiguration(const QVariantMap &configuration);
signals:void changed();void error(const QString&message);void nodeRemoved(int node);
private:
    struct Edge{int from,to,weight;};
    QVector<Edge>m_edges;
    QVector<GraphStep>m_steps;
    QString m_algorithm="Breadth-First Search";
    int m_nodeCount=7;
    int m_startNode=0;
    int m_index=0;
    QTimer m_timer;
    qreal m_speed=1.0;
    const GraphStep&current()const;
};
