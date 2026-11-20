# Research and design notes

## Visual direction

The supplied reference image uses a dense desktop workspace: persistent left navigation, compact configuration controls, and a large graph canvas. Its near-black navy surfaces, cyan activity paths, violet nodes, thin borders, and restrained labels give the visualization priority. Algorythm keeps that layout language while using the existing app's sorting, search, structure, and graph labs rather than copying a single screen.

Current dashboard and graph UI references emphasize a modular panel grid, legible status accents, and a focused central visualization. An interactive graph visualizer example also pairs per-step node and edge highlights with narration and algorithm state, which informed the app's synchronized step model. Sources: [Dribbble dark dashboard concept](https://dribbble.com/shots/27156248-Futuristic-Dark-Mode-SaaS-Dashboard-UI-UX-Design), [AlgoScope visualizer](https://github.com/algoscope-hq/AlgoScope), and [graph visualizer with per-step annotations](https://github.com/VietDangH/graph-visualizer).

## Animation architecture

Qt Quick `Behavior` applies a default animation whenever a tracked property changes, and `NumberAnimation` supports easing for numeric position changes. The algorithm trace therefore exposes stable model rows and updates only each node's target position. A full list-model reset happens only when the input changes. Per-step target updates emit `dataChanged`, allowing the same delegates to animate without being destroyed. The timer interval remains longer than the position transition duration and both scale with the playback speed.

References: [Qt Quick Behavior](https://doc.qt.io/qt-6/qml-qtquick-behavior.html), [Qt Quick animations and transitions](https://doc.qt.io/qt-6/qtquick-statesanimations-animations.html), and [Qt Quick views with C++ models](https://doc.qt.io/qt-6/qtquick-modelviewsdata-cppmodels.html).

The sorting workspace now uses Qt Quick Controls `SplitView` for direct manipulation. Qt documents its minimum, preferred, and maximum sizing and recommends serializing `saveState()`/`restoreState()` so panel sizing survives sessions; Algorythm persists the split state locally. The accessibility menu exposes a persisted reduced-motion option that shortens node and graph transitions while leaving step playback and algorithm state intact. References: [Qt SplitView](https://doc.qt.io/qt-6/qml-qtquick-controls-splitview.html) and [Qt Settings](https://doc.qt.io/qt-6/qml-qtcore-settings.html) (Algorythm uses QSettings in C++ to retain compatibility with the project's Qt 6.2 minimum).

Qt Quick accessibility guidance calls for concise accessible names plus descriptions for custom visual elements. The reusable algorithm node now reports its value and live state to assistive technology, while navigation has explicit collapse/expand actions and the learning panel remains independently hideable. References: [Qt Quick Accessible](https://doc.qt.io/qt-6/qml-qtquick-accessible.html) and [Qt Quick accessibility overview](https://doc.qt.io/qt-6/accessible-qtquick.html).

For structure labs, the controller now emits proper row insert/remove notifications through a `QAbstractListModel`. Qt Quick `ListView` add, remove, and displaced transitions can therefore animate actual pushes, pops, enqueues, dequeues, and linked-list edits while preserving unaffected nodes. A second incremental model lets BST nodes keep their identities and animate to new coordinates when an insertion changes the tree. Reduced-motion mode disables these transitions. References: [Qt Quick ListView](https://doc.qt.io/qt-6/qml-qtquick-listview.html) and [Qt item view transitions](https://doc.qt.io/qt-6/qtquick-views-transitions.html).

Packaging QA exposed that Qt’s default QML import location points back to the build machine. The standalone Windows bundle includes a local `qt.conf` with relative plugin and QML paths, following Qt’s deployment guidance. A clean-path launch test also exposed MinGW compiler-runtime and transitive Qt dependency DLLs that `windeployqt` does not stage; the final bundle includes the dependency closure from the selected Qt toolchain and is smoke-tested with only Windows directories on `PATH`. Reference: [Qt `qt.conf`](https://doc.qt.io/qt-6/qt-conf.html).

Visual review showed the previous Fusion controls retained default gray button faces that clashed with the neon studio palette. The app now uses Qt Quick Controls Material in dark, dense desktop mode with cyan and violet accents; primary actions are explicitly highlighted, while secondary actions use flat controls. The sidebar navigation is now built from semantic, keyboard-operable buttons with active indicators, hover transitions, and labels on collapsed-icon tooltips. References: [Qt Material style](https://doc.qt.io/qt-6/qtquickcontrols-material.html) and [Qt `QQuickStyle`](https://doc.qt.io/qt-6/qquickstyle.html).

## Algorithm learning references

- [midudev/alg0.dev](https://github.com/midudev/alg0.dev) describes step-by-step visualizations paired with active code lines, variable tracking, contextual explanations, keyboard controls, and reduced-motion support. Algorythm already synchronizes narration and pseudocode with playback; the current-variable panel extends the same trace model to expose loop indices, bounds, pivots, counters, and the array at each reversible step.
- [RhythmPahwa14/AlgoVisualizer](https://github.com/RhythmPahwa14/AlgoVisualizer) documents input validation and sample data, per-step controls and performance metrics, quizzes, and export features. The useful direction for this project is guided experimentation and understandable feedback. Algorythm keeps custom input local and offline and retains the circular-node visual identity; it does not import that web app's code or assets.

Both projects are feature references rather than implementation dependencies. Their different frameworks, layouts, and identities are not copied into the Qt desktop app.

## Design constraints

- Preserve the actual algorithm trace and teaching content as the source of the display state.
- Keep animation purposeful: comparison highlights, node movement, color changes, and traversal state correspond to recorded operations.
- Keep the dark canvas and neon accents selective to maintain text and operation readability.
- No third-party code or assets were copied.
