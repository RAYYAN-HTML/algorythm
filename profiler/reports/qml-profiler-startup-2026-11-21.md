# QML Profiler Report — Startup

**Run:** 2026-11-21, Qt 6.11.2 MinGW x64, RelWithDebInfo with `QT_QML_DEBUG`; closed cleanly.
**Trace:** `profiler/traces/qmlprofiler-trace-Algorythm-startup-lazy-pages-2026-11-21-163803.qtd` (kept local; profiler traces are git-ignored).

## Measurement scope

The startup/dashboard sample contains 8,161 profiler events spanning 1,521.28 ms of recorded event time. The user interface was not driven through a sustained sort playback in this Windows session. This trace has no animation/frame-time section, so it cannot establish playback frame rate or jank.

## Event summary

| Event type | Count | Total event time (ms) |
|---|---:|---:|
| Creating | 1,154 | 744.86 |
| Compiling | 65 | 732.30 |
| Binding | 1,287 | 26.50 |
| Javascript | 1,474 | 16.90 |
| HandlingSignal | 1 | 0.72 |

No animation/frame-time metrics were present; no frame percentile or jank conclusion is available.

## Memory

The sample recorded 878,016 bytes of small/large QML item allocations, with 0 bytes reclaimed (0.0%). Peak QV4 heap-page allocation was 971,520 bytes; small and large item bytes live at exit totaled 878,016 bytes.

| Category | Allocations | Total allocated | Reclaimed | Peak live | Live at exit |
|---|---:|---:|---:|---:|---:|
| GC heap pages | 6 | 971,520 B | 0 B | 971,520 B | 971,520 B |
| Small JS/QML objects | 4,173 | 878,016 B | 0 B | 878,016 B | 878,016 B |

The heap-page category is allocator memory; the item categories describe JavaScript/QML object allocations. Large items were zero in this sample.

## Pixmap cache

The parser produced no pixmap-cache summary for this trace.

## Top 30 hotspots

| Rank | Total (ms) | Count | Average (ms) | Type | Source location | Details |
|---:|---:|---:|---:|---|---|---|
| 1 | 427.59 | 2 | 213.796 | Compiling | `qml/Main.qml` | qrc:/qt/qml/Algorythm/qml/Main.qml |
| 2 | 404.01 | 2 | 202.003 | Creating | Qt resource `qrc:/qt-project.org/imports/QtQuick/Controls/Material/ApplicationWindow.qml`:10 | QtQuick.Templates/ApplicationWindow |
| 3 | 66.25 | 42 | 1.577 | Creating | Qt resource `qrc:/qt-project.org/imports/QtQuick/Controls/Material/Button.qml`:11 | QtQuick.Templates/Button |
| 4 | 64.43 | 146 | 0.441 | Creating | Qt resource `qrc:/qt-project.org/imports/QtQuick/Controls/Material/Label.qml`:9 | QtQuick.Templates/Label |
| 5 | 61.05 | 1 | 61.046 | Compiling | `qml/components/NavigationSidebar.qml` | qrc:/qt/qml/Algorythm/qml/components/NavigationSidebar.qml |
| 6 | 54.72 | 2 | 27.361 | Creating | [DashboardPage.qml:212](</C:/Users/Rayyan/Documents/AlgoVizSim/qml/pages/DashboardPage.qml:212>) | QtQuick/Repeater |
| 7 | 30.99 | 1 | 30.986 | Compiling | `qml/pages/GraphPage.qml` | qrc:/qt/qml/Algorythm/qml/pages/GraphPage.qml |
| 8 | 27.59 | 1 | 27.591 | Compiling | Qt resource `qrc:/qt-project.org/imports/QtQuick/Controls/Material/Button.qml` | qrc:/qt-project.org/imports/QtQuick/Controls/Material/Button.qml |
| 9 | 20.84 | 1 | 20.844 | Compiling | `qml/pages/SortingPage.qml` | qrc:/qt/qml/Algorythm/qml/pages/SortingPage.qml |
| 10 | 19.39 | 1 | 19.388 | Compiling | Qt resource `qrc:/qt-project.org/imports/QtQuick/Controls/Material/SpinBox.qml` | qrc:/qt-project.org/imports/QtQuick/Controls/Material/SpinBox.qml |
| 11 | 16.96 | 1 | 16.959 | Compiling | Qt resource `qrc:/qt-project.org/imports/QtQuick/Controls/Material/impl/TextEditingContextMenu.qml` | qrc:/qt-project.org/imports/QtQuick/Controls/Material/impl/TextEditingContextMenu.qml |
| 12 | 15.81 | 1 | 15.811 | Compiling | Qt resource `qrc:/qt-project.org/imports/QtQuick/Controls/Basic/Calendar.qml` | qrc:/qt-project.org/imports/QtQuick/Controls/Basic/Calendar.qml |
| 13 | 13.02 | 1 | 13.017 | Creating | [Main.qml:7](</C:/Users/Rayyan/Documents/AlgoVizSim/qml/Main.qml:7>) | ApplicationWindow |
| 14 | 11.07 | 1 | 11.074 | Compiling | `qml/components/Icon.qml` | qrc:/qt/qml/Algorythm/qml/components/Icon.qml |
| 15 | 10.68 | 1 | 10.677 | Compiling | Qt resource `qrc:/qt-project.org/imports/QtQuick/Controls/Material/Menu.qml` | qrc:/qt-project.org/imports/QtQuick/Controls/Material/Menu.qml |
| 16 | 10.41 | 2 | 5.203 | Creating | [Main.qml:105](</C:/Users/Rayyan/Documents/AlgoVizSim/qml/Main.qml:105>) | QtQuick.Layouts/RowLayout |
| 17 | 10.29 | 2 | 5.146 | Creating | [NavigationSidebar.qml:89](</C:/Users/Rayyan/Documents/AlgoVizSim/qml/components/NavigationSidebar.qml:89>) | QtQuick/Repeater |
| 18 | 8.75 | 1 | 8.751 | Compiling | `qml/components/SettingsPopup.qml` | qrc:/qt/qml/Algorythm/qml/components/SettingsPopup.qml |
| 19 | 6.70 | 1 | 6.703 | Creating | [Main.qml:109](</C:/Users/Rayyan/Documents/AlgoVizSim/qml/Main.qml:109>) | NavigationSidebar |
| 20 | 6.62 | 14 | 0.473 | Creating | [LabCard.qml:31](</C:/Users/Rayyan/Documents/AlgoVizSim/qml/components/LabCard.qml:31>) | QtQuick.Layouts/ColumnLayout |
| 21 | 6.22 | 2 | 3.111 | Creating | [NavigationSidebar.qml:5](</C:/Users/Rayyan/Documents/AlgoVizSim/qml/components/NavigationSidebar.qml:5>) | QtQuick/Rectangle |
| 22 | 5.94 | 4 | 1.486 | Creating | Qt resource `qrc:/qt-project.org/imports/QtQuick/Controls/Material/Switch.qml`:10 | QtQuick.Templates/Switch |
| 23 | 5.69 | 1 | 5.694 | Compiling | `qml/pages/ComparisonPage.qml` | qrc:/qt/qml/Algorythm/qml/pages/ComparisonPage.qml |
| 24 | 5.31 | 1 | 5.307 | Compiling | `qml/pages/DashboardPage.qml` | qrc:/qt/qml/Algorythm/qml/pages/DashboardPage.qml |
| 25 | 5.15 | 1 | 5.153 | Compiling | `qml/components/GraphPredictionChallenge.qml` | qrc:/qt/qml/Algorythm/qml/components/GraphPredictionChallenge.qml |
| 26 | 5.12 | 2 | 2.558 | Creating | [DashboardPage.qml:120](</C:/Users/Rayyan/Documents/AlgoVizSim/qml/pages/DashboardPage.qml:120>) | QtQuick/Repeater |
| 27 | 4.25 | 2 | 2.127 | Creating | [NavigationSidebar.qml:37](</C:/Users/Rayyan/Documents/AlgoVizSim/qml/components/NavigationSidebar.qml:37>) | QtQuick.Layouts/ColumnLayout |
| 28 | 3.81 | 40 | 0.095 | Binding | Qt resource `qrc:/qt-project.org/imports/QtQuick/Controls/Material/Button.qml`:14 |  |
| 29 | 3.71 | 2 | 1.856 | Creating | [DashboardPage.qml:163](</C:/Users/Rayyan/Documents/AlgoVizSim/qml/pages/DashboardPage.qml:163>) | QtQuick/Repeater |
| 30 | 3.59 | 2 | 1.797 | Creating | [Main.qml:132](</C:/Users/Rayyan/Documents/AlgoVizSim/qml/Main.qml:132>) | QtQuick.Layouts/StackLayout |

## Project hotspot analysis

### Main QML compilation

`Main.qml` compilation is the largest recorded cold-start event (427.59 ms across profiler compiler events). This is a QML-debugging RelWithDebInfo sample and includes cold compilation; it is not representative of steady-state playback or a packaged release. The project already uses Qt QML caching through CMake, so no speculative code change is justified from this measurement alone.

### Dashboard delegates

The dashboard `Repeater` at [DashboardPage.qml:212](</C:/Users/Rayyan/Documents/AlgoVizSim/qml/pages/DashboardPage.qml:212>) created the lab cards in this run (about 54.72 ms total). There are seven fixed cards and this is a one-time construction cost. Replacing the repeater with bespoke UI would add duplication without evidence of ongoing frame cost.

### Deferred lab pages

`ComparisonPage`, `StructurePage`, `GraphPage`, and `SortingPage` have compile events from QML type preparation, but this startup trace has no creation hotspots from those page components. Their loaders keep the pages uninstantiated until first navigation and retain them after the first visit. Playback/first-navigation costs were not measured.

### Qt Quick Controls

The largest remaining delegate creation entries are Qt Material `ApplicationWindow`, `Button`, and `Label` internals. They are framework resources, not local project code. This trace has no evidence of repeated creation during playback.

## Next steps

1. Profile a sustained sort playback with the profiler app navigated into Sorting and playing; capture animation/frame-time events and memory over the full run.
2. Profile a graph traversal separately if graph rendering performance becomes a concern.
3. Keep lazy page creation and verify first-navigation state retention on each lab before further startup optimization.

> AI assistance has been used to create this output.
