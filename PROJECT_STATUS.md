# Algorythm Project Status

Last reconciled: 2026-11-20

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

## Currently Working

- Major visual redesign focused on sidebar navigation and action controls. Material dark palette, cyan/purple accents, semantic keyboard-accessible nav buttons, selected/hover states, collapse behavior, and primary/secondary button hierarchy are implemented in the working tree. This directly addresses the user's complaint that the sidebar and buttons look poor.
- User screenshots exposed sidebar brand text spilling into the dashboard header and a settings panel containing only one option. The brand now has constrained widths and elision; Settings now includes persisted playback speed, reduced motion, compact startup sidebar, and restore defaults. Dashboard CTA now has a cyan primary style.
- The timeline is now capped at 760 px and centered in the playback card. The redundant floating input placeholder is removed. The settings popup opens beside the navigation, and its expanded controls were visually inspected. The expanded sidebar brand fits within its column.
- The latest Release build and CTest pass, including isolated settings persistence/reset tests. At the 780 px minimum width, Linked List, Stack, Queue, and Tree canvases and action controls have all been inspected live. The BST now uses the real parent area for positioning, compact vertical level spacing, a full-width mode selector, and a separate status line below the canvas.

## Remaining Work

### High priority

- Review remaining algorithm modules for clipped controls at narrow widths. Close an existing Algorythm instance before opening another.
- Iterate on the button/sidebar design based on actual rendering; check keyboard focus, compact widths, and reduced motion.
- Rebuild a clean Windows x64 package from the verified build and check startup with bundled Qt imports.
- Commit and push the complete stable update, then publish the requested GitHub release with its verified package.

### Medium priority

- Review navigation and control styling consistently across every algorithm module.
- Verify settings and workspace persistence after restarting the application.
- Verify animations through interactive use across structure, sorting, and graph screens.

### Low priority

- Add further visual polish where runtime inspection shows a concrete usability improvement.
- Keep README and research notes aligned with the final shipped UI.

## Pending Tasks

### High

1. Inspect narrow-window structure controls and the Settings panel interactions/persistence.
2. Review remaining modules for cramped or default-looking buttons; fix verified problems.
3. Clean package launch verification.
4. Git commit, push, and GitHub release for the finished stable revision.

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

No other currently reproduced open defects are known. Prior package startup issue (bundled Qt Quick Controls imports) was fixed using a package-local `qt.conf`; retain as history below.

## Failed Attempts & Blockers

| Attempt / failure | What happened and why | What was tried | Remaining / next approach |
|---|---|---|---|
| Initial v1.2 package launch | Clean deployed package could not resolve Qt Quick Controls QML imports from its bundled layout. | Added package-local `qt.conf` with relative `Prefix`, `Plugins`, and `QmlImports`; subsequent clean package launch succeeded. | Recreate the package from the final current build and verify again before release. |
| Reused build-session poll | Previous shell session ID was no longer available. | Read existing CTest `LastTest.log`, which records 1/1 passed at 02:44 PKT. | Run a new build and CTest; do not infer the current UI compiled from the old test log. |
| Initial sidebar header layout | Screenshot showed intrinsic subtitle width extending into the content area. | Constrained brand width, elided long text, and added compact-width naming. | Visually verify at desktop and compact sizes. |
| Settings panel scope | Existing panel only exposed reduced motion. | Added saved playback speed and sidebar startup preference plus reset action. | Interact with each control and verify values after restart. |
| Flow implicit height | First responsive structure-row version assigned the read-only `Flow.implicitHeight`, causing QML component loading to fail at runtime. | Changed to a width-dependent `Layout.preferredHeight`; added a narrow-mode canvas cap and tighter spacing. | Release build and app startup succeeded; Linked List, Stack, Queue, and Tree screens are now verified at minimum width. |
| Tree area ignored Layout hints | The tree canvas was inside a plain `Item`, so attached `Layout.fillWidth/Height` hints did not size it; nodes used a zero-width parent and stacked at the edge. | Anchored the named tree area to its parent; node x bindings explicitly use its width. | Runtime screenshot shows centered tree layout at the minimum width. |
| Narrow tree rows collided with status text | Fixed horizontal centering exposed the third tree level underneath the status line and a truncated mode selector. | Reduced narrow-only tree row spacing, aligned canvas edges with node spacing, moved tree status below the canvas, and widened the mode selector. | Runtime screenshot shows all levels, status, selector, and operation controls unobstructed. |

No active external blocker is known.

## UI/UX Improvement Backlog

| Priority | Area | Improvement | State |
|---|---|---|---|
| High | Navigation | Give current section, hover, keyboard focus, and collapsed tooltips clear readable states. | Implemented, awaiting visual verification |
| High | Buttons | Distinguish primary actions from secondary actions; eliminate default-looking controls and preserve legibility. | Implemented across key screens, awaiting visual verification |
| High | Responsive layout | Keep nav and visualizer usable at narrow window sizes; avoid crowding and clipped controls. | Linked List, Stack, Queue, and Tree verified at 780 px; review other modules |
| Medium | Accessibility | Verify keyboard operation, accessible names, and reduced-motion behavior in runtime. | Implemented in part; verification pending |
| Medium | Animation | Check structure entrance/removal, tree repositioning, graph paths, and sorting motion in live playback. | Implemented; runtime check pending |
| Medium | Layout | Validate saved splitter positions and hide/show behavior. | Implemented; runtime check pending |
| Low | Visual consistency | Refine spacing, typography, and accent usage where live inspection identifies mismatches. | Backlog |

## Testing & Build History

| Date | Build / test | Result | Notes |
|---|---|---|---|
| 2026-11-20 | Earlier Release CTest in `out/release-v1.2.0-ui` | Passed: `algorithm_generators` 1/1, 1.17 seconds | Recorded in `Testing/Temporary/LastTest.log` at 02:44 PKT. This run predates later UI edits; a fresh verification is recorded below. |
| 2026-11-20 | Fresh Release build and CTest after settings, sidebar, timeline, placeholder, and responsive structure changes | Passed: `algorithm_generators` 1/1; `git diff --check` reported only Git line-ending notices | Runtime screenshots verified the settings panel, expanded sidebar, populated sorting input, and capped timeline. A first StructurePage launch failed due to assigning read-only `Flow.implicitHeight`; after correction the app launched successfully. Narrow-width layout not yet checked. |
| 2026-11-20 | Release build and CTest with settings tests and narrow structure layout | Passed: `algorithm_generators` 1/1, 1.16 seconds | Settings tests use an isolated temporary INI store and cover defaults, clamped speed, preference/workspace persistence, and reset. A 780 px narrow-window capture confirmed Stack controls remain visible; Linked List wrapping still needs a direct capture. |
| 2026-11-20 | Fresh Release build/CTest after BST narrow-layout fixes | Passed: `algorithm_generators` 1/1; `git diff --check` returned only line-ending notices | Live captures at 780 px verified the complete Linked List, Stack, Queue, and BST views. BST nodes and connectors are centered, all three levels and status are visible, the selector label is no longer truncated, and action controls remain visible. |
| Prior v1.1 work | Release algorithm tests and packaged app launch | Passed in prior session | v1.1.0 package published; exact current UI is newer and unverified. |
| Prior v1.2 package attempt | Clean package startup | First failed, then passed after `qt.conf` correction | Do a final clean package verification after rebuilding. |

## Development History

| Date | Change | Why | Files / modules | Verification |
|---|---|---|---|---|
| 2026-11-20 | Started v1.2 UI/algorithm refinement: saved splitter and hideable assistant, reduced motion, incremental structure models, stable sorting/merge snapshots, animated structure/graph updates. | Improve learning feedback, correctness of traces, and workspace control. | `qml/`, `src/`, `tests/`, `CMakeLists.txt` | Release algorithm/model test 1/1 passed before latest sidebar styling edits. |
| 2026-11-20 | Reworked Material dark visual system, navigation buttons, collapsed sidebar tooltips, and key action priorities. | Respond to user's direct complaint that buttons/sidebar were poor. | `qml/Main.qml`, page QML, `src/main.cpp` | Latest Release build passed; visual verification is pending. |
| 2026-11-20 | Fixed sidebar brand overflow and expanded persistent Settings; styled dashboard primary CTA. | User screenshots showed overlapping brand text and asked whether Settings had only one option. | `qml/Main.qml`, `qml/pages/DashboardPage.qml`, `src/controllers/settingscontroller.h` | Release build and CTest passed. Later live screenshots verified the expanded brand and settings panel; preference behavior across restart is still open. |
| 2026-11-20 | Capped and centered playback timeline, removed floating input hint, repositioned Settings popup, and made structure controls wrap for narrow pages. | Fix additional layout problems visible in user screenshots and proactively address minimum-width overflow. | `qml/components/PlaybackControls.qml`, `qml/pages/SortingPage.qml`, `qml/Main.qml`, `qml/pages/StructurePage.qml` | Release build and CTest passed. Live app verified sidebar/input/timeline/settings; fixed a Flow runtime error and confirmed subsequent app startup. Minimum-width wrap still pending. |
| 2026-11-20 | Added settings persistence/reset tests and tightened StructurePage at narrow sizes. | Verify SettingsController behavior and keep structure controls visible on smaller displays. | `tests/algorithm_tests.cpp`, `CMakeLists.txt`, `qml/pages/StructurePage.qml` | Fresh Release build/CTest passed. Live captures verified Linked List, Stack, Queue, and Tree at 780 px. |
| 2026-11-20 | Fixed BST parent sizing, node alignment, narrow level spacing, and status/selector clipping. | Proactive check of Tree view found its drawing area had zero size and later exposed narrow-height overlap. | `qml/pages/StructurePage.qml` | Fresh Release build/CTest passed; final 780 px screenshot confirms every tree node, connector, selector label, status, and control is visible. |
| 2026-11-20 | Added this project status tracker and reconciled claims to repository and existing test log. | Keep current state and history auditable. | `PROJECT_STATUS.md` | File contents cross-checked against working tree and test log. |

## NEXT PRIORITIES

1. Review Sorting, Searching, Graph, and Compare at narrow widths for clipped controls; apply the same scrutiny to default-looking buttons.
2. Verify Settings persistence after restarting the packaged app and inspect navigation focus states.
3. Rebuild and launch a clean Windows package with the Qt import fix.
4. Commit and push the verified update; publish its GitHub release and asset.
