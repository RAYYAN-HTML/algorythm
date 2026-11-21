# Algorythm architecture

## Execution and playback

Sorting and searching algorithms generate `QVector<ExecutionStep>` traces in C++. Each step contains the current value order, the stable ID of each value, active indices, pseudocode line, cumulative counters, narration, explanation, a variable snapshot, and completion state. Stable IDs make the positions animatable independently of the current order. Variable snapshots are captured in each frame, so rewind and timeline seeking restore loop indices, search bounds, pivots, keys, merge cursors, counters, and the displayed array without recomputing state.

`PlaybackController` owns a trace, timer, and `AlgorithmNodeModel`. The node model is reset only for new input. On seek, rewind, stepping, or timed playback, the controller updates each stable node's target position. `dataChanged` notifies QML while retaining existing delegates. `AlgorithmNode` applies eased position and color Behaviors; reduced-motion settings disable node color transitions and the visual state is also identified with symbols. The presentation timer runs more slowly than the position transition at each speed setting.

Graphs use a dedicated `GraphController` and `GraphStep` snapshots. Traversal states drive active/visited node feedback and active edge highlights; discovered nodes are separately captured for BFS/DFS prediction prompts. The builder supports 2–12 nodes and weighted undirected edges. Node removal deletes incident edges and renumbers remaining endpoints and selected nodes; every graph edit rebuilds the trace while preserving a valid start node. Data structures use `StructureController` and expose current values and tree links to their page. BST deletion handles leaf, one-child, and two-child nodes in the C++ tree; `TreeVisualModel` emits row removals and position updates so QML delegates stay synchronized.

QML playback controls receive their controller and settings object as explicit properties. Comparison playback has a separate reusable footer that keeps both traces at one speed and persists that preference. Prediction prompts are selected from the current trace operation, allowing each sorting implementation and the search algorithms to ask questions that match the next recorded decision.

`StructurePredictionChallenge` reuses `StructureController` state for stack and queue removal questions. For BST questions it asks the controller to build the selected traversal, stops before the next timed visit, and only restarts the traversal after the learner answers.

`SettingsController` stores up to ten recently explored labs in `QSettings`. Sorting and searching history includes the selected algorithm, input, and search target. Graph history includes the selected algorithm, node count, weighted undirected edges, start node, and destination. `GraphController::restoreConfiguration` validates the complete graph before replacing the active graph; the dashboard routes resume actions through normal section navigation before restoring the configuration.

## Main classes

- `ExecutionStep` and `AlgorithmNodeModel`: trace frame data and stable animation identity.
- `SortingAlgorithms` / `BubbleSort`: sorting and search traces.
- `PlaybackController`: playback, speed, trace selection, and model updates.
- `VariablesPanel`: current trace-frame variables, synchronized to the same `PlaybackController` state as the node model and pseudocode.
- `AlgorithmNode`: reusable circular node.
- `GraphController`: BFS, DFS, Dijkstra, graph editing, and playback.
- `StructureController`: list, stack, queue, and tree operations.
- `qml/Main.qml`: app shell and section navigation.

## Testing

The C++ Qt Test case in `tests/algorithm_tests.cpp` checks sorting results across boundary and application-limit inputs, trace identity and value correspondence, pseudocode-line bounds and explanation presence, search results, data-structure/controller operations, graph editing and route recalculation, and playback transitions. The QML suite covers accessible visualization state, reduced motion and contrast, full and compact complexity summaries, operation-specific prediction prompts, navigation requests, playback actions/seeking/settings, and synchronized comparison speed. CTest discovers `tests/tst_*.qml` when Qt Quick Test is installed. Configure with `-DBUILD_TESTING=ON` and run `ctest --test-dir build --output-on-failure --no-tests=error`. CI builds and tests Debug and Release and runs `qmllint` using the generated QML module metadata.
