# Qt Quick Test Report

**Latest verified run:** 2026-11-21
**Qt version:** 6.11.2 (MinGW x64)
**Configurations:** Debug and Release

## Results

- Both configurations built successfully and passed both CTest targets: `algorithm_generators` and `qml_component_tests`.
- The QML suite passed 32 test functions (48 Qt Test passes including init/cleanup) covering navigation requests, dashboard history/resume actions, saved graph summaries, dashboard reflow breakpoints, visualization-state accessibility, reduced-motion behavior, non-text theme contrast, full and compact complexity metadata, prediction pause/continue plus all five sorting algorithms, both search algorithms and BFS/DFS, stack/queue removal predictions, BST traversal-sequence predictions, reusable playback control actions and seek/speed persistence, and comparison speed synchronization across both traces and saved settings.
- GraphPage now uses a responsive Dijkstra distance grid, reserves space for route and queue details, labels edge inputs for assistive technology, and distinguishes initial guidance from error feedback.
- The graph builder supports adding/removing nodes (2–12) and adding/removing weighted undirected edges. Node deletion removes incident edges, renumbers remaining endpoints, keeps start/destination selections valid, and rebuilds the trace; controller tests verify path recalculation after editing.
- BST value deletion now handles leaf, one-child, and two-child cases, and the visual model removes deleted delegates and updates affected positions; controller and data-structure tests cover deletion and invalid values.
- Sorting input errors, graph edge results, and structure-operation statuses request polite screen-reader announcements. Structure value/position inputs and traversal selection now have explicit accessible names.
- The graph/tree edge, node outline, and split-handle focus colors were raised to meet a 3:1 contrast target against their dark surfaces; a Qt Quick test checks those theme roles.
- The prediction challenge pauses autoplay while the learner responds, advances after the explanation, and resumes only when playback was active before the challenge. Prompts now cover Bubble, Selection, Insertion, Merge, and Quick Sort operations plus Linear Search matches and Binary Search range elimination; QML tests cover each new prediction rule.
- BFS/DFS graph steps expose discovered-node snapshots. The graph prediction prompt distinguishes a newly discovered neighbor from a duplicate frontier candidate, with pause/resume and manual-pause behavior covered in QML tests.
- Comparison playback controls are extracted into a reusable component; changing the shared speed keeps both algorithm controllers and the playback setting in sync.
- Sorting, structure, comparison, and graph pages now load on first navigation and stay alive afterward; QML profiling verified those page trees are absent from dashboard startup creation events.
- Comparison cards reuse a compact complexity summary that shows best, average, and worst time, auxiliary space, and sorting stability/in-place properties beside operation counters.
- Sorting playback controls now receive their controller and settings explicitly, and QML tests exercise play/pause, next/previous, restart, seek, and saved speed changes.
- The navigation sidebar exposes stable names for lab buttons; a QML test verifies sorting and searching navigation requests and the screen-reader label.
- Recent sorting/searching activity stores the selected algorithm, input, and search target locally; the dashboard can resume that configuration. Graph history stores the selected algorithm, node count, weighted edges, start node, and destination; validated restoration and persistence are covered by Qt Test.
- Whole-project `qmllint -I build` exited successfully with zero `missing-property` or layout-positioning warnings. Unqualified-access warnings remain for a broader cleanup pass.
- CI now discovers and lints every `tests/tst_*.qml` file instead of linting only the original component test.
- The dashboard and sorting lab were visually inspected at the available 1442×864 window size.
- A Qt 6.11.2 QML startup profile is documented in `profiler/reports/qml-profiler-startup-2026-11-21.md`. It records startup/control creation and memory events; sustained sorting playback was not successfully driven during profiling, and the trace contains no frame-time data.

## Remaining verification gaps

The requested viewport matrix (800×600 through 1920×1080) could not be established reliably: native Win32 window resizing changed the outer rectangle without updating Qt logical dimensions, and the physical display is smaller than 1920×1080. Component tests verify dashboard 1/2/3-column reflow thresholds but do not replace full-page viewport checks. Component tests also do not cover actual screen-reader speech or end-to-end settings persistence. Sustained-playback performance and jank remain unmeasured.
