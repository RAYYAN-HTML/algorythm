# Algorythm — Implementation and Verification Plan

**Updated:** 2026-11-20

## Completed in this pass

- Corrected the Dashboard’s static illustration label from “LIVE TRACE” to “SAMPLE TRACE · 7 VALUES.”
- Renamed `AlgorithmNode.state` to `nodeState` to avoid shadowing `QQuickItem.state`, and updated Sorting/Comparison bindings.
- Rebuilt Release and passed CTest; visually and interactively checked Dashboard, Sorting, Search, Graph, and Compare at 1440×900.
- Created a QML-debug profiling build, cleanly exited `qmlprofiler`, and parsed its 3.59 MB trace. The 4.23-second sample reported estimated average 59.5 FPS, 31 frames and 1.68 MB peak QML heap; it covers startup/transition only and is not sustained playback evidence.

This plan reflects the actual repository and existing pending work. It avoids replacing existing algorithms, controller APIs, or the current Qt Quick architecture.

| Priority | Work | Status at start | Acceptance evidence |
|---|---|---|---|
| P0 | Preserve current uncommitted changes and document baseline | Complete | Initial audit created before UI edits; pre-existing local changes remain intact. |
| P1 | Fix false “LIVE TRACE” Dashboard label | Complete | Label describes the hard-coded illustration honestly; release build and Dashboard inspection. |
| P1 | Validate visualization workspace, playback and input recovery | Partly implemented; current runtime coverage incomplete | Build and CTest, then exercise run/step/back/restart/seek/speed and valid/invalid input; record unavailable interactions explicitly. |
| P1 | Verify Comparison synchronization and compact layout | Existing shared playback behavior; compact behavior pending | Exercise mixed running/completed states and inspect both panels at 800×600 and 1024×768. |
| P1 | Verify Graph post-fix geometry and traversal controls | Node geometry correction compiled; visual confirmation pending | Inspect BFS, DFS, Dijkstra, add-edge feedback, playback and speed in live app. |
| P2 | Verify structures, settings persistence and BST boundary feedback | Controller behavior partly covered; status history reports some UI checks | Exercise Linked List, Stack, Queue, BST, underflow, duplicate, invalid/depth insertion, settings reset and restart persistence. |
| P2 | Reduce actionable QML layout/type warnings in touched paths | Whole-project linter has mixed actionable/noisy results | Re-run qmllint with generated module paths; compare concrete diagnostics and runtime outcomes. |
| P2 | Improve shared token reuse / component consistency | Existing shared palette, repeated local values remain | Documented role map; change only recurring semantic styles; regression screenshots across pages. |
| P2 | Accessibility pass | Partially implemented, not complete | Keyboard-only operation/focus visibility, accessible state labels, reduced-motion check, larger text and contrast spot checks. |
| P3 | QML Quick Test harness | No QML tests exist | Defer harness until focused QML tests are authored; current C++ CTest remains required. |
| P3 | Profile actual QML execution | Short launch/transition trace captured and parsed | For sustained performance conclusions, capture longer sorting, comparison and graph playback runs and compare frame-time distributions. |
| P3 | Final design critique and status reconciliation | Pending final implementation | Recheck each major page after changes; distinguish implemented, built, automated, runtime-tested, measured and visually inspected. |

## Constraints

- Preserve existing Qt 6/QML/C++ architecture and controller interfaces.
- Do not rewrite working algorithms or move algorithm logic into QML.
- Do not invent progress metrics, user research results, performance measurements or test outcomes.
- Figma is unavailable; implement/document through the existing QML component system.
- No `tst_*.qml` suite exists; the Qt Quick Test Runner workflow cannot run without new tests.

