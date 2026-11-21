# Algorythm

**An Algorithm Visual Simulation** — a native Qt 6 desktop studio for learning algorithms through step-by-step execution, synchronized explanations, and animated visualizations.

## Learning labs

- Sorting: Bubble, Selection, Insertion, Merge, and Quick Sort.
- Searching: Linear and Binary Search, including visible preparation when Binary Search receives unsorted data.
- Data structures: linked lists, stacks, queues, and binary search trees with insertion, search, value-based deletion, and four traversal orders.
- Graphs: BFS, DFS, and Dijkstra's shortest path on an editable weighted graph (2–12 nodes), with validated node and edge changes.
- Algorithm comparison, custom inputs, presets, pseudocode, narration, operation counters, complexity summaries, and synchronized replay controls.
- Predict-the-next-step challenges for all five sorting algorithms, Linear Search, and Binary Search, with feedback tied to each algorithm's actual trace decision.
- BFS and DFS challenges that ask learners to predict whether an examined neighbor is new or already discovered.
- Structure challenges that predict the next Stack/Queue removal or the selected BST traversal sequence before showing the operation.
- A local recent-activity list lets learners resume sorting and searching with the same algorithm, input, and target, or reopen a graph with its edited nodes, weighted edges, start node, destination, and algorithm.

Sorting and searching steps are generated from the C++ algorithm traces. Each element keeps its original identity while it changes position, so Qt Quick animates real swaps, shifts, merge writes, and binary-search preparation. Playback speed controls the pacing, with each automatic step spaced to let its transition complete.

Each reversible frame also captures the active loop variables, search bounds, pivot or key, merge cursors, counters, and current array. The learning panel shows that snapshot alongside synchronized narration and pseudocode, including when rewinding or seeking.

Insertion Sort uses stable adjacent exchanges so every visual node keeps one identity during a move. Merge Sort records the output prefix and the remaining input nodes without duplicating or losing a node in intermediate frames. Linked-list, stack, and queue panels use incremental Qt item-model updates, so insertions and removals animate the affected node and the displacement of its neighbors. BST insertion updates existing tree positions in place and animates the new node into the hierarchy.

The workspace splitter remembers its preferred size. Navigation and the learning assistant can be collapsed, and Settings persists playback speed, reduced motion, and compact-sidebar preference locally, with a restore-defaults action. Graph traversal uses the same saved playback speed as the sorting and comparison traces.

The desktop controls use a dense dark theme with cyan/violet highlights, semantic navigation buttons, selected-state indicators, and clear primary/secondary action emphasis.

## Download

The current Windows x64 release is [Algorythm v1.3.1](https://github.com/RAYYAN-HTML/algorythm/releases/tag/v1.3.1). The release includes a deployable ZIP and `SHA256SUMS.txt` for checksum verification.

## Build

Requirements: CMake 3.21+, a C++17 compiler, and Qt 6 with Quick and Quick Controls 2. Qt Test and Qt Quick Test are needed when `BUILD_TESTING` is enabled.

```sh
cmake -S . -B build -DCMAKE_PREFIX_PATH=/path/to/Qt/6.x/<kit> -DBUILD_TESTING=ON
cmake --build build
ctest --test-dir build --output-on-failure --no-tests=error
```

CTest runs the C++ algorithm/controller suite and, when `qmltestrunner` is on `PATH`, the Qt Quick component suite. The GitHub Actions workflow builds and tests Debug and Release configurations and runs QML lint with the generated module import path.

Run `build/Algorythm.exe` on Windows, or the generated `Algorythm` executable on other platforms.

## Controls

Use Play/Pause, previous/next, restart, the timeline, and speed slider. Sorting supports Space, Left, Right, and R shortcuts; Comparison applies those shortcuts to both traces. Inputs accept comma or whitespace separated integers.
