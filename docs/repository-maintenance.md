# Repository maintenance

## Branch protection

Protect the default branch in GitHub repository settings:

- Require pull requests and at least one approving review before merging.
- Require the Debug and Release matrix checks from `Qt 6 CI` to pass.
- Require the branch to be up to date before merging.
- Require conversations to be resolved and dismiss stale approvals after new commits.
- Restrict force pushes and branch deletion.

The repository uses a matrix job whose displayed check names include the build configuration. Select both Debug and Release checks as required statuses.

## Releases

Push a version tag such as `v1.2.0` to run the Windows release workflow. It builds and tests Release, lints QML, deploys Qt runtime libraries and QML modules, smoke-starts the executable offscreen, creates a ZIP, and publishes a SHA-256 checksum. A rerun for an existing release replaces the archive and checksum assets.

Update `project(Algorythm VERSION ...)` in `CMakeLists.txt` before tagging. Release automation currently packages Windows x64 only; other platforms need their own deployment and startup checks before they are advertised as release targets.
