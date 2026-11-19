# Algorythm

**An Algorithm Visual Simulation** — a native Qt 6 desktop studio for learning algorithms through step-by-step execution, synchronized explanations, and animated visualizations.

## Learning labs

- Sorting: Bubble, Selection, Insertion, Merge, and Quick Sort.
- Searching: Linear and Binary Search, including visible preparation when Binary Search receives unsorted data.
- Data structures: linked lists, stacks, queues, and binary search trees.
- Graphs: BFS, DFS, and Dijkstra's shortest path on a weighted graph.
- Algorithm comparison, custom inputs, presets, pseudocode, narration, operation counters, and replay controls.

Sorting and searching steps are generated from the C++ algorithm traces. Each element keeps its original identity while it changes position, so Qt Quick animates real swaps, shifts, merge writes, and binary-search preparation. Playback speed controls the pacing, with each automatic step spaced to let its transition complete.

Each reversible frame also captures the active loop variables, search bounds, pivot or key, merge cursors, counters, and current array. The learning panel shows that snapshot alongside synchronized narration and pseudocode, including when rewinding or seeking.

## Build

Requirements: CMake 3.21+, a C++17 compiler, and Qt 6 with Quick and Quick Controls 2.

```sh
cmake -S . -B build -DCMAKE_PREFIX_PATH=/path/to/Qt/6.x/<kit>
cmake --build build
ctest --test-dir build --output-on-failure
```

Run `build/Algorythm.exe` on Windows, or the generated `Algorythm` executable on other platforms.

## Controls

Use Play/Pause, previous/next, restart, the timeline, and speed slider. Sorting also supports Space, Left, Right, and R shortcuts. Inputs accept comma or whitespace separated integers.
