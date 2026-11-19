#include "graphcontroller.h"
#include <algorithm>
#include <functional>
#include <limits>
#include <queue>
#include <QVariantMap>

GraphController::GraphController(QObject*p):QObject(p){
    m_edges={{0,1,4},{0,2,2},{1,3,5},{2,3,1},{2,4,7},{3,5,2},{4,5,1},{5,6,3}};
    m_timer.setInterval(650);connect(&m_timer,&QTimer::timeout,this,[this]{if(m_index+1<m_steps.size())++m_index;else m_timer.stop();emit changed();});run(0);
}
const GraphStep&GraphController::current()const{static GraphStep empty;return m_steps.isEmpty()?empty:m_steps[qBound(0,m_index,m_steps.size()-1)];}
QVariantList GraphController::visited()const{QVariantList a;for(int v:current().visited)a<<v;return a;}
int GraphController::active()const{return current().active;}int GraphController::edgeTo()const{return current().edgeTo;}QString GraphController::narration()const{return current().narration;}int GraphController::edgesExamined()const{return current().edges;}
QStringList GraphController::distances()const{QStringList a;for(auto d:current().distances)a<<(d>=std::numeric_limits<long long>::max()/8?QStringLiteral("∞"):QString::number(d));return a;}
QVariantList GraphController::edgeList()const{QVariantList a;for(auto e:m_edges){QVariantMap m;m["from"]=e.from;m["to"]=e.to;m["weight"]=e.weight;a<<m;}return a;}
void GraphController::run(int start){
    m_timer.stop();m_steps.clear();m_index=0;const int n=7;if(start<0||start>=n){emit error("Choose a start node from 0 to 6.");return;}
    QVector<QVector<QPair<int,int>>>adj(n);for(auto e:m_edges){adj[e.from].push_back({e.to,e.weight});adj[e.to].push_back({e.from,e.weight});}
    QVector<bool>seen(n,false);QVector<int>visited;int examined=0;QVector<long long>dist(n,std::numeric_limits<long long>::max()/4);
    auto save=[&](int active,int to,const QString&text){GraphStep s;s.active=active;s.edgeTo=to;s.visited=visited;s.distances=dist;s.edges=examined;s.narration=text;m_steps.push_back(s);};
    if(m_algorithm=="Breadth-First Search"){
        std::queue<int>q;q.push(start);seen[start]=true;save(start,-1,QString("Start BFS at node %1 and add it to the queue.").arg(start));
        while(!q.empty()){int v=q.front();q.pop();visited<<v;save(v,-1,QString("Visit node %1. Its unvisited neighbors join the queue.").arg(v));for(auto[to,w]:adj[v]){(void)w;++examined;save(v,to,QString("Examine edge %1 → %2.").arg(v).arg(to));if(!seen[to]){seen[to]=true;q.push(to);}}}
    }else if(m_algorithm=="Depth-First Search"){
        std::function<void(int)>dfs=[&](int v){seen[v]=true;visited<<v;save(v,-1,QString("Visit node %1 and explore its neighbors deeply.").arg(v));for(auto[to,w]:adj[v]){(void)w;++examined;save(v,to,QString("Examine edge %1 → %2.").arg(v).arg(to));if(!seen[to])dfs(to);}};dfs(start);
    }else{
        using E=QPair<long long,int>;std::priority_queue<E,std::vector<E>,std::greater<E>>q;dist[start]=0;q.push({0,start});save(start,-1,QString("Set the start node %1 distance to 0.").arg(start));
        while(!q.empty()){auto[d,v]=q.top();q.pop();if(d!=dist[v]||seen[v])continue;seen[v]=true;visited<<v;save(v,-1,QString("Settle node %1 with distance %2.").arg(v).arg(d));for(auto[to,w]:adj[v]){++examined;save(v,to,QString("Check edge weight %1 from %2 to %3.").arg(w).arg(v).arg(to));if(d+w<dist[to]){dist[to]=d+w;q.push({dist[to],to});save(v,to,QString("Update node %1 distance to %2.").arg(to).arg(dist[to]));}}}
    }
    GraphStep done=current();done.active=-1;done.edgeTo=-1;done.visited=visited;done.distances=dist;done.edges=examined;done.narration=m_algorithm+" complete.";m_steps<<done;emit changed();
}
void GraphController::next(){m_timer.stop();if(m_index+1<m_steps.size())++m_index;emit changed();}
void GraphController::previous(){m_timer.stop();if(m_index>0)--m_index;emit changed();}
void GraphController::restart(){m_timer.stop();m_index=0;emit changed();}
void GraphController::playPause(){if(m_timer.isActive())m_timer.stop();else if(m_index+1<m_steps.size())m_timer.start();emit changed();}
bool GraphController::addEdge(int from,int to,int weight){if(from<0||to<0||from>=7||to>=7||from==to||weight<0){emit error("Edge endpoints must be nodes 0–6 and weight must be nonnegative.");return false;}m_edges<<Edge{from,to,weight};run(0);return true;}
