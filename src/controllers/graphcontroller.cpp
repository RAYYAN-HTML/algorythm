#include "graphcontroller.h"
#include <algorithm>
#include <functional>
#include <limits>
#include <queue>
#include <utility>
#include <QVariantMap>

GraphController::GraphController(QObject*p):QObject(p){
    m_edges={{0,1,4},{0,2,2},{1,3,5},{2,3,1},{2,4,7},{3,5,2},{4,5,1},{5,6,3}};
    m_timer.setInterval(650);connect(&m_timer,&QTimer::timeout,this,[this]{if(m_index+1<m_steps.size())++m_index;else m_timer.stop();emit changed();});run(0);
}
void GraphController::setSpeed(qreal speed){m_speed=qBound<qreal>(0.5,speed,3.0);m_timer.setInterval(qMax(100,int(650/m_speed)));emit changed();}
const GraphStep&GraphController::current()const{static GraphStep empty;return m_steps.isEmpty()?empty:m_steps[qBound(0,m_index,m_steps.size()-1)];}
QVariantList GraphController::visited()const{QVariantList a;for(int v:current().visited)a<<v;return a;}
QVariantList GraphController::discovered()const{QVariantList a;for(int v:current().discovered)a<<v;return a;}
int GraphController::active()const{return current().active;}int GraphController::edgeTo()const{return current().edgeTo;}QString GraphController::narration()const{return current().narration;}int GraphController::edgesExamined()const{return current().edges;}
QStringList GraphController::distances()const{QStringList a;for(auto d:current().distances)a<<(d>=std::numeric_limits<long long>::max()/8?QStringLiteral("∞"):QString::number(d));return a;}
QStringList GraphController::previousNodes()const{QStringList a;for(int node:current().previous)a<< (node<0?QStringLiteral("—"):QString::number(node));return a;}
QStringList GraphController::priorityQueue()const{return current().priorityQueue;}
QVariantList GraphController::edgeList()const{QVariantList a;for(auto e:m_edges){QVariantMap m;m["from"]=e.from;m["to"]=e.to;m["weight"]=e.weight;a<<m;}return a;}
QVariantMap GraphController::configuration()const{return {{"nodeCount",m_nodeCount},{"startNode",m_startNode},{"edges",edgeList()}};}
bool GraphController::restoreConfiguration(const QVariantMap&configuration){
    const int nodeCount=configuration.value("nodeCount").toInt();
    const int startNode=configuration.value("startNode").toInt();
    const QVariantList edgeValues=configuration.value("edges").toList();
    if(nodeCount<2||nodeCount>12||startNode<0||startNode>=nodeCount||edgeValues.size()>nodeCount*(nodeCount-1)/2){
        emit error("The saved graph configuration has invalid node or start-node values.");
        return false;
    }
    QVector<Edge> restoredEdges;
    restoredEdges.reserve(edgeValues.size());
    for(const QVariant&value:edgeValues){
        const QVariantMap edge=value.toMap();
        if(!edge.contains("from")||!edge.contains("to")||!edge.contains("weight")){
            emit error("The saved graph contains an incomplete edge.");
            return false;
        }
        const int from=edge.value("from").toInt();
        const int to=edge.value("to").toInt();
        const int weight=edge.value("weight").toInt();
        if(from<0||to<0||from>=nodeCount||to>=nodeCount||from==to||weight<0){
            emit error("The saved graph contains an invalid edge.");
            return false;
        }
        const bool duplicate=std::any_of(restoredEdges.cbegin(),restoredEdges.cend(),[from,to](const Edge&candidate){
            return (candidate.from==from&&candidate.to==to)||(candidate.from==to&&candidate.to==from);
        });
        if(duplicate){
            emit error("The saved graph contains the same undirected edge more than once.");
            return false;
        }
        restoredEdges<<Edge{from,to,weight};
    }
    m_edges=std::move(restoredEdges);
    m_nodeCount=nodeCount;
    run(startNode);
    return true;
}
QVariantList GraphController::shortestPathTo(int destination)const{
    QVariantList path;
    if(m_algorithm!="Dijkstra's Shortest Path"||destination<0||destination>=current().distances.size()||current().distances[destination]>=std::numeric_limits<long long>::max()/8)return path;
    int node=destination;
    for(int remaining=current().previous.size()+1;remaining>0&&node>=0;--remaining){path.prepend(node);if(node>=current().previous.size())return {};node=current().previous[node];}
    if(path.isEmpty()||path.first().toInt()!=m_steps.first().active)return {};
    return path;
}
void GraphController::run(int start){
    if(start<0||start>=m_nodeCount){emit error(QString("Choose a start node from 0 to %1.").arg(m_nodeCount-1));return;}
    m_startNode=start;m_timer.stop();m_steps.clear();m_index=0;const int n=m_nodeCount;
    QVector<QVector<QPair<int,int>>>adj(n);for(auto e:m_edges){adj[e.from].push_back({e.to,e.weight});adj[e.to].push_back({e.from,e.weight});}
    QVector<bool>seen(n,false);QVector<int>visited;QVector<int>previous(n,-1);QStringList queued;int examined=0;QVector<long long>dist(n,std::numeric_limits<long long>::max()/4);
    auto save=[&](int active,int to,const QString&text){GraphStep s;s.active=active;s.edgeTo=to;s.visited=visited;for(int node=0;node<n;++node)if(seen[node]||dist[node]<std::numeric_limits<long long>::max()/8)s.discovered<<node;s.distances=dist;s.previous=previous;s.priorityQueue=queued;s.edges=examined;s.narration=text;m_steps.push_back(s);};
    if(m_algorithm=="Breadth-First Search"){
        std::queue<int>q;q.push(start);seen[start]=true;save(start,-1,QString("Start BFS at node %1 and add it to the queue.").arg(start));
        while(!q.empty()){int v=q.front();q.pop();visited<<v;save(v,-1,QString("Visit node %1. Its unvisited neighbors join the queue.").arg(v));for(auto[to,w]:adj[v]){(void)w;++examined;save(v,to,QString("Examine edge %1 → %2.").arg(v).arg(to));if(!seen[to]){seen[to]=true;q.push(to);}}}
    }else if(m_algorithm=="Depth-First Search"){
        std::function<void(int)>dfs=[&](int v){seen[v]=true;visited<<v;save(v,-1,QString("Visit node %1 and explore its neighbors deeply.").arg(v));for(auto[to,w]:adj[v]){(void)w;++examined;save(v,to,QString("Examine edge %1 → %2.").arg(v).arg(to));if(!seen[to])dfs(to);}};dfs(start);
    }else{
        using E=QPair<long long,int>;std::priority_queue<E,std::vector<E>,std::greater<E>>q;
        auto snapshotQueue=[&](){auto copy=q;queued.clear();while(!copy.empty()){const auto [distance,node]=copy.top();copy.pop();queued<<QStringLiteral("%1:%2").arg(node).arg(distance);}};
        dist[start]=0;q.push({0,start});snapshotQueue();save(start,-1,QString("Set the start node %1 distance to 0 and enqueue it.").arg(start));
        while(!q.empty()){auto[d,v]=q.top();q.pop();snapshotQueue();if(d!=dist[v]||seen[v])continue;seen[v]=true;visited<<v;save(v,-1,QString("Settle node %1 with distance %2.").arg(v).arg(d));for(auto[to,w]:adj[v]){++examined;save(v,to,QString("Check edge weight %1 from %2 to %3.").arg(w).arg(v).arg(to));if(d+w<dist[to]){dist[to]=d+w;previous[to]=v;q.push({dist[to],to});snapshotQueue();save(v,to,QString("Update node %1 distance to %2 and add it to the priority queue.").arg(to).arg(dist[to]));}}}
    }
    GraphStep done=current();done.active=-1;done.edgeTo=-1;done.visited=visited;done.discovered.clear();for(int node=0;node<n;++node)if(seen[node]||dist[node]<std::numeric_limits<long long>::max()/8)done.discovered<<node;done.distances=dist;done.previous=previous;done.edges=examined;done.narration=m_algorithm+" complete.";m_steps<<done;emit changed();
}
void GraphController::next(){m_timer.stop();if(m_index+1<m_steps.size())++m_index;emit changed();}
void GraphController::previous(){m_timer.stop();if(m_index>0)--m_index;emit changed();}
void GraphController::restart(){m_timer.stop();m_index=0;emit changed();}
void GraphController::playPause(){if(m_timer.isActive())m_timer.stop();else if(m_index+1<m_steps.size())m_timer.start();emit changed();}
bool GraphController::addEdge(int from,int to,int weight){
    const int maxUndirectedEdges=m_nodeCount*(m_nodeCount-1)/2;
    if(from<0||to<0||from>=m_nodeCount||to>=m_nodeCount||from==to||weight<0){emit error(QString("Edge endpoints must be between 0 and %1, endpoints must differ, and weight must be nonnegative.").arg(m_nodeCount-1));return false;}
    if(m_edges.size()>=maxUndirectedEdges){emit error(QString("The graph already has all %1 possible undirected edges.").arg(maxUndirectedEdges));return false;}
    for(const Edge& edge:m_edges){
        if((edge.from==from&&edge.to==to)||(edge.from==to&&edge.to==from)){
            emit error("That undirected edge already exists.");
            return false;
        }
    }
    m_edges<<Edge{from,to,weight};run(m_startNode);return true;
}
bool GraphController::removeEdge(int from,int to){
    if(from<0||to<0||from>=m_nodeCount||to>=m_nodeCount||from==to){
        emit error(QString("Choose two different nodes from 0 to %1.").arg(m_nodeCount-1));
        return false;
    }
    const auto edge=std::find_if(m_edges.begin(),m_edges.end(),[from,to](const Edge&candidate){
        return (candidate.from==from&&candidate.to==to)||(candidate.from==to&&candidate.to==from);
    });
    if(edge==m_edges.end()){
        emit error("There is no edge between those nodes to remove.");
        return false;
    }
    m_edges.erase(edge);
    run(m_startNode);
    return true;
}
bool GraphController::addNode(){
    constexpr int maximumNodes=12;
    if(m_nodeCount>=maximumNodes){
        emit error(QString("The custom graph supports at most %1 nodes.").arg(maximumNodes));
        return false;
    }
    ++m_nodeCount;
    run(m_startNode);
    return true;
}
bool GraphController::removeNode(int node){
    constexpr int minimumNodes=2;
    if(node<0||node>=m_nodeCount){
        emit error(QString("Choose a node from 0 to %1.").arg(m_nodeCount-1));
        return false;
    }
    if(m_nodeCount<=minimumNodes){
        emit error(QString("A graph must keep at least %1 nodes.").arg(minimumNodes));
        return false;
    }
    m_edges.erase(std::remove_if(m_edges.begin(),m_edges.end(),[node](const Edge&edge){
        return edge.from==node||edge.to==node;
    }),m_edges.end());
    for(Edge&edge:m_edges){
        if(edge.from>node)--edge.from;
        if(edge.to>node)--edge.to;
    }
    --m_nodeCount;
    if(m_startNode>node)--m_startNode;
    else if(m_startNode==node)m_startNode=qMin(node,m_nodeCount-1);
    run(m_startNode);
    emit nodeRemoved(node);
    return true;
}
