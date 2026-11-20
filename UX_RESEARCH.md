# Algorythm — UX Research and Evaluation

**Date:** 2026-11-20  
**Research type:** Heuristic evaluative review, live task walkthrough and proposed usability study  
**Evidence boundary:** No participant recordings, analytics, survey results, or live session notes were supplied. Findings below are code-based journey evaluations and should not be read as empirical user research.

## Research goal

Identify where students lose the thread of an algorithm while starting a lab, setting inputs, stepping through execution, comparing approaches, or inspecting structures, then validate the highest-risk friction with short observed sessions.

## Research questions

1. Can a first-time student identify a useful starting lab and begin a trace without coaching?
2. Can students predict what the next step will change, and connect node state to narration and pseudocode?
3. Can students enter or correct data and recover from invalid input without losing their current learning context?
4. Can students operate playback, compare two algorithms, and inspect graph/structure state using mouse and keyboard?
5. Do students interpret operation counts and complexity as educational evidence rather than a universal winner score?

## Method and limits

The findings combine a source-based heuristic walkthrough with one live evaluator walkthrough at 1440×900. Dashboard, Sorting, Searching, Graph, and Compare were opened; playback was stepped in Sorting and Graph, Search reached a found state, and Compare Run Both completed both traces. This method can surface labeling, feedback, hierarchy, and likely interaction risks. It cannot establish completion rates, discoverability in real use, perceived comprehension, or issue frequency. No user quotes or frequency estimates are claimed.

## Product direction and outcomes

**Positioning:** Algorythm is an interactive algorithm laboratory. Its central learning job is: “When I study a data-structure or algorithm concept, help me inspect each state change and understand why it happened, so I can connect the pseudocode to the visible result.”

**Experience outcomes to validate:**

- A first-time learner can start a relevant lab from the Dashboard without inventing progress or performance claims.
- A learner can predict the next comparison/visit, use playback to check that prediction, and explain the result using the narration or pseudocode.
- A learner can compare algorithms on the same input and distinguish measured operation counts from theoretical complexity.
- A learner can change structure/graph inputs, receive specific feedback, and recover without losing the current workspace.

**Information architecture:** Keep Dashboard as a launch/catalog surface; Sorting and Searching as the shared trace workspace; Linked List, Stack, Queue and Tree under the structure workspace; Graph as a topology lab; Compare as a cross-cutting paired experiment; Settings as persistent playback/layout preferences. The sidebar keeps these destinations visible and the current section explicit.

**Design principles:** Show the state before the explanation; keep the visualization dominant; make playback reversible and nearby; connect narration/pseudocode to the current trace; use shared semantic tokens; show operation counts with definitions; pair color-coded states with labels/text; preserve context on invalid input; do not fabricate learning progress or a universal algorithm winner.

**Proposed success measures (not currently instrumented):** task completion for “start and step through a lab”; time to first successful step; ability to correctly describe the active state after a step; recovery rate after invalid input; and whether participants can accurately explain the basis for a comparison. Collect these through moderated sessions before adding analytics or making outcome claims.

## User journeys: heuristic findings

| Journey | Current support | Friction / risk | Suggested validation |
|---|---|---|---|
| Open the app for the first time | Dashboard presents a primary “Start with sorting” action and seven named lab cards. The node illustration is now labeled “SAMPLE TRACE.” | There is no verified first-run orientation or actual learning-progress data. | Ask a participant to choose a lab and explain what they expect from the illustration before clicking. |
| Understand Bubble Sort | Sorting page provides algorithm selection, editable input, node trace, playback, narration, pseudocode and statistics. | The relationship between the active node pair, current pseudocode line and narration must stay visually clear. Assistant density can compete with the node trace at smaller sizes. | Ask participant to predict the next comparison, then use Next and explain what changed. Observe pauses and backtracking. |
| Compare two sorting algorithms | Live 1440×900 Run Both completed two Bubble Sort traces on identical input; both reported 21 comparisons and 13 swaps. | Dense content and two traces increase scanning load; compact widths and synchronized stop/restart/seek behavior need verification. Counts need clear definitions before comparing. | Ask participant to compare the same input and state which evidence supports their conclusion; do not prompt for a winner. |
| Understand graph traversal | At 1440×900, node/edge layout was aligned and Next advanced the trace from step 1 to step 2. | Only the default traversal was exercised; active edge, visited set, distance updates, alternate algorithms and weighted-edge feedback need verification. | Ask participant to identify the active node/edge and explain why a distance changes after one step. |
| Experiment with a data structure | Linked list, stack, queue and BST operations are exposed with statuses. | Operation terminology and positional semantics differ by structure; a concise status should confirm the exact result and recover from underflow, duplicates and invalid positions. | Ask participant to insert/delete or push/pop a value, then narrate what “front,” “top,” and zero-based position mean. |
| Understand time/space complexity | Reusable complexity panels display complexity metadata. | Big-O labels alone may be opaque; counts from one small trace are not a universal performance ranking. | Ask participant to explain which displayed information is theoretical and which is run-specific. |
| Replay or inspect a step | Controllers expose previous/next/restart/play and seek/index state; sorting has keyboard shortcuts. | Focus ownership and shortcut conflicts matter; runtime keyboard and reduced-motion behavior have not been fully verified. | Complete a short replay using keyboard only, including focus in ComboBox/input and return to pointer use. |

## Heuristic severity

Severity is provisional because there are no observed participants.

- **Resolved:** Misleading “LIVE TRACE” label on the static Dashboard illustration was changed to “SAMPLE TRACE.”
- **High validation priority:** Compare and Graph interactions have incomplete current-build coverage; these are core learning paths and must be exercised before claims of completion.
- **Moderate:** Operation counts and complexity need visible context so students do not treat sample counts as a cross-input benchmark.
- **Moderate:** Small-window density and keyboard focus require direct task checks; source and old captures cannot establish current accessibility.
- **Low opportunity:** Offer optional, clearly factual prompts that help students explain the next step; avoid adding artificial streaks, scores, or progress claims.

## Proposed usability test

**Participants:** 3–5 students currently taking or recently completing an introductory Data Structures and Algorithms course. Include a mix of familiarity with sorting and graph traversal; do not recruit only the project team.

**Session:** 30–40 minutes, one facilitator and one note-taker, desktop build at 1280×800 with an additional short 800×600 layout check. Think-aloud is optional; do not teach the controls during task attempts.

**Tasks:**

1. “You want to see how Bubble Sort changes this sequence. Start a run, advance a few steps, and return to the beginning.”
2. “The values are not what you meant. Change the input, then try an invalid value and recover.”
3. “Compare two sorting approaches on the same sequence. Explain what the counts tell you and what they do not tell you.”
4. “Run a graph traversal from a different start node. Explain why one node becomes visited next.”
5. “Use the available keyboard controls to pause, step back, and continue. Then open a structure lab and perform one operation.”

**Measures:** task completion without help; time-on-task as a directional measure; critical errors and recovery; wrong expectations; requests for clarification; keyboard-only completion; post-task Single Ease Question (SEQ, 1–7). Record exact user language and observed behavior. Do not generalize frequency from this small formative round.

**Decision rule:** fix any task-blocking failure immediately; prioritize repeated severe confusion across multiple participants; treat single low-severity preference comments as opportunities, not requirements. Re-test changed flows with a fresh small round.

## Next research step

Run this formative task set after the current build has been visually checked at target sizes. Use the outcomes to refine the relationship between execution state, explanation, and complexity rather than expanding the feature list.

