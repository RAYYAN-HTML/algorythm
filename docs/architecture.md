# Algorythm architecture

## Execution and playback

Sorting and searching algorithms generate `QVector<ExecutionStep>` traces in C++. Each step contains the current value order, the stable ID of each value, active indices, pseudocode line, cumulative counters, narration, explanation, a variable snapshot, and completion state. Stable IDs make the positions animatable independently of the current order. Variable snapshots are captured in each frame, so rewind and timeline seeking restore loop indices, search bounds, pivots, keys, merge cursors, counters, and the displayed array without recomputing state.

`PlaybackController` owns a trace, timer, and `AlgorithmNodeModel`. The node model is reset only for new input. On seek, rewind, stepping, or timed playback, the controller updates each stable node's target position. `dataChanged` notifies QML while retaining existing delegates. `AlgorithmNode` applies eased position and color Behaviors. The presentation timer runs more slowly than the position transition at each speed setting.

Graphs use a dedicated `GraphController` and `GraphStep` snapshots. Traversal states drive active/visited node feedback and active edge highlights. Data structures use `StructureController` and expose current values and tree links to their page.

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

`tests/algorithm_tests.cpp` checks sorting results, every trace frame's node identity and value correspondence, search results, data structure operations, and graph algorithms. Build and run it with CMake/CTest as shown in the project README.
