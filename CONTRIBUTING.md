# Contributing to Algorythm

Thanks for helping improve Algorythm. Keep changes focused and preserve the separation between C++ trace generation/controllers and QML presentation.

## Build and test

Use Qt 6.2 or newer, CMake 3.21+, and a C++17 compiler. Configure with testing enabled:

```sh
cmake -S . -B build -DCMAKE_PREFIX_PATH=/path/to/Qt/6.x/<kit> -DBUILD_TESTING=ON
cmake --build build
ctest --test-dir build --output-on-failure --no-tests=error
```

Before submitting, build and run CTest in Debug and Release. Run `qmllint -I build` across the changed QML files and tests. For algorithm changes, test empty, single-value, duplicate, sorted, reverse-sorted, negative, and application-limit inputs where applicable.

## Change guidelines

- Read the existing controller, trace, component, and test before changing behavior.
- Keep algorithm decisions in the C++ trace and keep visualization-only behavior in QML.
- Reuse existing theme roles and controls; provide accessible names for icon-only controls.
- Respect reduced-motion settings and avoid communicating state through color alone.
- Add Qt Test or Qt Quick Test coverage for new behavior, including invalid and boundary states.
- Update the README or architecture documentation when public behavior or build steps change.
- Do not include generated build output, personal settings, or unrelated formatting changes.

## Pull requests

Describe the user-visible change, the implementation boundary, and the exact commands used to verify it. Call out any viewport, screen-reader, or platform behavior that could not be checked locally.
