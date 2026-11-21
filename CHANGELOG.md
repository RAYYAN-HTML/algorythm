# Changelog

Notable user-facing changes are recorded here. Release archives are published by the GitHub Actions workflow when a matching version tag is pushed.

## [1.3.1] - 2026-11-21

### Improved

- Sorting playback updates variable rows through a C++ list model, preserving delegate instances when the variable set is stable.
- Added C++ model contract and QML delegate lifecycle coverage for variable updates and algorithm changes.
- Documented a sustained sorting playback profile and expanded the QML test report.

## [1.3.0] - 2026-11-21

### Added

- Editable graph sizes from 2 to 12 nodes, weighted edge editing, BFS/DFS discovery predictions, and validated graph configuration history.
- Dashboard history for resuming sorting, searching, and graph labs with their saved configurations.
- BST value deletion with incremental tree-model updates.
- Reusable comparison playback controls and expanded prediction prompts for sorting and searching.
- Expanded Debug and Release algorithm/controller and Qt Quick component test coverage.
- Windows release automation that tests and smoke-starts the packaged app, then publishes an archive and SHA-256 checksum.

### Improved

- Keyboard focus, accessible names and announcements, reduced-motion behavior, visualization contrast, comparison complexity summaries, and responsive graph details.
- CI QML lint coverage, contribution guidance, repository templates, and architecture documentation.
