# Algorythm Project Status

Last reconciled: 2026-11-20

This file tracks verified repository state. Items are marked complete only after the stated checks have run.

## Completed Features

| Feature | Implementation | Key files | Verification |
|---|---|---|---|
| Algorithm playback and core visualizers | Sorting, searching, data-structure, graph, and comparison views with playback controls | `qml/pages/`, `src/algorithms/`, `src/controllers/`, `src/engine/` | Existing application and algorithm test suite; algorithm test passed in Release on 2026-11-20 (see history) |
| Per-step algorithm variables | Reversible snapshots expose variable state during algorithm playback | `qml/components/VariablesPanel.qml`, `qml/pages/SortingPage.qml`, `src/algorithms/sortingalgorithms.cpp` | Covered by algorithm tests in prior verified v1.1 work; current Release suite passes |
| Graph traversal path animation | Traversal updates active graph edges during playback | `qml/pages/GraphPage.qml`, `src/controllers/graphcontroller.cpp` | Existing app verification in prior v1.1 work |
| Stable insertion-sort identities and merge snapshots | Adjacent swaps preserve duplicate item identities; merge snapshots show a consistent partial output | `src/algorithms/sortingalgorithms.cpp`, `tests/algorithm_tests.cpp` | Current Release test suite passes 1/1, 2026-11-20 |
| Incremental structure visualization models | Linked list, stack, queue, and tree models publish incremental updates for animated transitions | `src/controllers/structurecontroller.h`, `src/controllers/structurecontroller.cpp`, `qml/pages/StructurePage.qml` | Release algorithm/model test passed 1/1 on 2026-11-20 |
| Local settings and persistence | Reduced motion, playback speed, compact sidebar startup, workspace split persistence, and restore-defaults action | `src/controllers/settingscontroller.h`, `src/main.cpp`, `qml/Main.qml`, `qml/components/SettingsPopup.qml`, `tests/algorithm_tests.cpp` | Settings panel visually checked; tests cover defaults, bounds, save/reload and reset. Runtime changed speed to 1.5×, restarted app and observed 1.5× persisted, then restored 1.0×. |
| Sort workspace splitter and persisted layout | Resizable workspace split can hide/show assistant and saves/restores divider state | `qml/pages/SortingPage.qml`, `src/controllers/settingscontroller.h` | Implemented; runtime divider interaction remains to be checked |
| GitHub v1.1.0 release | Windows x64 package released from earlier stable revision | GitHub release `v1.1.0` | Published and verified in prior development session |
| GitHub v1.2.0 release | Published Windows x64 package for commit `7a34e3a` | [Release v1.2.0](https://github.com/RAYYAN-HTML/algorythm/releases/tag/v1.2.0) | GitHub API confirmed published (not draft); uploaded asset is 46,044,844 bytes and its SHA-256 matches the local archive. |
| Graph playback speed preference | Graph traversal timer follows the persisted shared playback speed and clamps it to the same 0.5×–3× range as sorting | `src/controllers/graphcontroller.h`, `src/controllers/graphcontroller.cpp`, `qml/Main.qml` | Controller speed bounds tested in Release suite; Settings persistence was runtime checked, Graph timer interaction remains pending |
| Compare layout, shared input, and Run Both synchronization | Responsive card sizing keeps traces within their panels; shared input validates before changing either trace; Run Both explicitly starts or pauses both controllers even if their states differ | `qml/pages/ComparisonPage.qml`, `src/engine/playbackcontroller.h`, `src/engine/playbackcontroller.cpp`, `tests/algorithm_tests.cpp` | Release build/CTest passed. Earlier desktop runtime verified default nodes, valid/invalid input, and Run Both from a mixed running/completed state. Current purple-theme visual pass found a node-position regression; latest explicit-canvas fix is built and awaiting runtime verification. |
| Main window composition and consistent vector icons | Main window delegates navigation/settings to reusable components; shared `Icon.qml` draws native vector icons without text glyphs or image decoder dependencies | `qml/Main.qml`, `qml/components/NavigationSidebar.qml`, `qml/components/SettingsPopup.qml`, `qml/components/Icon.qml`, page QML | Release build passed; live Dashboard and sidebar show rendered icons, no startup QML errors; Dashboard inspected at desktop and compact width. |
| Cohesive responsive Dashboard | Hero and lab cards share the app palette, hierarchy, CTA, card hover/navigation and responsive grid | `qml/pages/DashboardPage.qml`, `qml/components/LabCard.qml` | Live desktop and compact screenshots show card grid fits and navigation works. |
| Sorting page component extraction and compact layout | Input bar, complexity summary, and prediction challenge are isolated reusable components; compact view stacks workspace and hides assistant by default | `qml/pages/SortingPage.qml`, `qml/components/AlgorithmInputBar.qml`, `qml/components/ComplexityPanel.qml`, `qml/components/PredictionChallenge.qml` | Release build and CTest pass; live compact view shows input, nodes, and playback controls without assistant overlap. Valid/invalid sorting input and Search target selection were interacted with. |
| Sorting/search algorithm source separation | Replaced monolithic bubble-sort source unit with dedicated sorting and searching translation units and a shared sorting API header | `src/algorithms/sortingalgorithms.cpp`, `src/algorithms/searchalgorithms.cpp`, `src/algorithms/sortingalgorithms.h`, `CMakeLists.txt` | Release build and algorithm tests pass 1/1. |
| Premium-purple Dashboard layout | Added a dashboard overview row, purple hero surface, truthful catalog counts (7 algorithms, 7 labs, 4 structure types), and reusable stat cards before the existing navigation cards | `qml/pages/DashboardPage.qml`, `qml/components/StatCard.qml`, `CMakeLists.txt` | Release build and CTest pass; live Dashboard screenshot confirms the counts, hierarchy, spacing, and all existing lab destinations. |
| Purple visual foundation and algorithm node states | Centralized deep violet surfaces/accent/semantic tokens; applied purple selected navigation, purple focus nodes, amber comparison nodes, green completed nodes, and replaced the narration sparkle glyph with shared vector icon | `qml/Main.qml`, `qml/components/NavigationSidebar.qml`, `qml/components/AlgorithmNode.qml`, shared panels and page QML | Release build and CTest pass; Dashboard and Sorting runtime screenshots confirm the new theme and active purple node. Other page-specific states remain in visual review. |
| Tree visualization depth boundary | BST controller rejects inserts deeper than the four-level visual canvas can display | `src/datastructures/structures.h`, `src/controllers/structurecontroller.cpp`, `tests/algorithm_tests.cpp` | Release test confirms a depth-4 insert is rejected without changing the visual model; in-range insert still succeeds. |

## Currently Working

- Cross-module visual overhaul continues from pushed `df6280f`; the current palette/dashboard batch is uncommitted and builds/tests successfully.
- The new purple theme is runtime-inspected on Dashboard and Sorting. During the Compare inspection, nodes were seen stacked on the left; node positioning was changed to use the explicit canvas size and rebuilt, but it has not received a fresh runtime visual check.
- Runtime coverage remains incomplete for Graph playback/edge flows, Settings reduced-motion and compact-sidebar toggles, Sorting challenge dialogs, keyboard navigation, splitter persistence, and Compare at compact width.
- Tree insertion depth boundary is controller-tested; its user-facing rejection message has not yet been visually exercised. v1.2.0 remains the last published package; overhaul changes are unreleased.

## Remaining Work

### High priority

- Recheck Compare node spread in a fresh runtime and at compact width; exercise Graph, Sorting dialogs, and Settings toggles.
- Inspect splitter persistence, keyboard navigation, and reduced-motion behavior.
- Fix reproducible defects, rerun Release build/CTest, then commit and push the verified overhaul.

### Medium priority

- Review navigation/control consistency in all modules and verify all supported minimum-size layouts.
- Verify workspace splitter persistence and reduced-motion effects across visualizers.
- Verify animations through interactive use across structure, sorting, and graph screens.

### Low priority

- Add further visual polish where runtime inspection shows a concrete usability improvement.
- Keep README and research notes aligned with the final shipped UI.

## Pending Tasks

### High

1. Confirm Compare node spacing fix at desktop and 780 px; test empty/over-limit input in addition to previously verified malformed/valid cases.
2. Check Graph speed, pause/resume, previous/next, restart, traversal, and edge insertion interactions.
3. Exercise Sorting challenge/feedback dialogs; test reduced motion, compact-sidebar setting, and keyboard navigation.
4. Verify workspace splitter persistence; fix discovered issues, rerun Release build/CTest, then commit/push.

### Medium

1. Runtime pass through Sorting, Searching, Structures, Graphs, Compare, Settings.
2. Verify compact window behavior, keyboard navigation, and reduced-motion behavior.
3. Verify saved settings survive restart.

### Low

1. Follow-up refinements from visual inspection and user feedback.

## Bugs & Issues

| ID | Issue | Component | Severity | Reproduction | Status / investigation |
|---|---|---|---|---|---|
| UI-01 | User reports sidebar and buttons look poor (initial screenshot showed weak hierarchy and default-looking controls). | `qml/Main.qml`, `qml/components/NavigationSidebar.qml`, page QML | High | Open app and inspect navigation/action controls. | Improved sidebar/action hierarchy and Dashboard cohesion are verified at desktop and compact widths; broad control consistency and keyboard focus review remain in progress. |
| UI-02 | Sidebar brand subtitle overflowed into the dashboard header. | `qml/Main.qml` sidebar header | High | Open expanded Dashboard at desktop width; inspect brand row near sidebar edge. | Resolved and verified in live app: bounded/elided brand stays within the sidebar in expanded mode; compact mode is also usable. |
| UI-03 | Input screenshot showed a floating example hint above a populated value. | `qml/pages/SortingPage.qml` input row | Medium | Open Sorting or Searching with default input. | Resolved and verified in live app: removed the redundant placeholder; field label and value render on one line. |
| UI-04 | Settings exposed only Reduced motion. | `qml/components/SettingsPopup.qml`, `src/controllers/settingscontroller.h` | Medium | Open Settings from the sidebar. | Resolved and verified: panel shows playback speed, reduced motion, compact sidebar, restore defaults; app restart retained 1.5× playback preference and default 1.0× was restored after the check. |
| UI-05 | Playback timeline stretched across the entire workspace and ended at the far right on the final step. | `qml/components/PlaybackControls.qml` | Medium | Open an algorithm with a long trace or hide the assistant. | Resolved and verified in live app: timeline capped at 760 px, centered, with a step tooltip. It still correctly moves to the far right at the final step. |
| UI-06 | Structure action controls or visualizations may overflow at the minimum supported width. | `qml/pages/StructurePage.qml` | Medium | Resize app to its 780 px minimum and open Linked Lists, Stacks, Queues, and Trees. | Resolved and verified in live captures: Linked List Position and operation controls wrap cleanly; Stack and Queue controls fit; Tree and mode selector remain legible, with all nodes/edges and status visible. |
| UI-07 | BST nodes initially appeared stacked on the canvas edge; after positioning was fixed, the deepest row and status text overlapped. | `qml/pages/StructurePage.qml` tree canvas | High | At minimum width, open Trees. | Resolved and verified: the tree area is anchored to its parent, nodes use that area's width, narrow vertical spacing is synchronized with edges, the status moves below the canvas, and the mode selector has enough width. Screenshot confirms the full three-level sample tree and controls. |
| UI-08 | Compare node layout has had both clipping and stacking regressions; malformed shared input also needed visible feedback. | `qml/pages/ComparisonPage.qml` | High | Open Compare at desktop and minimum width; inspect node spread, then submit empty, malformed, valid, and over-limit input. | Earlier valid/malformed input and layout checks passed, but the purple-theme visual pass exposed nodes stacked at the left. Latest fix uses explicit canvas dimensions and vertical centering; build/CTest pass, runtime recheck pending. |
| FUNC-01 | Graph traversal timer ignored the shared playback speed preference, so Settings appeared to work only in sorting/comparison. | `src/controllers/graphcontroller.*`, `qml/Main.qml` | Medium | Change playback speed in Settings and run graph playback. | Fixed in code: GraphController has bounded speed and Main synchronizes it with initial preference, changes, and reset. Controller bounds are tested; full UI playback-speed interaction remains pending.
| FUNC-02 | Search target input reverted to the previous target after changing the array. | `qml/components/AlgorithmInputBar.qml`, search controller bridge in `qml/pages/SortingPage.qml` | High | Set a new target and submit/search while the array trace is regenerated. | Resolved and verified live: target is captured before accepted input updates the model; Search trace and assistant reflect target 1. |
| UI-09 | Compare node positioning used implicit parent dimensions and did not reliably distribute nodes across the canvas. | `qml/pages/ComparisonPage.qml` | High | Open Compare and inspect node positions in both panels. | Consolidated into UI-08; retained here as the implicit-parent root cause. Explicit `visualArea.width/height` fix is built; runtime confirmation is pending. |
| UI-10 | SVG image icon files did not render with the installed Qt image plugin set. | `qml/components/Icon.qml`, former `qml/icons/*.svg` | Medium | Launch app and inspect navigation and action icons. | Resolved and verified live: icons are drawn with Qt Quick Shapes vector paths; startup output is clean. |
| UI-11 | Sorting assistant panel obscured/crowded the visualization in a compact window. | `qml/pages/SortingPage.qml` | High | Resize to compact width and open Sorting. | Resolved and verified live at 975×700: layout stacks vertically, assistant is closed by default, and nodes/input/playback remain visible. |

High-priority Compare positioning remains open pending a runtime recheck of the latest fix. Graph playback and accessibility interactions also need coverage. The tree depth-boundary rejection message has controller coverage but not live visual verification. Prior package startup issue (bundled Qt Quick Controls imports) was fixed using a package-local `qt.conf`; retain as history below.

## Failed Attempts & Blockers

| Attempt / failure | What happened and why | What was tried | Remaining / next approach |
|---|---|---|---|
| Initial v1.2 package launch | Clean deployed package could not resolve Qt Quick Controls QML imports from its bundled layout. | Added package-local `qt.conf` with relative `Prefix`, `Plugins`, and `QmlImports`; final isolated launch succeeded. | Resolved for v1.2.0. |
| Reused build-session poll | Previous shell session ID was no longer available. | Read existing CTest `LastTest.log`, which records 1/1 passed at 02:44 PKT. | Run a new build and CTest; do not infer the current UI compiled from the old test log. |
| Initial sidebar header layout | Screenshot showed intrinsic subtitle width extending into the content area. | Constrained brand width, elided long text, and added compact-width naming. | Visually verify at desktop and compact sizes. |
| Settings panel scope | Existing panel only exposed reduced motion. | Added saved playback speed and sidebar startup preference plus reset action. | Interact with each control and verify values after restart. |
| Flow implicit height | First responsive structure-row version assigned the read-only `Flow.implicitHeight`, causing QML component loading to fail at runtime. | Changed to a width-dependent `Layout.preferredHeight`; added a narrow-mode canvas cap and tighter spacing. | Release build and app startup succeeded; Linked List, Stack, Queue, and Tree screens are now verified at minimum width. |
| Tree area ignored Layout hints | The tree canvas was inside a plain `Item`, so attached `Layout.fillWidth/Height` hints did not size it; nodes used a zero-width parent and stacked at the edge. | Anchored the named tree area to its parent; node x bindings explicitly use its width. | Runtime screenshot shows centered tree layout at the minimum width. |
| BST visualization depth exceeded fixed canvas | The controller accepted arbitrary-depth BST inserts, while the view reserved only four rows; its depth coordinate also used a bit shift that could overflow. | Added a pre-insert depth check in `BinarySearchTree` use and reject beyond depth 3 with a clear controller status; added boundary regression coverage. | Release build/CTest pass; beyond-boundary rejection was checked in the controller test; runtime status rendering remains pending. |
| Graph edge feedback was missing | The Graph page had no persistent success or validation message after edge insertion. | Added a dedicated feedback row that confirms successful endpoints/weight and explains rejected input. | Release build passes; UI Automation verified both successful and invalid self-edge feedback. |
| Compare node positioning overflowed the cards | Fixed interval spacing made the default seven nodes exceed each half-width comparison card, and larger input increased the overflow. | Replaced the fixed positions with card-width-aware spacing that preserves all node identities and centers a one-node trace. | Release build passes; visual size/input checks remain pending. |
| QML SVG icon loading | The existing Qt deployment lacked the SVG image decoder, so Image-based SVG icons logged `Unsupported image format`. | Replaced image assets with shared Qt Quick Shapes vector paths, then removed unused SVG resources. | Rebuilt and launched cleanly; live Dashboard/sidebar shows icons. |
| Dashboard delegate index binding | `index` was used without declaring it on the Repeater delegate; an earlier misplaced required property also caused component initialization failure. | Declared `required property int index` on the Repeater delegate only and removed it from LabCard. | Release rebuild and runtime Dashboard interaction pass; no QML startup errors. |
| Search target lost during new input submission | The model update emitted `stateChanged` before target submission and rewrote the target field to its prior value. | Store requested target before `sortInput`; make `sortInput` report acceptance and apply target only after accepted input. | Release tests and live Search target=1 interaction pass; assistant and trace show the new target. |
| Compare cards overlapped after width extraction | `Flow` initially used `parent.availableWidth`, resolving to the wrong implicit parent width and collapsing cards. | Bind to `cardsScroll.availableWidth` and assign explicit responsive card widths/heights. | Release build and desktop runtime show two non-overlapping cards with all default nodes. |
| Inline QML child syntax in Comparison controls | An inline RowLayout edit left statement separators after sibling child items and failed QML parsing. | Expanded child declarations onto separate lines. | Subsequent Release build and runtime launch pass. |
| Settings slider automation attempt | Programmatic value setting changed the accessible slider value without invoking its `moved` handler, so persistence did not run. | Repeated the test with a real pointer drag, then restarted and inspected the setting. | Verified 1.5× persisted across app restart; restored setting to 1.0×. |
| Compare runtime node layout during palette pass | The updated Compare screenshot showed multiple nodes stacked at the left edge despite the cards themselves fitting side by side. | Rebound horizontal spacing and vertical centering to the named visualization Item's dimensions instead of implicit `parent` values; rebuilt in a separate directory to avoid disturbing the user's live app. | Release build and CTest pass; the window received user input and moved to Searching, so the latest Compare rendering still needs runtime verification. |
| Narrow tree rows collided with status text | Fixed horizontal centering exposed the third tree level underneath the status line and a truncated mode selector. | Reduced narrow-only tree row spacing, aligned canvas edges with node spacing, moved tree status below the canvas, and widened the mode selector. | Runtime screenshot shows all levels, status, selector, and operation controls unobstructed. |

No active external blocker is known.

## UI/UX Improvement Backlog

| Priority | Area | Improvement | State |
|---|---|---|---|
| High | Navigation | Confirm keyboard focus and collapsed-nav tooltips in addition to selected state and labels. | Visual hierarchy verified; keyboard/focus review pending |
| High | Buttons | Review primary/secondary action consistency in every module. | Improved and verified in Dashboard, Sorting and Compare; full sweep pending |
| High | Responsive layout | Keep nav and visualizer usable at narrow window sizes; avoid crowding and clipped controls. | Structure pages verified at 780 px and Sorting at 975×700; Compare positioning fix built but desktop/compact screenshots pending |
| High | Comparison | Keep both node traces centered, legible, and distributed across balanced panels at all widths. | Latest explicit-area positioning fix built; runtime recheck pending |
| Medium | Accessibility | Verify keyboard operation, accessible names, and reduced-motion behavior in runtime. | Implemented in part; verification pending |
| Medium | Animation | Check structure entrance/removal, tree repositioning, graph paths, and sorting motion in live playback. | Implemented; runtime check pending |
| Medium | Layout | Validate saved splitter positions and hide/show behavior. | Implemented; runtime check pending |
| Low | Visual consistency | Refine spacing, typography, and accent usage where live inspection identifies mismatches. | Backlog |

## Testing & Build History

| Date | Build / test | Result | Notes |
|---|---|---|---|
| 2026-11-20 | Earlier Release CTest in `out/release-v1.2.0-ui` | Passed: `algorithm_generators` 1/1, 1.17 seconds | Recorded in `Testing/Temporary/LastTest.log` at 02:44 PKT. This run predates later UI edits; a fresh verification is recorded below. |
| 2026-11-20 | Fresh Release build and CTest after settings, sidebar, timeline, placeholder, and responsive structure changes | Passed: `algorithm_generators` 1/1; `git diff --check` reported only Git line-ending notices | Runtime screenshots verified the settings panel, expanded sidebar, populated sorting input, and capped timeline. A first StructurePage launch failed due to assigning read-only `Flow.implicitHeight`; after correction the app launched successfully. Narrow-width layout not yet checked. |
| 2026-11-20 | Release build/CTest after BST depth guard and Graph feedback row | Passed: `algorithm_generators` 1/1; `git diff --check` reported only line-ending notices | An earlier QML compile failed due to a statement separator after the Graph click handler; after correction, a link attempt was blocked because the running Algorythm process locked the executable. Closed that instance, then build/CTest passed. Controller tree-boundary tests passed. UI Automation verified Graph valid/invalid feedback and Compare invalid/valid input. |
| 2026-11-20 | Release build/CTest after graph speed preference, Compare card geometry/input validation, and explicit Sorting dialog widths | Passed: `algorithm_generators` 1/1; `git diff --check` reported only line-ending notices | Graph speed clamping test passed. The final rebuilt Windows package was launched with only Windows directories on `PATH`; the process remained open with the correct window title and captured stderr was empty. Dialog and Compare interactions remain unverified at runtime. |
| 2026-11-20 | Release build and CTest with settings tests and narrow structure layout | Passed: `algorithm_generators` 1/1, 1.16 seconds | Settings tests use an isolated temporary INI store and cover defaults, clamped speed, preference/workspace persistence, and reset. A 780 px narrow-window capture confirmed Stack controls remain visible; Linked List wrapping still needs a direct capture. |
| 2026-11-20 | Fresh Release build/CTest after BST narrow-layout fixes | Passed: `algorithm_generators` 1/1; `git diff --check` returned only line-ending notices | Live captures at 780 px verified the complete Linked List, Stack, Queue, and BST views. BST nodes and connectors are centered, all three levels and status are visible, the selector label is no longer truncated, and action controls remain visible. |
| 2026-11-20 | Main/sidebar and Dashboard refactor, vector icon system, Sorting component extraction, algorithm source split, and Compare playback synchronization | Passed: final Release build up to date; fresh CTest `algorithm_generators` 1/1 (1.24 sec); `git diff --check` had only line-ending notices | Runtime verified desktop/compact Dashboard, compact Sorting input and playback, valid/invalid Sorting input, Search target update, desktop Compare layout, valid/malformed Compare input, and Run Both from mixed running/completed states. Initial SVG decoder, delegate index, QML syntax and Flow width issues were corrected before this run. |
| 2026-11-20 | Settings persistence runtime restart check | Passed: app restart retained a real 1.5× slider change; restored 1.0× after check | Confirms user-facing settings save/reload path; app left open with the default speed. |
| 2026-11-20 | Purple visual foundation, Dashboard overview cards, distinct algorithm node states, Compare explicit-canvas layout fix | Passed: final Release build in `out/neon-review`; fresh CTest `algorithm_generators` 1/1 (1.11 sec); `git diff --check` only reported line-ending notices | Runtime visually confirmed purple Dashboard and Sorting. Compare runtime exposed nodes stacked on the left; explicit visualization-area sizing/centering and completed-state precedence were then implemented and built, but not visually rechecked after the app window received user input. |
| Prior v1.1 work | Release algorithm tests and packaged app launch | Passed in prior session | v1.1.0 package published; exact current UI is newer and unverified. |
| 2026-11-20 | Final v1.2 package dependency closure and smoke test | Passed: 25 transitive DLLs from the selected Qt/MinGW toolchain were staged; dependency scan found no unresolved non-system DLLs; isolated-path launch stayed open with empty stderr | `windeployqt` omitted compiler runtime and transitive MinGW dependencies. `qt.conf` and the copied dependency closure resolved launch-time imports. Release v1.2.0 was published with the 46,044,844-byte archive; GitHub API digest matches the local SHA-256. Interactive package checks remain pending. |

## Development History

| Date | Change | Why | Files / modules | Verification |
|---|---|---|---|---|
| 2026-11-20 | Started v1.2 UI/algorithm refinement: saved splitter and hideable assistant, reduced motion, incremental structure models, stable sorting/merge snapshots, animated structure/graph updates. | Improve learning feedback, correctness of traces, and workspace control. | `qml/`, `src/`, `tests/`, `CMakeLists.txt` | Release algorithm/model test 1/1 passed before latest sidebar styling edits. |
| 2026-11-20 | Reworked Material dark visual system, navigation buttons, collapsed sidebar tooltips, and key action priorities. | Respond to user's direct complaint that buttons/sidebar were poor. | `qml/Main.qml`, page QML, `src/main.cpp` | Latest Release build passed; visual verification is pending. |
| 2026-11-20 | Fixed sidebar brand overflow and expanded persistent Settings; styled dashboard primary CTA. | User screenshots showed overlapping brand text and asked whether Settings had only one option. | `qml/Main.qml`, `qml/pages/DashboardPage.qml`, `src/controllers/settingscontroller.h` | Release build and CTest passed. Later live screenshots verified the expanded brand and settings panel; preference behavior across restart is still open. |
| 2026-11-20 | Capped and centered playback timeline, removed floating input hint, repositioned Settings popup, and made structure controls wrap for narrow pages. | Fix additional layout problems visible in user screenshots and proactively address minimum-width overflow. | `qml/components/PlaybackControls.qml`, `qml/pages/SortingPage.qml`, `qml/Main.qml`, `qml/pages/StructurePage.qml` | Release build and CTest passed. Live app verified sidebar/input/timeline/settings; fixed a Flow runtime error and confirmed subsequent app startup. Minimum-width wrap still pending. |
| 2026-11-20 | Added settings persistence/reset tests and tightened StructurePage at narrow sizes. | Verify SettingsController behavior and keep structure controls visible on smaller displays. | `tests/algorithm_tests.cpp`, `CMakeLists.txt`, `qml/pages/StructurePage.qml` | Fresh Release build/CTest passed. Live captures verified Linked List, Stack, Queue, and Tree at 780 px. |
| 2026-11-20 | Fixed BST parent sizing, node alignment, narrow level spacing, and status/selector clipping. | Proactive check of Tree view found its drawing area had zero size and later exposed narrow-height overlap. | `qml/pages/StructurePage.qml` | Fresh Release build/CTest passed; final 780 px screenshot confirms every tree node, connector, selector label, status, and control is visible. |
| 2026-11-20 | Connected Graph playback to saved speed; fixed Compare overflow/validation, capped BST visualization depth, and surfaced Graph edge errors. | Close functional and layout consistency gaps found during cross-page audit. | `src/controllers/graphcontroller.*`, `src/controllers/structurecontroller.cpp`, `src/datastructures/structures.h`, `qml/Main.qml`, `qml/pages/ComparisonPage.qml`, `qml/pages/GraphPage.qml`, `tests/algorithm_tests.cpp` | Latest Release build/CTest passed; controller boundary tests passed; QML runtime interactions pending. |
| 2026-11-20 | Refactored app shell and Dashboard; introduced reusable native vector icons and Sorting subcomponents; separated sort/search source files; synchronized Run Both controller state transitions; fixed Search target update ordering and Compare card sizing. | Address user-reported sidebar/button quality and stabilize high-impact workflow defects without replacing existing algorithms. | `qml/Main.qml`, `qml/components/`, `qml/pages/`, `src/algorithms/`, `src/engine/playbackcontroller.*`, `tests/algorithm_tests.cpp`, `CMakeLists.txt` | Release build/CTest passed; runtime checks listed above passed. Compact Compare and Graph-focused verification remain unfinished. |
| 2026-11-20 | Applied premium purple palette, multi-panel dashboard overview, semantic algorithm node states, sidebar width transition, and adjusted Compare node coordinates to the explicit canvas. | Match the supplied visual direction across the existing native QML app and address a Compare issue found during screenshot review. | `qml/Main.qml`, `qml/components/`, `qml/pages/`, `CMakeLists.txt` | Isolated Release build/CTest passed; Dashboard and Sorting screenshots confirmed. Latest Compare fix awaits runtime visual confirmation. |
| 2026-11-20 | Added this project status tracker and reconciled claims to repository and existing test log. | Keep current state and history auditable. | `PROJECT_STATUS.md` | File contents cross-checked against working tree and test log. |

## NEXT PRIORITIES

1. Reopen the latest build once the live app is available for verification; confirm both Compare traces distribute correctly, including 780 px, and cover empty/over-limit input.
2. Exercise Graph traversal speed, pause/resume, previous/next, restart, and edge feedback; inspect tree depth rejection.
3. Check Sorting prediction dialogs, Settings accessibility toggles, keyboard navigation and workspace splitter persistence.
4. Rebuild/retest after any fixes, then commit and push the verified code plus `PROJECT_STATUS.md` to `main`.
5. Package a new v1.3.0 release only after remaining runtime checks and package smoke test pass; v1.2.0 is already published and must remain unchanged.
