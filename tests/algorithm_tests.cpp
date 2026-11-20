#include "algorithms/bubblesort.h"
#include "engine/playbackcontroller.h"
#include "datastructures/structures.h"
#include "controllers/structurecontroller.h"
#include "controllers/graphcontroller.h"
#include "controllers/settingscontroller.h"
#include <QCoreApplication>
#include <QSettings>
#include <QTemporaryDir>
#include <algorithm>
#ifdef NDEBUG
#undef NDEBUG
#endif
#include <cassert>
#include <QEventLoop>
#include <QTimer>

static void waitMs(int ms)
{
    QEventLoop loop;
    QTimer::singleShot(ms, &loop, &QEventLoop::quit);
    loop.exec();
}

int main(int argc, char **argv)
{
    QCoreApplication app(argc, argv);
    app.setOrganizationName("Algorythm Tests");
    app.setApplicationName("Settings Controller Tests");
    QSettings::setDefaultFormat(QSettings::IniFormat);
    QTemporaryDir settingsDirectory;
    assert(settingsDirectory.isValid());
    QSettings::setPath(QSettings::IniFormat, QSettings::UserScope, settingsDirectory.path());

    SettingsController settings;
    assert(!settings.reducedMotion());
    assert(qFuzzyCompare(settings.playbackSpeed(), 1.0));
    assert(!settings.sidebarCollapsed());
    settings.setPlaybackSpeed(0.1);
    assert(qFuzzyCompare(settings.playbackSpeed(), 0.5));
    settings.setPlaybackSpeed(4.0);
    assert(qFuzzyCompare(settings.playbackSpeed(), 3.0));
    settings.setPlaybackSpeed(1.5);
    settings.setReducedMotion(true);
    settings.setSidebarCollapsed(true);
    settings.saveWorkspaceState(QVariantList{0.25, 0.75});
    SettingsController restoredSettings;
    assert(qFuzzyCompare(restoredSettings.playbackSpeed(), 1.5));
    assert(restoredSettings.reducedMotion());
    assert(restoredSettings.sidebarCollapsed());
    assert(restoredSettings.workspaceState().toList().size() == 2);
    settings.resetPreferences();
    assert(!restoredSettings.reducedMotion());
    assert(qFuzzyCompare(restoredSettings.playbackSpeed(), 1.0));
    assert(!restoredSettings.sidebarCollapsed());
    assert(!restoredSettings.workspaceState().isValid());

    const QStringList algorithms = SortingAlgorithms::names();
    const QVector<QVector<int>> cases = {
        {}, {5}, {2, 1}, {1, 2, 3, 4}, {4, 3, 2, 1}, {3, 1, 3, -2, 0, -2}
    };
    for (const QString &algorithm : algorithms) {
        bool sawAlgorithmState = false;
        for (const auto &input : cases) {
            const auto trace = SortingAlgorithms::generate(algorithm, input);
            assert(!trace.isEmpty());
            assert(trace.first().values == input);
            assert(trace.last().complete);
            auto expected = input;
            std::sort(expected.begin(), expected.end());
            assert(trace.last().values == expected);
            for (const auto &step : trace) {
                assert(step.values.size() == input.size());
                assert(step.nodeIds.size() == input.size());
                assert(step.comparisons >= 0 && step.swaps >= 0 && step.writes >= 0);
                assert(step.variables.contains("comparisons"));
                assert(step.variables.contains("array"));
                sawAlgorithmState = sawAlgorithmState || step.variables.contains("i") || step.variables.contains("pivot") || step.variables.contains("key") || step.variables.contains("writeIndex");
                auto ids = step.nodeIds;
                std::sort(ids.begin(), ids.end());
                for (int i = 0; i < ids.size(); ++i) {
                    assert(ids[i] == i);
                }
                for (int i = 0; i < step.values.size(); ++i) assert(step.values[i] == input[step.nodeIds[i]]);
            }
        }
        assert(sawAlgorithmState);
    }
    SinglyLinkedList list;
    assert(list.insertAt(0, 5)); assert(list.insertAt(1, 8)); assert(list.insertAt(1, 6));
    assert((list.values() == std::vector<int>{5,6,8})); assert(list.find(6)==1); assert(!list.insertAt(5,4));
    assert(list.eraseAt(1)); assert(!list.eraseAt(5)); assert((list.values()==std::vector<int>{5,8}));
    LinkedStack stack; bool underflow=false; try{stack.pop();}catch(const std::underflow_error&){underflow=true;} assert(underflow);
    stack.push(2); stack.push(7); assert(stack.peek()==7); assert(stack.pop()==7); assert(stack.pop()==2);
    LinkedQueue queue; underflow=false; try{queue.dequeue();}catch(const std::underflow_error&){underflow=true;} assert(underflow);
    queue.enqueue(3);queue.enqueue(9);assert(queue.peek()==3);assert(queue.dequeue()==3);assert(queue.dequeue()==9);assert(queue.hasValidEnds());
    BinarySearchTree tree;for(int v:{5,3,7,2,4,6,8})assert(tree.insert(v));assert(!tree.insert(5));assert(tree.contains(4));assert(!tree.contains(9));
    assert((tree.inorder()==std::vector<int>{2,3,4,5,6,7,8}));assert((tree.preorder()==std::vector<int>{5,3,2,4,7,6,8}));assert((tree.postorder()==std::vector<int>{2,4,3,6,8,7,5}));
    WeightedGraph graph(5);assert(graph.addEdge(0,1,4));assert(graph.addEdge(0,2,1));assert(graph.addEdge(2,1,2));assert(graph.addEdge(1,3,1));
    assert((graph.bfs(0)==std::vector<int>{0,1,2,3}));assert((graph.dfs(0)==std::vector<int>{0,1,2,3}));
    const auto distances=graph.dijkstra(0);assert(distances[0]==0&&distances[1]==3&&distances[2]==1&&distances[3]==4);assert(distances[4]>1000000);
    assert(!graph.addEdge(0,4,-1));assert(graph.dijkstra(9).empty());
    for (const QString &algorithm : {QString("Linear Search"), QString("Binary Search")}) {
        const QVector<int> searchInput{9,3,5,3,1};
        for (int target : {3, 77}) {
            auto trace=SortingAlgorithms::search(algorithm,searchInput,target);
            assert(!trace.isEmpty()&&trace.last().complete);
            for (const auto &step : trace) {
                assert(step.nodeIds.size() == step.values.size());
                assert(step.variables.contains("target"));
                assert(step.variables.contains("array"));
                for (int i = 0; i < step.values.size(); ++i) assert(step.values[i] == searchInput[step.nodeIds[i]]);
            }
            assert(trace.last().comparisons<=5);
            if(algorithm=="Binary Search")assert(std::is_sorted(trace.last().values.begin(),trace.last().values.end()));
            const bool found=std::find(trace.last().values.begin(),trace.last().values.end(),target)!=trace.last().values.end();
            assert((trace.last().operation=="Target found")==found);
        }
    }
    StructureController controller;
    controller.reset();
    assert(controller.visualModel()->rowCount()==0);
    controller.insert(4,0);controller.insert(2,1);assert(controller.values().size()==2);
    assert(controller.visualModel()->rowCount()==2);
    assert(controller.visualModel()->data(controller.visualModel()->index(0),StructureVisualModel::ValueRole).toInt()==4);
    controller.remove(9);assert(controller.status().contains("outside"));assert(controller.visualModel()->rowCount()==2);
    controller.remove(0);assert(controller.visualModel()->rowCount()==1);
    controller.setKind("Stack");assert(controller.visualModel()->rowCount()==3);controller.remove();assert(controller.visualModel()->rowCount()==2);
    controller.insert(42);controller.search(0);assert(controller.values().first().toInt()==42);
    assert(controller.visualModel()->rowCount()==3&&controller.visualModel()->data(controller.visualModel()->index(0),StructureVisualModel::ValueRole).toInt()==42);
    controller.remove();controller.remove();controller.remove();controller.remove();assert(controller.status().contains("empty"));
    controller.setKind("Queue");controller.reset();controller.insert(6);controller.insert(7);assert(controller.visualModel()->rowCount()==2);
    assert(controller.visualModel()->data(controller.visualModel()->index(1),StructureVisualModel::ValueRole).toInt()==7);
    controller.remove();assert(controller.visualModel()->rowCount()==1);
    controller.setKind("Binary Search Tree");assert(controller.treeNodes().size()==7);assert(controller.treeVisualModel()->rowCount()==7);
    controller.insert(1);assert(controller.treeVisualModel()->rowCount()==8);
    assert(controller.status().contains("Inserted"));
    controller.insert(-100);assert(controller.status().contains("four levels"));assert(controller.treeVisualModel()->rowCount()==8);
    GraphController graphController;
    graphController.setSpeed(2.0); assert(qFuzzyCompare(graphController.speed(), 2.0));
    graphController.setSpeed(4.0); assert(qFuzzyCompare(graphController.speed(), 3.0));
    graphController.setAlgorithm("Dijkstra's Shortest Path");
    while(graphController.stepIndex()+1<graphController.stepCount())graphController.next();
    assert(graphController.distances().size()==7&&graphController.distances()[6]=="8");
    assert(!graphController.addEdge(0,9,3));assert(graphController.addEdge(0,6,5));

    PlaybackController playback;
    assert(playback.nodes()->rowCount() == 7);
    assert(playback.nodes()->data(playback.nodes()->index(0), AlgorithmNodeModel::ValueRole).toInt() == 8);
    playback.next(); assert(playback.stepIndex() == 1); assert(playback.variables().contains("i"));
    playback.previous(); assert(playback.stepIndex() == 0); assert(playback.variables().contains("n")); assert(!playback.variables().contains("i"));
    playback.seek(3); assert(playback.stepIndex() == 3);
    playback.restart(); assert(playback.stepIndex() == 0);
    playback.setSpeed(3.0); assert(playback.speed() == 3.0);
    playback.playPause(); assert(playback.playing());
    waitMs(260); const int pausedAt = playback.stepIndex(); assert(pausedAt > 0);
    playback.playPause(); assert(!playback.playing());
    waitMs(260); assert(playback.stepIndex() == pausedAt);
    playback.playPause(); waitMs(260); assert(playback.stepIndex() > pausedAt);
    playback.playPause();
    playback.seek(playback.stepCount() - 2);
    playback.playPause(); waitMs(260);
    assert(playback.complete()); assert(!playback.playing());
    return 0;
}
