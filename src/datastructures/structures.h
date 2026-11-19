#pragma once

#include <functional>
#include <limits>
#include <memory>
#include <queue>
#include <stdexcept>
#include <utility>
#include <vector>

struct TreeVisualNode { int value; int depth; int position; };

class SinglyLinkedList {
    struct Node { int value; std::unique_ptr<Node> next; explicit Node(int v) : value(v) {} };
    std::unique_ptr<Node> head;
    std::size_t count = 0;
public:
    std::size_t size() const { return count; }
    std::vector<int> values() const { std::vector<int> out; for (auto *p=head.get();p;p=p->next.get()) out.push_back(p->value); return out; }
    void insertBeginning(int value) { auto n=std::make_unique<Node>(value); n->next=std::move(head); head=std::move(n); ++count; }
    void insertEnd(int value) { auto n=std::make_unique<Node>(value); Node *p=head.get(); if(!p) head=std::move(n); else {while(p->next)p=p->next.get();p->next=std::move(n);} ++count; }
    bool insertAt(std::size_t index,int value) { if(index>count)return false; if(index==0){insertBeginning(value);return true;} Node*p=head.get();for(std::size_t i=1;i<index;++i)p=p->next.get();auto n=std::make_unique<Node>(value);n->next=std::move(p->next);p->next=std::move(n);++count;return true; }
    bool eraseAt(std::size_t index) { if(index>=count)return false; if(index==0)head=std::move(head->next);else{Node*p=head.get();for(std::size_t i=1;i<index;++i)p=p->next.get();p->next=std::move(p->next->next);}--count;return true; }
    int find(int value) const { int i=0;for(auto*p=head.get();p;p=p->next.get(),++i)if(p->value==value)return i;return -1; }
};

class LinkedStack {
    struct Node { int value; std::unique_ptr<Node> next; explicit Node(int v):value(v){} };
    std::unique_ptr<Node> topNode; std::size_t count=0;
public:
    std::size_t size() const{return count;} bool empty()const{return count==0;}
    void push(int value){auto n=std::make_unique<Node>(value);n->next=std::move(topNode);topNode=std::move(n);++count;}
    int pop(){if(empty())throw std::underflow_error("pop from empty stack");int v=topNode->value;topNode=std::move(topNode->next);--count;return v;}
    int peek()const{if(empty())throw std::underflow_error("peek at empty stack");return topNode->value;}
    std::vector<int> values()const{std::vector<int> o;for(auto*p=topNode.get();p;p=p->next.get())o.push_back(p->value);return o;}
};

class LinkedQueue {
    struct Node { int value; Node *next=nullptr; explicit Node(int v):value(v){} };
    Node *frontNode=nullptr,*rearNode=nullptr; std::size_t count=0;
public:
    ~LinkedQueue(){while(frontNode){Node*n=frontNode->next;delete frontNode;frontNode=n;}}
    LinkedQueue()=default; LinkedQueue(const LinkedQueue&)=delete; LinkedQueue&operator=(const LinkedQueue&)=delete;
    std::size_t size()const{return count;} bool empty()const{return count==0;}
    void enqueue(int v){auto*n=new Node(v);if(rearNode)rearNode->next=n;else frontNode=n;rearNode=n;++count;}
    int dequeue(){if(empty())throw std::underflow_error("dequeue from empty queue");Node*n=frontNode;int v=n->value;frontNode=n->next;if(!frontNode)rearNode=nullptr;delete n;--count;return v;}
    int peek()const{if(empty())throw std::underflow_error("peek at empty queue");return frontNode->value;}
    void clear(){while(frontNode){Node*n=frontNode->next;delete frontNode;frontNode=n;}rearNode=nullptr;count=0;}
    std::vector<int> values()const{std::vector<int>o;for(Node*p=frontNode;p;p=p->next)o.push_back(p->value);return o;}
    bool hasValidEnds()const{return (count==0)==(frontNode==nullptr&&rearNode==nullptr);}
};

class BinarySearchTree {
    struct Node { int value;std::unique_ptr<Node>left,right;explicit Node(int v):value(v){} };
    std::unique_ptr<Node> root;
    template<class F> static void walk(const Node*n,F visit,int order){if(!n)return;if(order==0)visit(n->value);walk(n->left.get(),visit,order);if(order==1)visit(n->value);walk(n->right.get(),visit,order);if(order==2)visit(n->value);}
public:
    bool insert(int v){auto*link=&root;while(*link){if((*link)->value==v)return false;link=(v<(*link)->value)?&(*link)->left:&(*link)->right;}*link=std::make_unique<Node>(v);return true;}
    bool contains(int v)const{auto*n=root.get();while(n){if(n->value==v)return true;n=v<n->value?n->left.get():n->right.get();}return false;}
    std::vector<int> inorder()const{std::vector<int>o;walk(root.get(),[&](int v){o.push_back(v);},1);return o;}
    std::vector<int> preorder()const{std::vector<int>o;walk(root.get(),[&](int v){o.push_back(v);},0);return o;}
    std::vector<int> postorder()const{std::vector<int>o;walk(root.get(),[&](int v){o.push_back(v);},2);return o;}
    std::vector<TreeVisualNode> visual()const{std::vector<TreeVisualNode> out;if(!root)return out;struct Entry{const Node*n;int depth;int pos;};std::queue<Entry>q;q.push({root.get(),0,0});while(!q.empty()){auto e=q.front();q.pop();out.push_back({e.n->value,e.depth,e.pos});if(e.n->left)q.push({e.n->left.get(),e.depth+1,e.pos*2});if(e.n->right)q.push({e.n->right.get(),e.depth+1,e.pos*2+1});}return out;}
};

class WeightedGraph {
    std::vector<std::vector<std::pair<int,int>>> edges;
public:
    explicit WeightedGraph(int vertices=0):edges(vertices){}
    int size()const{return static_cast<int>(edges.size());}
    bool addEdge(int from,int to,int weight,bool undirected=true){if(from<0||to<0||from>=size()||to>=size()||weight<0)return false;edges[from].push_back({to,weight});if(undirected)edges[to].push_back({from,weight});return true;}
    std::vector<int> bfs(int start)const{if(start<0||start>=size())return{};std::vector<bool>seen(size());std::queue<int>q;std::vector<int>out;seen[start]=true;q.push(start);while(!q.empty()){int v=q.front();q.pop();out.push_back(v);for(auto [to,w]:edges[v]){(void)w;if(!seen[to]){seen[to]=true;q.push(to);}}}return out;}
    std::vector<int> dfs(int start)const{if(start<0||start>=size())return{};std::vector<bool>seen(size());std::vector<int>out;std::function<void(int)>visit=[&](int v){seen[v]=true;out.push_back(v);for(auto[to,w]:edges[v]){(void)w;if(!seen[to])visit(to);}};visit(start);return out;}
    std::vector<long long> dijkstra(int start)const{if(start<0||start>=size())return{};const auto inf=std::numeric_limits<long long>::max()/4;std::vector<long long>d(size(),inf);using Entry=std::pair<long long,int>;std::priority_queue<Entry,std::vector<Entry>,std::greater<Entry>>q;d[start]=0;q.push({0,start});while(!q.empty()){auto[dist,v]=q.top();q.pop();if(dist!=d[v])continue;for(auto[to,w]:edges[v])if(dist+w<d[to]){d[to]=dist+w;q.push({d[to],to});}}return d;}
};
