# Algorythm viva guide

## Project overview

Algorythm is a native Qt 6 / C++17 DSA learning studio. It includes sorting and search visualizations, comparison mode, data-structure controls, and graph traversal/shortest-path labs. C++ generates the algorithm operations; QML presents the trace with synchronized explanations and pseudocode.

## Architecture and animation

Each sorting/search step stores values and stable original node IDs. The model keeps one row per original value and updates its target position for each trace frame. Because QML delegates remain alive, `Behavior` with `NumberAnimation` interpolates their positions. Rewind and seeking select a prior snapshot, and the same model updates the nodes to those positions. Playback speed changes both the presentation interval and motion duration; animation never affects algorithm correctness.

## Sorting and search algorithms

Bubble, Selection, Insertion, Merge, and Quick Sort use their actual C++ steps. Linear Search checks from left to right. Binary Search visibly sorts an unsorted input before narrowing the search interval. Counters track algorithm operations, not wall-clock runtime.

## Data structures and graphs

Linked lists, stacks, queues, and binary search trees expose operations through `StructureController`. `GraphController` creates BFS, DFS, and Dijkstra snapshots, including visited nodes, the active edge, distances, and narration. Graph traversal color and scale feedback ease between steps.

## Comparison and controls

Comparison mode runs two independent sorting traces from a shared input and reports separate operation counts. Sorting supports play/pause, previous/next, restart, seek, speed, and keyboard shortcuts. The learning UI keeps narration, pseudocode, and statistics synchronized to the selected trace step.

## Viva questions

**Does animation affect correctness?** No. Algorithms produce their trace before playback; animation only presents recorded positions and states.

**How does rewind work?** The playback index selects an earlier snapshot. Stable IDs tell the model where each original element belongs in that frame.

**Why compare operation counts instead of animation duration?** Animation is paced for learning and does not measure algorithm execution time.

**What is Bubble Sort's complexity?** Best O(n) with early termination, average/worst O(n²), auxiliary space O(1), and stable ordering.

**How does the interface work offline?** Algorithm steps and narration are generated locally. No network service is needed to run the labs.
