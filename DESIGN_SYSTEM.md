# Algorythm — Design System

**Status:** Existing visual language documented; token cleanup is incremental.  
**Platform assumptions:** Resizable Qt 6 desktop app, rectangle display, desk viewing distance (~60 cm), English-first, mouse and keyboard. DPI and RTL requirements are not documented. Retain Qt Quick Controls Material Dark and the project’s deep-violet identity.

## Product design intent

Algorythm is an **interactive algorithm laboratory**. The visualization is primary; controls and narration should explain its state; pseudocode, variables, counts and complexity provide supporting evidence. Structure labs use the same visual vocabulary while preserving the distinct mental model of each data structure.

## Foundations

### Color

The shared runtime palette is currently declared as `appColors` in `qml/Main.qml` and passed through each page/component’s `theme` property.

| Token | Current value | Role |
|---|---|---|
| `background` | `#080812` | App canvas |
| `secondary` | `#0D0D1A` | Recessed surface |
| `panel` | `#17172A` | Main panel |
| `elevated` | `#1A1930` | Raised surface |
| `border` | `#29243E` | Dividers and outlines |
| `purple` | `#8B5CF6` | Primary interactive accent / current node |
| `brightPurple` | `#A855F7` | Secondary accent |
| `deepPurple` | `#6D28D9` | Dark accent / pressed surface |
| `glowPurple` | `#9333EA` | Limited decorative highlight |
| `text` | `#F8FAFC` | Primary text |
| `muted` | `#A1A1B5` | Secondary text |
| `subdued` | `#71718A` | Tertiary metadata |
| `amber` | `#FBBF24` | Comparison/search-target distinction |
| `green` | `#34D399` | Completed/visited state |
| `error` | `#F87171` | Error state; pair with text |
| `info` | `#38BDF8` | Informational state |

Colors in page-local Canvas illustrations may stay local where semantic state is not represented. Repeated panel, border, text, and state colors should use the shared palette. Do not communicate a state by color alone.

### Typography

The app currently relies on the Qt/OS font and mostly pixel sizes. Use a compact desktop scale and keep no more than four active roles per screen:

| Role | Target size | Use |
|---|---:|---|
| Display | 32–34 px | Dashboard hero or primary lab title |
| Heading | 19–25 px | Page and panel titles |
| Body | 14–16 px | Instructions, narration, control labels |
| Metadata | 10–12 px | Counts, category labels, secondary hints only |

Prefer point sizing or a future type-scale singleton where system font scaling needs to be respected. Verify at larger OS text scaling; do not shrink primary explanations to metadata size.

### Spacing and shape

The current UI uses approximately 8 px increments, panel radii around 14–20 px, and compact control radii around 8–10 px. Standardize on an 8 px base rhythm (4 px for tight internal alignment), 12–16 px card padding, and 8–14 px control/card radii. Keep canvas nodes circular. These values describe the current direction and are not yet centralized tokens.

### Motion and interaction

- Motion should explain a state transition or node movement. Keep typical UI transitions under 300 ms and avoid animating layout geometry where it causes reflow.
- Honor the persisted reduced-motion setting by making transitions immediate.
- Preserve visible keyboard focus; maintain left-to-right visual tab order and Escape exits for popups.
- Reversible actions should be direct and provide status feedback. Invalid input should preserve the last valid state and explain how to recover.
- Keep labels on primary controls; collapsed navigation may use a tooltip as a supplemental cue, not the only accessible name.

## Component language

| Component | Existing implementation | Specification |
|---|---|---|
| App shell / navigation | `qml/Main.qml`, `qml/components/NavigationSidebar.qml` | Persistent active-section indicator, expanded/collapsed states, labeled expanded rows, keyboard focus, aligned tooltips, settings access. Preserve all destinations. |
| Dashboard lab card | `qml/components/LabCard.qml` | One icon, category/title, concise task-focused description, consistent hover/focus treatment; full card is an intentional navigation target. |
| Algorithm node | `qml/components/AlgorithmNode.qml` | Fixed circular node; visible value; distinct active, compared, completed, search-target and default appearances; accessible description must state relevant status. |
| Playback controls | `qml/components/PlaybackControls.qml` | Restart, previous, play/pause, next, timeline and speed grouped by task; retain reachable targets, current-step feedback and keyboard operation. |
| Input bar | `qml/components/AlgorithmInputBar.qml` | Explicit label, recoverable validation message, current input retained when invalid, action label describes the run. |
| Narration / pseudocode / variables | `NarrationPanel.qml`, `PseudocodePanel.qml`, `VariablesPanel.qml` | Reuse panel heading and surface styles. Active step aligns with the trace; body text is readable and not truncated. |
| Complexity / statistics | `ComplexityPanel.qml`, `StatisticsPanel.qml`, `StatCard.qml` | Separate theory from run-specific counts; define each metric; never imply a universal winner. |
| Settings | `SettingsPopup.qml` and sidebar settings UI | Group playback speed, reduced motion, sidebar preference and reset with visible state and persistence feedback. |
| Graph and structure nodes | `GraphPage.qml`, `StructurePage.qml` | Reuse semantic state colors and node dimensions, preserve edge and topology readability, provide textual status in addition to color. |

## Screen composition rules

- **Dashboard:** primary start action and catalog access first; catalog counts are inventory, not user progress. Keep decorative traces explicitly labeled as samples.
- **Sorting/search workspace:** node trace owns the largest useful area; algorithm/input controls precede it; playback is adjacent; explanation panels support without obscuring it.
- **Comparison:** equal panels with matching input and shared controls; stack panels when width cannot support both legibly; make all measurements comparable and defined.
- **Graph/structures:** keep topology central and operation controls/status visibly connected to it.
- **Responsive:** retain the declared 780×560 minimum; at narrower layouts, stack secondary panels and wrap controls before clipping. Verify at 800×600, 1024×768, 1280×800 and 1440×900.

## Figma status

No Figma connector, design-token JSON, or generated token singletons were found in the available project/tool context. Therefore no Figma component extraction is claimed. Existing QML components are the source of truth for this implementation; avoid duplicate controls and treat this document as the handoff specification.

