# Algorythm Project Status

Last reconciled: 2026-11-20 (UTC)

This file tracks verified repository state. Items are marked complete only after the stated checks have run.

## Completed Features

| Feature | Implementation | Key files | Verification |
|---|---|---|---|
| Algorithm playback and core visualizers | Sorting, searching, data-structure, graph, and comparison views with playback controls | `qml/pages/`, `src/algorithms/`, `src/controllers/`, `src/engine/` | Existing application and algorithm test suite; algorithm test passed in Release on 2026-11-20 (see history) |
| Per-step algorithm variables | Reversible snapshots expose variable state during algorithm playback | `qml/components/VariablesPanel.qml`, `qml/pages/SortingPage.qml`, `src/algorithms/bubblesort.cpp` | Covered by algorithm tests in prior verified v1.1 work |
| Graph traversal path animation | Traversal updates active graph edges during playback | `qml/pages/GraphPage.qml`, `src/controllers/graphcontroller.cpp` | Existing app verification in prior v1.1 work |
| Stable insertion-sort identities and merge snapshots | Adjacent swaps preserve duplicate item identities; merge snapshots show a consistent partial output | `src/algorithms/bubblesort.cpp`, `tests/algorithm_tests.cpp` | Release test log `out/release-v1.2.0-ui/Testing/Temporary/LastTest.log`: 1/1 passed, 2026-11-20 |
| Incremental structure visualization models | Linked list, stack, queue, and tree models publish incremental updates for animated transitions | `src/controllers/structurecontroller.h`, `src/controllers/structurecontroller.cpp`, `qml/pages/StructurePage.qml` | Release algorithm/model test passed 1/1 on 2026-11-20 |
| Local settings and persistence | Reduced motion, playback speed, compact sidebar startup, workspace split persistence, and restore-defaults action | `src/controllers/settingscontroller.h`, `src/main.cpp`, `qml/Main.qml`, `tests/algorithm_tests.cpp` | Settings panel visually checked; tests cover defaults, speed bounds, saving/reloading values, workspace state, and reset. Restart behavior in the packaged app remains pending. |
| Sort workspace splitter and persisted layout | Resizable workspace split can hide/show assistant and saves/restores divider state | `qml/pages/SortingPage.qml`, `src/controllers/settingscontroller.h` | Implemented; verify in runtime pass |
| GitHub v1.1.0 release | Windows x64 package released from earlier stable revision | GitHub release `v1.1.0` | Published and verified in prior development session |
| GitHub v1.2.0 release | Published Windows x64 package for commit `7a34e3a` | [Release v1.2.0](https://github.com/RAYYAN-HTML/algorythm/releases/tag/v1.2.0) | GitHub API confirmed published (not draft); uploaded asset is 46,044,844 bytes and its SHA-256 matches the local archive. |
| Graph playback speed preference | Graph traversal timer follows the persisted shared playback speed and clamps it to the same 0.5×–3× range as sorting | `src/controllers/graphcontroller.h`, `src/controllers/graphcontroller.cpp`, `qml/Main.qml` | Controller speed bounds tested in the Release test suite; full app runtime preference interaction pending |
| Compare layout and shared-input validation | Compare nodes are laid out within each card at all supported trace sizes; invalid shared input now has a visible message and is rejected before either trace changes | `qml/pages/ComparisonPage.qml` | Release build and test suite passed; visual interaction verification pending |

## Currently Working

- Ongoing quality pass after the v1.2.0 release: complete runtime interaction and responsive checks for Compare, Graph, Searching, Sorting dialogs, and packaged Settings persistence.
- Compare card geometry and shared-input validation were corrected and compiled, but page-level visual behavior still needs inspection at minimum and maximized widths.
- Graph timer now shares saved speed with sorting/comparison; controller clamping is tested, while runtime speed/rewind/restart/edge interactions remain unverified.
- Existing live verification remains valid for sidebar brand, Settings panel contents, Sorting input/timeline, and all four structure pages at the 780 px minimum. The latest package launch is clean in isolation.

## Remaining Work

### High priority

- Complete runtime interaction and resized-layout checks on Sorting, Searching, Compare, Graph, and Settings.
- Verify persisted settings after restarting the released package, and exercise graph speed/playback controls and sorting dialogs.
- Fix any new reproducible defects, rerun Release build/CTest, and update the tracker.

### Medium priority

- Review navigation and control styling consistently across every algorithm module.
- Verify settings and workspace persistence after restarting the application.
- Verify animations through interactive use across structure, sorting, and graph screens.

### Low priority

- Add further visual polish where runtime inspection shows a concrete usability improvement.
- Keep README and research notes aligned with the final shipped UI.

## Pending Tasks

### High

1. Live-check Compare node positions at 780 px and maximized width; submit valid, empty, malformed, and over-limit inputs.
2. Check Graph playback speed, pause/resume, previous/next, restart, timeline-equivalent stepping, and edge insertion.
3. Verify Settings persistence across restart and Sorting prediction/feedback dialogs; inspect Search target behavior.
4. Reconcile further defects in `PROJECT_STATUS.md` and rerun Release build/CTest after fixes.

### Medium

1. Runtime pass through Sorting, Searching, Structures, Graphs, Compare, Settings.
2. Verify compact window behavior, keyboard navigation, and reduced-motion behavior.
3. Verify saved settings survive restart.

### Low

1. Follow-up refinements from visual inspection and user feedback.

## Bugs & Issues

| ID | Issue | Component | Severity | Reproduction | Status / investigation |
|---|---|---|---|---|---|
| UI-01 | User reports sidebar and buttons look poor (initial screenshot showed weak hierarchy and default-looking controls). | `qml/Main.qml`, shared QML controls | High | Open app and inspect navigation/action controls. | In Progress: clearer selected navigation and primary actions are verified on Sorting; other modules and minimum-width behavior still need review. |
| UI-02 | Sidebar brand subtitle overflowed into the dashboard header. | `qml/Main.qml` sidebar header | High | Open expanded Dashboard at desktop width; inspect brand row near sidebar edge. | Resolved and verified in live app: bounded/elided brand stays within the sidebar in expanded mode; compact mode is also usable. |
| UI-03 | Input screenshot showed a floating example hint above a populated value. | `qml/pages/SortingPage.qml` input row | Medium | Open Sorting or Searching with default input. | Resolved and verified in live app: removed the redundant placeholder; field label and value render on one line. |
| UI-04 | Settings exposed only Reduced motion. | `qml/Main.qml`, `src/controllers/settingscontroller.h` | Medium | Open Settings from the sidebar. | Panel shows playback speed, reduced motion, compact sidebar, and restore defaults; visually verified. Unit tests verify saved/reloaded preferences and reset. Packaged-app restart behavior remains open. |
| UI-05 | Playback timeline stretched across the entire workspace and ended at the far right on the final step. | `qml/components/PlaybackControls.qml` | Medium | Open an algorithm with a long trace or hide the assistant. | Resolved and verified in live app: timeline capped at 760 px, centered, with a step tooltip. It still correctly moves to the far right at the final step. |
| UI-06 | Structure action controls or visualizations may overflow at the minimum supported width. | `qml/pages/StructurePage.qml` | Medium | Resize app to its 780 px minimum and open Linked Lists, Stacks, Queues, and Trees. | Resolved and verified in live captures: Linked List Position and operation controls wrap cleanly; Stack and Queue controls fit; Tree and mode selector remain legible, with all nodes/edges and status visible. |
| UI-07 | BST nodes initially appeared stacked on the canvas edge; after positioning was fixed, the deepest row and status text overlapped. | `qml/pages/StructurePage.qml` tree canvas | High | At minimum width, open Trees. | Resolved and verified: the tree area is anchored to its parent, nodes use that area's width, narrow vertical spacing is synchronized with edges, the status moves below the canvas, and the mode selector has enough width. Screenshot confirms the full three-level sample tree and controls. |
| UI-08 | Compare cards placed algorithm nodes at a fixed 68 px interval, clipping the default sequence on both sides and hiding more nodes for larger inputs; invalid shared input gave no visible feedback. | `qml/pages/ComparisonPage.qml` | High | Open Compare at default width; inspect both cards, then submit empty, malformed, or over-16 values. | Fixed in source and compiled: node spacing adapts to card width, and validation reports errors before either trace changes. Live interaction/resize verification remains pending. |
| FUNC-01 | Graph traversal timer ignored the shared playback speed preference, so Settings appeared to work only in sorting/comparison. | `src/controllers/graphcontroller.*`, `qml/Main.qml` | Medium | Change playback speed in Settings and run graph playback. | Fixed in code: GraphController has bounded speed and Main synchronizes it with initial preference, changes, and reset. Controller bounds are tested; full UI playback-speed interaction remains pending.

No unresolved high-severity defect has been confirmed after the fixes above; UI-08 remains open until live responsive and input interaction checks pass. Searching and Graph still need their runtime pass. Prior package startup issue (bundled Qt Quick Controls imports) was fixed using a package-local `qt.conf`; retain as history below.

## Failed Attempts & Blockers

| Attempt / failure | What happened and why | What was tried | Remaining / next approach |
|---|---|---|---|
| Initial v1.2 package launch | Clean deployed package could not resolve Qt Quick Controls QML imports from its bundled layout. | Added package-local `qt.conf` with relative `Prefix`, `Plugins`, and `QmlImports`; final isolated launch succeeded. | Resolved for v1.2.0. |
| Reused build-session poll | Previous shell session ID was no longer available. | Read existing CTest `LastTest.log`, which records 1/1 passed at 02:44 PKT. | Run a new build and CTest; do not infer the current UI compiled from the old test log. |
| Initial sidebar header layout | Screenshot showed intrinsic subtitle width extending into the content area. | Constrained brand width, elided long text, and added compact-width naming. | Visually verify at desktop and compact sizes. |
| Settings panel scope | Existing panel only exposed reduced motion. | Added saved playback speed and sidebar startup preference plus reset action. | Interact with each control and verify values after restart. |
| Flow implicit height | First responsive structure-row version assigned the read-only `Flow.implicitHeight`, causing QML component loading to fail at runtime. | Changed to a width-dependent `Layout.preferredHeight`; added a narrow-mode canvas cap and tighter spacing. | Release build and app startup succeeded; Linked List, Stack, Queue, and Tree screens are now verified at minimum width. |
| Tree area ignored Layout hints | The tree canvas was inside a plain `Item`, so attached `Layout.fillWidth/Height` hints did not size it; nodes used a zero-width parent and stacked at the edge. | Anchored the named tree area to its parent; node x bindings explicitly use its width. | Runtime screenshot shows centered tree layout at the minimum width. |
| Compare node positioning overflowed the cards | Fixed interval spacing made the default seven nodes exceed each half-width comparison card, and larger input increased the overflow. | Replaced the fixed positions with card-width-aware spacing that preserves all node identities and centers a one-node trace. | Release build passes; visual size/input checks remain pending. |
| Narrow tree rows collided with status text | Fixed horizontal centering exposed the third tree level underneath the status line and a truncated mode selector. | Reduced narrow-only tree row spacing, aligned canvas edges with node spacing, moved tree status below the canvas, and widened the mode selector. | Runtime screenshot shows all levels, status, selector, and operation controls unobstructed. |

No active external blocker is known.

## UI/UX Improvement Backlog

| Priority | Area | Improvement | State |
|---|---|---|---|
| High | Navigation | Give current section, hover, keyboard focus, and collapsed tooltips clear readable states. | Implemented, awaiting visual verification |
| High | Buttons | Distinguish primary actions from secondary actions; eliminate default-looking controls and preserve legibility. | Implemented across key screens, awaiting visual verification |
| High | Responsive layout | Keep nav and visualizer usable at narrow window sizes; avoid crowding and clipped controls. | Linked List, Stack, Queue, and Tree verified at 780 px; Compare geometry fixed in source, visual verification pending; review other modules |
| Medium | Accessibility | Verify keyboard operation, accessible names, and reduced-motion behavior in runtime. | Implemented in part; verification pending |
| Medium | Animation | Check structure entrance/removal, tree repositioning, graph paths, and sorting motion in live playback. | Implemented; runtime check pending |
| Medium | Layout | Validate saved splitter positions and hide/show behavior. | Implemented; runtime check pending |
| Low | Visual consistency | Refine spacing, typography, and accent usage where live inspection identifies mismatches. | Backlog |

## Testing & Build History

| Date | Build / test | Result | Notes |
|---|---|---|---|
| 2026-11-20 | Earlier Release CTest in `out/release-v1.2.0-ui` | Passed: `algorithm_generators` 1/1, 1.17 seconds | Recorded in `Testing/Temporary/LastTest.log` at 02:44 PKT. This run predates later UI edits; a fresh verification is recorded below. |
| 2026-11-20 | Fresh Release build and CTest after settings, sidebar, timeline, placeholder, and responsive structure changes | Passed: `algorithm_generators` 1/1; `git diff --check` reported only Git line-ending notices | Runtime screenshots verified the settings panel, expanded sidebar, populated sorting input, and capped timeline. A first StructurePage launch failed due to assigning read-only `Flow.implicitHeight`; after correction the app launched successfully. Narrow-width layout not yet checked. |
| 2026-11-20 | Release build/CTest after graph speed preference, Compare card geometry/input validation, and explicit Sorting dialog widths | Passed: `algorithm_generators` 1/1; `git diff --check` reported only line-ending notices | Graph speed clamping test passed. The final rebuilt Windows package was launched with only Windows directories on `PATH`; the process remained open with the correct window title and captured stderr was empty. Dialog and Compare interactions remain unverified at runtime. |
| 2026-11-20 | Release build and CTest with settings tests and narrow structure layout | Passed: `algorithm_generators` 1/1, 1.16 seconds | Settings tests use an isolated temporary INI store and cover defaults, clamped speed, preference/workspace persistence, and reset. A 780 px narrow-window capture confirmed Stack controls remain visible; Linked List wrapping still needs a direct capture. |
| 2026-11-20 | Fresh Release build/CTest after BST narrow-layout fixes | Passed: `algorithm_generators` 1/1; `git diff --check` returned only line-ending notices | Live captures at 780 px verified the complete Linked List, Stack, Queue, and BST views. BST nodes and connectors are centered, all three levels and status are visible, the selector label is no longer truncated, and action controls remain visible. |
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
| 2026-11-20 | Connected the graph timer to the shared playback-speed preference and fixed Compare node overflow plus invalid-input feedback. | Close functional and layout consistency gaps found during cross-page audit. | `src/controllers/graphcontroller.*`, `qml/Main.qml`, `qml/pages/ComparisonPage.qml`, `tests/algorithm_tests.cpp` | Release build and CTest passed; runtime interaction pending. |
| 2026-11-20 | Added this project status tracker and reconciled claims to repository and existing test log. | Keep current state and history auditable. | `PROJECT_STATUS.md` | File contents cross-checked against working tree and test log. |

## NEXT PRIORITIES

1. Finish runtime verification of Compare responsive nodes and valid/invalid shared input; inspect at minimum and maximized sizes.
2. Exercise Graph speed preference, playback, rewind, restart, edge insertion, and reduced motion; check Searching and Sorting controls/dialogs.
3. Verify saved Settings after restarting the clean package and inspect settings values; isolated-path launch and empty startup stderr are already confirmed.
4. Commit and push the verified code and tracker, then publish v1.2.0 with the verified Windows x64 asset.
5. Reconcile any defects found during remaining runtime checks before calling the broad quality overhaul complete.
