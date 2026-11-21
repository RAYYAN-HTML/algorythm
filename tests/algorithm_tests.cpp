#include "algorithms/sortingalgorithms.h"
#include "engine/playbackcontroller.h"
#include "datastructures/structures.h"
#include "controllers/structurecontroller.h"
#include "controllers/graphcontroller.h"
#include "controllers/settingscontroller.h"
#include <QSettings>
#include <QTemporaryDir>
#include <algorithm>
#include <QTest>
#include <QSignalSpy>
#include <QPersistentModelIndex>
#include <QEventLoop>
#include <QTimer>
#include <initializer_list>

static bool variantListMatchesInts(const QVariantList &actual, std::initializer_list<int> expected)
{
    if (actual.size() != static_cast<qsizetype>(expected.size())) return false;
    auto value = expected.begin();
    for (const QVariant &entry : actual) {
        if (entry.toInt() != *value++) return false;
    }
    return true;
}

static void waitMs(int ms)
{
    QEventLoop loop;
    QTimer::singleShot(ms, &loop, &QEventLoop::quit);
    loop.exec();
}

class AlgorithmTests : public QObject
{
    Q_OBJECT

private slots:
    void initTestCase()
    {
        QCoreApplication::setOrganizationName("Algorythm Tests");
        QCoreApplication::setApplicationName("Settings Controller Tests");
    }

    void allAlgorithmsControllersAndPlayback()
    {
    QSettings::setDefaultFormat(QSettings::IniFormat);
    QTemporaryDir settingsDirectory;
    QVERIFY(settingsDirectory.isValid());
    QSettings::setPath(QSettings::IniFormat, QSettings::UserScope, settingsDirectory.path());

    SettingsController settings;
    QVERIFY(!settings.reducedMotion());
    QVERIFY(qFuzzyCompare(settings.playbackSpeed(), 1.0));
    QVERIFY(!settings.sidebarCollapsed());
    settings.setPlaybackSpeed(0.1);
    QVERIFY(qFuzzyCompare(settings.playbackSpeed(), 0.5));
    settings.setPlaybackSpeed(4.0);
    QVERIFY(qFuzzyCompare(settings.playbackSpeed(), 3.0));
    settings.setPlaybackSpeed(1.5);
    settings.setReducedMotion(true);
    settings.setSidebarCollapsed(true);
    settings.saveWorkspaceState(QVariantList{0.25, 0.75});
    const QVariantMap quickSortActivity{{"section", "Sorting"}, {"algorithm", "Quick Sort"}, {"input", "8, 3, -1"}};
    settings.recordRecentActivity(quickSortActivity);
    settings.recordRecentActivity(QVariantMap{{"section", "Searching"}, {"algorithm", "Binary Search"}, {"input", "1, 3, 8"}, {"target", 3}});
    const QVariantMap savedGraph{{"nodeCount", 3}, {"startNode", 1}, {"edges", QVariantList{QVariantMap{{"from", 0}, {"to", 1}, {"weight", 4}}}}, {"destinationNode", 2}};
    settings.recordRecentActivity(QVariantMap{{"section", "Graphs"}, {"algorithm", "Dijkstra's Shortest Path"}, {"graph", savedGraph}});
    settings.recordRecentActivity(quickSortActivity);
    QVERIFY(settings.recentActivities().size() == 3);
    QVERIFY(settings.recentActivities().first().toMap().value("algorithm").toString() == "Quick Sort");
    SettingsController restoredSettings;
    QVERIFY(qFuzzyCompare(restoredSettings.playbackSpeed(), 1.5));
    QVERIFY(restoredSettings.reducedMotion());
    QVERIFY(restoredSettings.sidebarCollapsed());
    QVERIFY(restoredSettings.workspaceState().toList().size() == 2);
    QVERIFY(restoredSettings.recentActivities() == settings.recentActivities());
    QVERIFY(restoredSettings.recentActivities().at(2).toMap().value("target").toInt() == 3);
    QVERIFY(restoredSettings.recentActivities().at(1).toMap().value("graph").toMap() == savedGraph);
    settings.resetPreferences();
    QVERIFY(!restoredSettings.reducedMotion());
    QVERIFY(qFuzzyCompare(restoredSettings.playbackSpeed(), 1.0));
    QVERIFY(!restoredSettings.sidebarCollapsed());
    QVERIFY(!restoredSettings.workspaceState().isValid());
    QVERIFY(restoredSettings.recentActivities().isEmpty());

    const QStringList algorithms = SortingAlgorithms::names();
    const QVector<QVector<int>> cases = {
        {}, {5}, {2, 1}, {1, 2, 3, 4}, {4, 3, 2, 1}, {3, 1, 3, -2, 0, -2},
        {16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1}
    };
    for (const QString &algorithm : algorithms) {
        bool sawAlgorithmState = false;
        const int pseudocodeLineCount = algorithm == "Bubble Sort" ? 7 : algorithm == "Selection Sort" || algorithm == "Insertion Sort" ? 5 : 6;
        for (const auto &input : cases) {
            const auto trace = SortingAlgorithms::generate(algorithm, input);
            QVERIFY(!trace.isEmpty());
            QVERIFY(trace.first().values == input);
            QVERIFY(trace.last().complete);
            auto expected = input;
            std::sort(expected.begin(), expected.end());
            QVERIFY(trace.last().values == expected);
            for (const auto &step : trace) {
                QVERIFY(step.values.size() == input.size());
                QVERIFY(step.nodeIds.size() == input.size());
                QVERIFY(step.comparisons >= 0 && step.swaps >= 0 && step.writes >= 0);
                QVERIFY(step.variables.contains("comparisons"));
                QVERIFY(step.variables.contains("array"));
                QVERIFY(step.pseudocodeLine >= 0 && step.pseudocodeLine <= pseudocodeLineCount);
                QVERIFY(!step.operation.isEmpty());
                QVERIFY(!step.narration.isEmpty());
                QVERIFY(!step.why.isEmpty());
                sawAlgorithmState = sawAlgorithmState || step.variables.contains("i") || step.variables.contains("pivot") || step.variables.contains("key") || step.variables.contains("writeIndex");
                auto ids = step.nodeIds;
                std::sort(ids.begin(), ids.end());
                for (int i = 0; i < ids.size(); ++i) {
                    QVERIFY(ids[i] == i);
                }
                for (int i = 0; i < step.values.size(); ++i) QVERIFY(step.values[i] == input[step.nodeIds[i]]);
            }
        }
        QVERIFY(sawAlgorithmState);
    }
    SinglyLinkedList list;
    QVERIFY(list.insertAt(0, 5)); QVERIFY(list.insertAt(1, 8)); QVERIFY(list.insertAt(1, 6));
    QVERIFY((list.values() == std::vector<int>{5,6,8})); QVERIFY(list.find(6)==1); QVERIFY(!list.insertAt(5,4));
    QVERIFY(list.eraseAt(1)); QVERIFY(!list.eraseAt(5)); QVERIFY((list.values()==std::vector<int>{5,8}));
    LinkedStack stack; bool underflow=false; try{stack.pop();}catch(const std::underflow_error&){underflow=true;} QVERIFY(underflow);
    stack.push(2); stack.push(7); QVERIFY(stack.peek()==7); QVERIFY(stack.pop()==7); QVERIFY(stack.pop()==2);
    LinkedQueue queue; underflow=false; try{queue.dequeue();}catch(const std::underflow_error&){underflow=true;} QVERIFY(underflow);
    queue.enqueue(3);queue.enqueue(9);QVERIFY(queue.peek()==3);QVERIFY(queue.dequeue()==3);QVERIFY(queue.dequeue()==9);QVERIFY(queue.hasValidEnds());
    BinarySearchTree tree;for(int v:{5,3,7,2,4,6,8})QVERIFY(tree.insert(v));QVERIFY(!tree.insert(5));QVERIFY(tree.contains(4));QVERIFY(!tree.contains(9));
    QVERIFY((tree.inorder()==std::vector<int>{2,3,4,5,6,7,8}));QVERIFY((tree.preorder()==std::vector<int>{5,3,2,4,7,6,8}));QVERIFY((tree.postorder()==std::vector<int>{2,4,3,6,8,7,5}));
    QVERIFY((tree.levelorder()==std::vector<int>{5,3,7,2,4,6,8}));
    QVERIFY(tree.erase(2)); // leaf
    QVERIFY(!tree.contains(2));
    QVERIFY(tree.erase(3)); // one child
    QVERIFY((tree.inorder()==std::vector<int>{4,5,6,7,8}));
    QVERIFY(tree.erase(5)); // root with two children
    QVERIFY((tree.inorder()==std::vector<int>{4,6,7,8}));
    QVERIFY(!tree.erase(99));
    WeightedGraph graph(5);QVERIFY(graph.addEdge(0,1,4));QVERIFY(graph.addEdge(0,2,1));QVERIFY(graph.addEdge(2,1,2));QVERIFY(graph.addEdge(1,3,1));
    QVERIFY((graph.bfs(0)==std::vector<int>{0,1,2,3}));QVERIFY((graph.dfs(0)==std::vector<int>{0,1,2,3}));
    const auto distances=graph.dijkstra(0);QVERIFY(distances[0]==0&&distances[1]==3&&distances[2]==1&&distances[3]==4);QVERIFY(distances[4]>1000000);
    QVERIFY(!graph.addEdge(0,4,-1));QVERIFY(graph.dijkstra(9).empty());
    for (const QString &algorithm : {QString("Linear Search"), QString("Binary Search")}) {
        const QVector<int> searchInput{9,3,5,3,1};
        for (int target : {3, 77}) {
            auto trace=SortingAlgorithms::search(algorithm,searchInput,target);
            QVERIFY(!trace.isEmpty()&&trace.last().complete);
            for (const auto &step : trace) {
                QVERIFY(step.nodeIds.size() == step.values.size());
                QVERIFY(step.variables.contains("target"));
                QVERIFY(step.variables.contains("array"));
                QVERIFY(step.pseudocodeLine >= 0 && step.pseudocodeLine <= (algorithm == "Linear Search" ? 4 : 6));
                QVERIFY(!step.operation.isEmpty());
                QVERIFY(!step.narration.isEmpty());
                QVERIFY(!step.why.isEmpty());
                for (int i = 0; i < step.values.size(); ++i) QVERIFY(step.values[i] == searchInput[step.nodeIds[i]]);
            }
            QVERIFY(trace.last().comparisons<=5);
            if(algorithm=="Binary Search")QVERIFY(std::is_sorted(trace.last().values.begin(),trace.last().values.end()));
            const bool found=std::find(trace.last().values.begin(),trace.last().values.end(),target)!=trace.last().values.end();
            QVERIFY((trace.last().operation=="Target found")==found);
        }
        const auto emptyTrace = SortingAlgorithms::search(algorithm, {}, 3);
        QVERIFY(!emptyTrace.isEmpty());
        QVERIFY(emptyTrace.last().complete);
        QVERIFY(emptyTrace.last().operation != "Target found");
        const auto singleTrace = SortingAlgorithms::search(algorithm, {3}, 3);
        QVERIFY(singleTrace.last().complete);
        QVERIFY(singleTrace.last().operation == "Target found");
    }
    StructureController controller;
    controller.reset();
    QVERIFY(controller.visualModel()->rowCount()==0);
    controller.insert(4,0);controller.insert(2,1);QVERIFY(controller.values().size()==2);
    QVERIFY(controller.visualModel()->rowCount()==2);
    QVERIFY(controller.visualModel()->data(controller.visualModel()->index(0),StructureVisualModel::ValueRole).toInt()==4);
    controller.remove(9);QVERIFY(controller.status().contains("outside"));QVERIFY(controller.visualModel()->rowCount()==2);
    controller.remove(0);QVERIFY(controller.visualModel()->rowCount()==1);
    controller.setKind("Stack");QVERIFY(controller.visualModel()->rowCount()==3);controller.remove();QVERIFY(controller.visualModel()->rowCount()==2);
    controller.insert(42);controller.search(0);QVERIFY(controller.values().first().toInt()==42);
    QVERIFY(controller.visualModel()->rowCount()==3&&controller.visualModel()->data(controller.visualModel()->index(0),StructureVisualModel::ValueRole).toInt()==42);
    controller.remove();controller.remove();controller.remove();controller.remove();QVERIFY(controller.status().contains("empty"));
    controller.setKind("Queue");controller.reset();controller.insert(6);controller.insert(7);QVERIFY(controller.visualModel()->rowCount()==2);
    QVERIFY(controller.visualModel()->data(controller.visualModel()->index(1),StructureVisualModel::ValueRole).toInt()==7);
    controller.remove();QVERIFY(controller.visualModel()->rowCount()==1);
    controller.setKind("Binary Search Tree");QVERIFY(controller.treeNodes().size()==7);QVERIFY(controller.treeVisualModel()->rowCount()==7);
    controller.traverse("Level-order");
    QVERIFY(controller.traversalValue()==8 && controller.traversalIndex()==0 && controller.traversalCount()==7);
    controller.previousTraversalStep();
    QVERIFY(controller.traversalIndex()==0);
    controller.nextTraversalStep();
    QVERIFY(controller.traversalIndex()==1 && controller.traversalValue()==4);
    controller.previousTraversalStep();
    QVERIFY(controller.traversalIndex()==0);
    controller.restartTraversal();
    QVERIFY(controller.traversalIndex()==0 && controller.traversalValue()==8);
    controller.traverse("Level-order");
    QTRY_VERIFY_WITH_TIMEOUT(controller.traversalIndex()>=1, 1500);
    controller.restartTraversal();
    QVERIFY(controller.traversalIndex()==0);
    controller.insert(1);QVERIFY(controller.treeVisualModel()->rowCount()==8);
    QVERIFY(controller.status().contains("Inserted"));
    controller.insert(-100);QVERIFY(controller.status().contains("four levels"));QVERIFY(controller.treeVisualModel()->rowCount()==8);
    controller.traverse("Inorder");
    QVERIFY(controller.traversalCount()==8);
    controller.remove(4);
    QVERIFY(controller.status().contains("Deleted 4"));
    QVERIFY(controller.treeVisualModel()->rowCount()==7);
    QVERIFY(!controller.values().contains(4));
    QVERIFY(controller.traversalCount()==0);
    QVERIFY(controller.treeVisualModel()->data(controller.treeVisualModel()->index(0),TreeVisualModel::ValueRole).toInt()!=4);
    controller.remove(99);
    QVERIFY(controller.status().contains("not in the tree"));
    GraphController graphController;
    QString invalidStartError;
    QObject::connect(&graphController,&GraphController::error,[&](const QString&message){invalidStartError=message;});
    const int graphStepCountBeforeInvalidRun=graphController.stepCount();
    const QString graphNarrationBeforeInvalidRun=graphController.narration();
    graphController.run(7);
    QVERIFY(invalidStartError.contains("start node"));
    QVERIFY(graphController.stepCount()==graphStepCountBeforeInvalidRun);
    QVERIFY(graphController.narration()==graphNarrationBeforeInvalidRun);
    graphController.setSpeed(2.0); QVERIFY(qFuzzyCompare(graphController.speed(), 2.0));
    graphController.setSpeed(4.0); QVERIFY(qFuzzyCompare(graphController.speed(), 3.0));
    graphController.setAlgorithm("Dijkstra's Shortest Path");
    QVERIFY(graphController.priorityQueue() == QStringList({"0:0"}));
    QVERIFY(graphController.visited().isEmpty());
    QVERIFY(variantListMatchesInts(graphController.discovered(), {0}));
    while(graphController.distances()[1] == "∞" && graphController.stepIndex()+1<graphController.stepCount())graphController.next();
    QVERIFY(graphController.distances()[1] == "4");
    QVERIFY(!graphController.priorityQueue().isEmpty());
    QVERIFY(!graphController.visited().contains(1));
    while(!graphController.visited().contains(1) && graphController.stepIndex()+1<graphController.stepCount())graphController.next();
    QVERIFY(graphController.visited().contains(1));
    graphController.restart();
    while(graphController.stepIndex()+1<graphController.stepCount())graphController.next();
    QVERIFY(graphController.distances().size()==7&&graphController.distances()[6]=="8");
    QVERIFY(graphController.previousNodes()[6] == "5");
    const QVariantList shortestPath = graphController.shortestPathTo(6);
    QVERIFY(variantListMatchesInts(shortestPath, {0, 2, 3, 5, 6}));
    QVERIFY(graphController.shortestPathTo(7).isEmpty());
    graphController.run(1);
    while(graphController.stepIndex()+1<graphController.stepCount())graphController.next();
    const QVariantList rerunPath = graphController.shortestPathTo(6);
    QVERIFY(!rerunPath.isEmpty() && rerunPath.first().toInt() == 1 && rerunPath.last().toInt() == 6);
    const int graphEdgeCountBeforeInvalidEdges = graphController.edgeList().size();
    QVERIFY(!graphController.addEdge(2, 2, 1));
    QVERIFY(!graphController.addEdge(0, 6, -1));
    QVERIFY(graphController.edgeList().size() == graphEdgeCountBeforeInvalidEdges);
    QVERIFY(!graphController.addEdge(0,9,3));QVERIFY(graphController.addEdge(0,6,5));
    const int graphEdgesWithAddedEdge = graphController.edgeList().size();
    QVERIFY(!graphController.removeEdge(0,4));
    QVERIFY(graphController.edgeList().size() == graphEdgesWithAddedEdge);
    while(graphController.stepIndex() + 1 < graphController.stepCount()) graphController.next();
    QVERIFY(variantListMatchesInts(graphController.shortestPathTo(6), {1, 0, 6}));
    QVERIFY(graphController.removeEdge(6,0));
    QVERIFY(graphController.edgeList().size() == graphEdgesWithAddedEdge - 1);
    while(graphController.stepIndex() + 1 < graphController.stepCount()) graphController.next();
    QVERIFY(variantListMatchesInts(graphController.shortestPathTo(6), {1, 3, 5, 6}));
    QVERIFY(!graphController.removeEdge(0,9));
    GraphController discoveryGraph;
    QVERIFY(variantListMatchesInts(discoveryGraph.discovered(), {0}));
    while(discoveryGraph.discovered().size()<3&&discoveryGraph.stepIndex()+1<discoveryGraph.stepCount())discoveryGraph.next();
    QVERIFY(discoveryGraph.discovered().contains(1));
    QVERIFY(discoveryGraph.discovered().contains(2));
    GraphController graphConfigurationSource;
    QVERIFY(graphConfigurationSource.addNode());
    QVERIFY(graphConfigurationSource.addEdge(0, 7, 11));
    graphConfigurationSource.run(7);
    const QVariantMap savedGraphConfiguration=graphConfigurationSource.configuration();
    GraphController graphConfigurationTarget;
    QVERIFY(graphConfigurationTarget.restoreConfiguration(savedGraphConfiguration));
    QVERIFY(graphConfigurationTarget.nodeCount()==8);
    QVERIFY(graphConfigurationTarget.edgeList()==graphConfigurationSource.edgeList());
    QVERIFY(graphConfigurationTarget.configuration().value("startNode").toInt()==7);
    QVariantMap invalidGraphConfiguration=savedGraphConfiguration;
    QVariantList duplicateEdges=invalidGraphConfiguration.value("edges").toList();
    duplicateEdges<<duplicateEdges.first();
    invalidGraphConfiguration.insert("edges",duplicateEdges);
    const QVariantMap graphBeforeInvalidRestore=graphConfigurationTarget.configuration();
    QVERIFY(!graphConfigurationTarget.restoreConfiguration(invalidGraphConfiguration));
    QVERIFY(graphConfigurationTarget.configuration()==graphBeforeInvalidRestore);
    GraphController boundedGraph;
    QString graphError;
    QObject::connect(&boundedGraph,&GraphController::error,[&](const QString&message){graphError=message;});
    const int initialEdgeCount=boundedGraph.edgeList().size();
    QVERIFY(!boundedGraph.addEdge(1,0,4));
    QVERIFY(graphError.contains("already exists")&&boundedGraph.edgeList().size()==initialEdgeCount);
    int additionalEdges=0;
    for(int from=0;from<7;++from)for(int to=from+1;to<7;++to)if(boundedGraph.addEdge(from,to,1))++additionalEdges;
    QVERIFY(additionalEdges==21-initialEdgeCount&&boundedGraph.edgeList().size()==21);
    QVERIFY(!boundedGraph.addEdge(0,6,2));
    QVERIFY(graphError.contains("all 21")&&boundedGraph.edgeList().size()==21);

    GraphController maximumGraph;
    QObject::connect(&maximumGraph,&GraphController::error,[&](const QString&message){graphError=message;});
    while(maximumGraph.nodeCount()<12)QVERIFY(maximumGraph.addNode());
    const int initialMaximumGraphEdges=maximumGraph.edgeList().size();
    int successfulMaximumGraphEdges=0;
    for(int from=0;from<12;++from)for(int to=from+1;to<12;++to)
        if(maximumGraph.addEdge(from,to,1))++successfulMaximumGraphEdges;
    QVERIFY(successfulMaximumGraphEdges==66-initialMaximumGraphEdges&&maximumGraph.edgeList().size()==66);
    QVERIFY(!maximumGraph.addEdge(0,11,1));
    QVERIFY(graphError.contains("all 66")&&maximumGraph.edgeList().size()==66);

    GraphController editableGraph;
    editableGraph.setAlgorithm("Dijkstra's Shortest Path");
    QVERIFY(editableGraph.addNode());
    QVERIFY(editableGraph.nodeCount() == 8);
    editableGraph.run(1);
    QVERIFY(editableGraph.addEdge(1,7,5));
    while(editableGraph.stepIndex()+1<editableGraph.stepCount())editableGraph.next();
    QVERIFY(variantListMatchesInts(editableGraph.shortestPathTo(7), {1,7}));
    QSignalSpy nodeRemovalSpy(&editableGraph,&GraphController::nodeRemoved);
    QVERIFY(editableGraph.removeNode(2));
    QVERIFY(nodeRemovalSpy.count()==1&&nodeRemovalSpy.takeFirst().at(0).toInt()==2);
    QVERIFY(editableGraph.nodeCount() == 7);
    while(editableGraph.stepIndex()+1<editableGraph.stepCount())editableGraph.next();
    QVERIFY(variantListMatchesInts(editableGraph.shortestPathTo(6), {1,6}));
    for(const QVariant &edgeValue:editableGraph.edgeList()){
        const QVariantMap edge=edgeValue.toMap();
        QVERIFY(edge.value("from").toInt()<editableGraph.nodeCount());
        QVERIFY(edge.value("to").toInt()<editableGraph.nodeCount());
    }
    QVERIFY(!editableGraph.removeNode(-1));
    QVERIFY(!editableGraph.removeNode(editableGraph.nodeCount()));
    while(editableGraph.nodeCount()<12)QVERIFY(editableGraph.addNode());
    QVERIFY(!editableGraph.addNode());
    while(editableGraph.nodeCount()>2)QVERIFY(editableGraph.removeNode(editableGraph.nodeCount()-1));
    QVERIFY(editableGraph.nodeCount()==2);
    QVERIFY(!editableGraph.removeNode(0));

    PlaybackController playback;
    PlaybackController variableModelPlayback;
    QAbstractListModel *variableEntries = variableModelPlayback.variableEntries();
    QVERIFY(variableEntries->rowCount() > 0);
    const auto variableRoles = variableEntries->roleNames();
    QVERIFY(variableRoles.values().contains("variableName"));
    QVERIFY(variableRoles.values().contains("variableValue"));
    QVERIFY(variableRoles.values().contains("variableVisible"));
    QSignalSpy variableResetSpy(variableEntries, &QAbstractItemModel::modelReset);
    QSignalSpy variableChangedSpy(variableEntries, &QAbstractItemModel::dataChanged);
    variableModelPlayback.selectAlgorithm("Merge Sort");
    int stableStep = -1;
    QVariantMap previousVariables;
    for (int step = 0; step < variableModelPlayback.stepCount(); ++step) {
        variableModelPlayback.seek(step);
        const QVariantMap currentVariables = variableModelPlayback.variables();
        if (step > 0 && currentVariables.keys() == previousVariables.keys() && currentVariables != previousVariables) {
            stableStep = step - 1;
            break;
        }
        previousVariables = currentVariables;
    }
    QVERIFY(stableStep >= 0);
    variableModelPlayback.seek(stableStep);
    variableResetSpy.clear();
    variableChangedSpy.clear();
    QPersistentModelIndex stableVariableIndex(variableEntries->index(0, 0));
    variableModelPlayback.next();
    QCOMPARE(variableResetSpy.count(), 0);
    QVERIFY(stableVariableIndex.isValid());
    QVERIFY(!variableEntries->data(stableVariableIndex, PlaybackVariableModel::VariableNameRole).toString().isEmpty());
    QVERIFY(variableChangedSpy.count() > 0);
    variableModelPlayback.selectAlgorithm("Linear Search");
    QCOMPARE(variableResetSpy.count(), 1);

    variableModelPlayback.selectAlgorithm("Bubble Sort");
    variableResetSpy.clear();
    variableChangedSpy.clear();
    int optionalVariableStep = -1;
    for (int step = 1; step < variableModelPlayback.stepCount(); ++step) {
        variableModelPlayback.seek(step - 1);
        const QVariantMap previous = variableModelPlayback.variables();
        variableModelPlayback.seek(step);
        const QVariantMap current = variableModelPlayback.variables();
        if (!previous.contains("left") && current.contains("left")) {
            optionalVariableStep = step - 1;
            break;
        }
    }
    QVERIFY(optionalVariableStep >= 0);
    variableModelPlayback.seek(optionalVariableStep);
    int leftRow = -1;
    for (int row = 0; row < variableEntries->rowCount(); ++row) {
        if (variableEntries->data(variableEntries->index(row, 0), PlaybackVariableModel::VariableNameRole).toString() == "left") {
            leftRow = row;
            break;
        }
    }
    QVERIFY(leftRow >= 0);
    const QPersistentModelIndex optionalVariableIndex(variableEntries->index(leftRow, 0));
    QVERIFY(!variableEntries->data(optionalVariableIndex, PlaybackVariableModel::VariableVisibleRole).toBool());
    variableResetSpy.clear();
    variableChangedSpy.clear();
    variableModelPlayback.next();
    QCOMPARE(variableResetSpy.count(), 0);
    QVERIFY(optionalVariableIndex.isValid());
    QVERIFY(variableEntries->data(optionalVariableIndex, PlaybackVariableModel::VariableVisibleRole).toBool());
    QVERIFY(variableChangedSpy.count() > 0);

    QVERIFY(playback.nodes()->rowCount() == 7);
    QVERIFY(playback.nodes()->data(playback.nodes()->index(0), AlgorithmNodeModel::ValueRole).toInt() == 8);
    playback.previous();
    QVERIFY(playback.stepIndex() == 0);
    playback.seek(-20);
    QVERIFY(playback.stepIndex() == 0);
    const auto acceptedValues = playback.values();
    QString inputError;
    QObject::connect(&playback, &PlaybackController::inputError, [&](const QString &message) { inputError = message; });
    QVERIFY(!playback.sortInput("1, invalid, 3"));
    QVERIFY(!inputError.isEmpty());
    QVERIFY(playback.values() == acceptedValues);
    QVERIFY(playback.sortInput("9, 3, 5"));
    QVERIFY(playback.values().size() == 3);
    PlaybackController searchPlayback;
    searchPlayback.selectAlgorithm("Linear Search");
    QVERIFY(searchPlayback.sortInput("9, 1, 5"));
    searchPlayback.setSearchTarget(1);
    QVERIFY(searchPlayback.variables().value("target").toInt() == 1);
    QVERIFY(searchPlayback.narration().contains("look for 1"));
    playback.next(); QVERIFY(playback.stepIndex() == 1); QVERIFY(playback.variables().contains("i"));
    playback.previous(); QVERIFY(playback.stepIndex() == 0); QVERIFY(playback.variables().contains("n")); QVERIFY(!playback.variables().contains("i"));
    playback.seek(3); QVERIFY(playback.stepIndex() == 3);
    playback.restart(); QVERIFY(playback.stepIndex() == 0);
    playback.setSpeed(3.0); QVERIFY(playback.speed() == 3.0);
    playback.setSpeed(20.0); QVERIFY(playback.speed() == 3.0);
    playback.setSpeed(1.0);
    playback.playPause(); QVERIFY(playback.playing());
    QTRY_VERIFY_WITH_TIMEOUT(playback.stepIndex() > 0, 1800);
    const int pausedAt = playback.stepIndex();
    playback.pausePlayback(); QVERIFY(!playback.playing());
    waitMs(260); QVERIFY(playback.stepIndex() == pausedAt);
    playback.startPlayback(); QVERIFY(playback.playing());
    QTRY_VERIFY_WITH_TIMEOUT(playback.stepIndex() > pausedAt, 1800);
    playback.pausePlayback();
    playback.startPlayback();
    playback.selectAlgorithm("Insertion Sort");
    QVERIFY(!playback.playing());
    QVERIFY(playback.stepIndex() == 0);
    QVERIFY(playback.algorithm() == "Insertion Sort");
    playback.seek(playback.stepCount() - 2);
    playback.playPause();
    QTRY_VERIFY_WITH_TIMEOUT(playback.complete(), 1800);
    QVERIFY(!playback.playing());

    PlaybackController comparisonA, comparisonB;
    comparisonA.selectAlgorithm("Bubble Sort");
    comparisonB.selectAlgorithm("Insertion Sort");
    QVERIFY(comparisonA.sortInput("7, 2, 5, 2, -1"));
    QVERIFY(comparisonB.sortInput("7, 2, 5, 2, -1"));
    QVERIFY(comparisonA.values() == comparisonB.values());
    QVERIFY(comparisonA.stepCount() > 0 && comparisonB.stepCount() > 0);
    comparisonA.seek(comparisonA.stepCount() - 1);
    comparisonB.seek(comparisonB.stepCount() - 1);
    QVERIFY(comparisonA.complete() && comparisonB.complete());
    QVERIFY(comparisonA.values() == comparisonB.values());
    QVERIFY(comparisonA.comparisons() >= 0 && comparisonB.comparisons() >= 0);
    comparisonA.restart();
    comparisonB.restart();
    comparisonA.startPlayback();
    comparisonB.pausePlayback();
    QVERIFY(comparisonA.playing() && !comparisonB.playing());
    // Run Both must promote the paused controller even when its peer is already running.
    comparisonB.startPlayback();
    QVERIFY(comparisonA.playing() && comparisonB.playing());
    comparisonA.pausePlayback();
    QVERIFY(!comparisonA.playing() && comparisonB.playing());
    comparisonA.startPlayback();
    QVERIFY(comparisonA.playing() && comparisonB.playing());
    comparisonA.pausePlayback();
    comparisonB.pausePlayback();
    comparisonA.seek(comparisonA.stepCount() - 1);
    comparisonB.seek(comparisonB.stepCount() - 1);
    QVERIFY(comparisonA.complete() && comparisonB.complete());
    comparisonA.restart();
    comparisonB.restart();
    comparisonA.startPlayback();
    comparisonB.startPlayback();
    QVERIFY(comparisonA.playing() && comparisonB.playing());
    comparisonA.pausePlayback();
    comparisonB.pausePlayback();
    }
};

int main(int argc, char **argv)
{
    QCoreApplication application(argc, argv);
    application.setOrganizationName("Algorythm Tests");
    application.setApplicationName("Settings Controller Tests");
    AlgorithmTests tests;
    return QTest::qExec(&tests, argc, argv);
}
#include "algorithm_tests.moc"
