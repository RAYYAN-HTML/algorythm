# Algorythm — Product and Technical Audit

**Audit date:** 2026-11-20  
**Scope:** Repository snapshot at `7c19a50` plus pre-existing local edits in `PROJECT_STATUS.md` and `qml/pages/SortingPage.qml`. Those local edits were preserved.  
**Method:** Source review of the app shell, pages, shared QML components, controllers, algorithm/structure code, CMake, tests, project status and Git history; whole-codebase Qt QML/C++ lint and review; fresh Release and profiling builds; CTest; live interaction/visual checks at 1440×900. UX findings are heuristic, not participant research.

## Executive summary

Algorythm already has a meaningful native Qt Quick foundation: algorithm snapshots are produced in C++, playback state is controller-owned, node models preserve identity, settings persist, and a focused purple dark theme is present. The recent status log records multiple verified fixes and prior interactive checks. The application is not a blank redesign target.

The main risks are consistency and verification depth. Visual tokens live in `Main.qml`, while page and component QML still contain many direct colors and sizes. `qmllint` reports unresolved project-import/context-property types and layout warnings; many are analysis noise, while layout-managed fixed dimensions and an inherited `Item.state` redeclaration were concrete maintainability concerns. The Dashboard label and `Item.state` issue were corrected in this pass. Several screen states and sizes remain unverified according to `PROJECT_STATUS.md`. The CTest suite passes, but there are no Qt Quick `tst_*.qml` tests. A short profiler trace was captured and parsed; it does not measure sustained playback.

## Current quality assessment

- **Product direction:** Clear opportunity to serve as an interactive algorithm laboratory. Existing traces already include narration, pseudocode, variables and operation counts.
- **Visual quality:** A consistent dark-violet direction and reusable components exist. The current screens retain a mixture of shared tokens and page-local literals; visual consistency is therefore incomplete.
- **Functional quality:** Core C++ traces and structure controllers are covered by the single `algorithm_generators` CTest target. Status documentation records several real UI checks but also lists outstanding interactive flows.
- **Accessibility:** Reduced motion, keyboard shortcuts, focus-related styles and accessible node descriptions exist in part. Full keyboard traversal, screen-reader labeling, large text and reduced-motion runtime behavior are not established by current evidence.
- **Performance:** Algorithm inputs are capped at 16 values, keeping traces bounded for the main sorting/search workspace. The short profiler sample showed near-60 FPS during the observed startup/transition window; it does not establish sustained playback performance.

## Findings

### High

| ID | Finding and evidence | Recommendation |
|---|---|---|
| H-01 | **Dashboard advertised a static illustration as live.** `qml/pages/DashboardPage.qml` used fixed `traceValues`, `traceX`, and `traceY` disconnected from playback. | **Fixed:** label now reads “SAMPLE TRACE · 7 VALUES”; it describes the illustrative display honestly. |
| H-02 | **Responsive and interaction coverage is incomplete.** `PROJECT_STATUS.md` explicitly leaves compact Compare, Graph playback, keyboard/accessibility interactions, prediction feedback, splitter persistence, and some settings behavior pending. | Complete a repeatable screen/flow matrix and record only observed outcomes. |
| H-03 | **QML diagnostics include layout-managed fixed geometry.** `qmllint` reports `Quick.layout-positioning` on `NavigationSidebar.qml`, `SettingsPopup.qml`, `ComparisonPage.qml`, and `SortingPage.qml` for explicit width/height inside layouts. | Replace layout-owned geometry with `Layout.preferredWidth/Height` or implicit sizing where the child should size naturally; verify the intended breakpoint behavior. |

### Medium

| ID | Finding and evidence | Recommendation |
|---|---|---|
| M-01 | **Theme vocabulary is only partly centralized.** `qml/Main.qml:37-55` defines semantic colors, but page/component files include direct hex values for surfaces, borders and states. | Gradually consolidate recurring semantic values; retain one-off illustration colors only where they are genuinely local. |
| M-02 | **QML type analysis is noisy and cannot reliably catch project-level type errors.** Whole-codebase `qmllint` ran, but reports missing `Algorythm`/page imports and injected `theme` members inferred as `QObject`, alongside 297 unqualified accesses. These diagnostics are not all confirmed runtime bugs. | Provide qmllint the generated module/import path and improve explicit property types/root qualification in touched components; rerun and triage residuals. |
| M-03 | **The QML-specific test workflow is absent.** Repository scan found no `tst_*.qml`; existing CTest is C++ `algorithm_generators` only. | Add focused Quick Tests for interactive state and validation only when there is an appropriate harness; keep current C++ regression tests. |
| M-04 | **The educational trace can allocate one full snapshot per operation.** `ExecutionStep` stores value/identity vectors and a variables map; Merge Sort and recursive Quick Sort construct traces in `qml/pages/SortingPage.qml`'s bounded 16-element input path. This is safe at current input limits but increases snapshot volume with more input or more detailed traces. | Keep the input cap, profile real use, and only optimize trace representation if measured memory or frame-time requires it. |

### Low

| ID | Finding and evidence | Recommendation |
|---|---|---|
| L-01 | **Dashboard “learning statistics” are catalog counts, not personal progress.** `DashboardPage.qml` shows 07 algorithms, 07 labs and 04 structure types. The labels mostly clarify this, but visually they resemble user metrics. | Keep the static counts clearly framed as catalog inventory; do not add untracked progress claims. |
| L-02 | **Small type and spacing values are widely hard-coded.** Several QML labels use 8–12 px text for metadata and helper copy. This may be acceptable for secondary desktop chrome, but it needs scaling/contrast verification at compact windows and larger OS text settings. | Prefer semantic type roles and verify readability at 800×600 and larger system text. |

## QML review

The QML linter examined all 21 source files. `qmllint` ran from `C:\msys64\ucrt64\bin\qmllint.EXE`. It emitted 567 finding instances across 59 rule/message pairs, including warnings about generic `var`, imperative assignments, layout dimensions, ordering/style, and type resolution. Many unqualified-access and missing-member reports reflect the project’s context-injected controllers and untyped theme objects; they should not be treated as confirmed failures without module-aware analysis.

Confirmed deep-review finding: the Dashboard’s “LIVE TRACE” is static (H-01). Additional QML concerns are prioritized through the source and layout review; no broad rewrite is warranted based on lint volume alone.

Two scoped QML maintainability fixes were applied: `AlgorithmNode` now names its visual state property `nodeState` instead of shadowing `QQuickItem.state`; Sorting and Comparison callers use the renamed property. The Dashboard sample label was corrected. Rebuild and runtime checks passed after these edits; the state-shadow warning disappeared from focused lint output.

## C++ review

The C++ linter examined 14 files and reported 24 instances in six rule/message groups: `QPair`/`qMin`/`qMax`/`qBound` modernization, unscoped enum underlying types, `numeric_limits` macro safety, an unbounded `GraphController::m_edges` collection, and `qSwap` modernization. Most are consistency/modernization items, not demonstrated functional defects. Graph edges are user-added through `GraphController::addEdge`; the current seven-node graph has no explicit edge-count cap, so repeated edge insertion can grow adjacency and regenerated snapshots. This is a bounded small desktop feature in ordinary use, but the API should either cap input or document intended usage if this becomes user-expandable.

No use of worker threads or concurrent model mutation was found in the reviewed architecture. `AlgorithmNodeModel` and structure models use reset/insert/remove notifications; ownership is parent/value based. The existing algorithm test suite passes, though it is not a substitute for exhaustive correctness proofs or UI tests.

## Performance review

**Measured:** Profiling configuration/build succeeded using Qt 6.11.2 and `-DQT_QML_DEBUG`; cleanly exited `qmlprofiler` trace parsed to `profiler/traces/qmlprofiler-trace-Algorythm-2026-11-20-140000.qtd` (3.59 MB). The parser reports a 4.23-second event range, 31 animation frames, estimated 59.5 average FPS (58–62 min/max), 17.24 ms p50/p95/p99 frame duration, zero frames above 25 ms, and 1.68 MB peak heap. Largest costs are initial object creation (`Creating`, 2.63 s aggregated) and QML compilation (1.15 s aggregated; `Main.qml` 710.81 ms across two compile events). The app’s shared `Main.qml` and Sorting page were loaded; a Dashboard “Start with sorting” activation appears in the trace. This is a short launch/transition sample, not sustained playback, and the parser reports only 31 frames. Treat these values as directional for this run, not a performance guarantee. No code optimization was warranted from this sample alone.  
**Source-based risk assessment:** Sorting/search input is capped at 16 values in `PlaybackController::sortInput`, which limits snapshot size and node count. The step model updates positions through `dataChanged`; graph execution materializes a step for each examined edge. `GraphController::addEdge` has no count limit. QML uses Canvas drawing for the Dashboard decorative trace and tree edges; Canvas repaint frequency and frame cost were not measured. No measured performance problem is claimed.

## Testing review

- **Automated:** `ctest --test-dir out/ci-release --output-on-failure` — passed `algorithm_generators`, 1/1, after edits (1.18 seconds total).
- **Build:** Release/Ninja build succeeded after edits. Separate RelWithDebInfo profiling build with QML debugging also succeeded.
- **Quick Test:** no `tst_*.qml` found; Qt Quick Test Runner cannot execute a QML suite as-is.
- **Runtime/visual:** at 1440×900, live interaction confirmed Dashboard sample label; Sorting Next advanced step 1→2; Graph Next advanced step 1→2 with nodes/edges aligned; Linear Search completed on target 6 with matching narration; Compare Run Both completed both identical Bubble Sort traces with 21 comparisons and 13 swaps each. Dashboard, Search, Sort, Graph, Compare were visually inspected. This is not a test of smaller sizes or every state.
- **Profiler:** `profiler/traces/qmlprofiler-trace-Algorythm-2026-11-20-140000.qtd` parsed successfully. It contains only a short launch/transition sample; measurements and the limitation are listed above.

## UX and visual findings by journey

1. **First open:** Dashboard has a clear “Start with sorting” action and a catalog of learning modules. The decorative trace is misleadingly labeled live. There is no evidenced first-run onboarding or personal progress tracking; avoid fabricating either.
2. **Understand Bubble Sort:** Sorting page has algorithm selection, input, node visualization, playback and an assistant panel. At compact widths the assistant can be hidden/stacks vertically; users need persistent step status and reachable playback controls. Historical evidence covers some, not all, sizes.
3. **Compare sorts:** Two controllers/panels and shared “Run Both” behavior exist. Compare layout is a high-value workflow; compact-width synchronization and malformed input remain explicit verification items.
4. **Understand graph traversal:** Graph page draws nodes/edges and has traversal playback. The status history records a node-position defect and a code fix, but post-fix visual confirmation and the complete graph interaction remain pending.
5. **Experiment with structures:** Linked list, stack, queue and BST views expose direct operations and status feedback; the depth limit for BST and empty-state paths should remain visible and accessible.
6. **Understand complexity:** Reusable complexity panels exist. Ensure complexity values are paired with explanations and do not let small metadata type become the only explanation.
7. **Replay a step:** Sorting and graph controllers expose step/index/timer controls; visual snapshots are controller-owned. Sorting and Graph Next were exercised at 1440×900. Keyboard playback exists in Sorting; focus conflict was addressed in the pre-existing local edit, but runtime key injection was not verified.

These are heuristic evaluations from source and the existing status log, not observed participant findings. No participant sessions or analytics were supplied.

## Initial priorities

1. Run a more complete runtime matrix across supported sizes and remaining workflows, especially compact Compare, graph modes, structure operations, keyboard/reduced-motion behavior, and prediction feedback.
2. Improve shared semantic token usage and component consistency gradually, preserving the current visual system.
3. If performance conclusions matter, capture longer traces with sorting, Compare, and Graph playback; the current 31-frame sample only covers startup/transition.
4. Consider focused Qt Quick tests after introducing a proper QML test harness; none exist today.

