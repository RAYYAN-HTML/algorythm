# Sustained sorting playback profile

**Profile date:** 2026-11-21  
**Application:** Algorythm, Qt 6.11.2 MinGW x64, RelWithDebInfo with QML debugging  
**Trace:** `profiler/traces/qmlprofiler-trace-Algorythm-sustained-sort-attached-2026-11-21-183500.qtd`

## Workload

The Sorting page ran Bubble Sort on 16 reverse-ordered values (`16` through `1`) at playback speed 3. The trace advanced through 242 steps and reached the final step. Reduced motion was disabled. The trace was captured from the visible application window and closed after playback.

## Measurements

- Trace duration: 15.56 seconds.
- Animation frames: 2,306; estimated average: 59.5 FPS.
- Frame-time percentiles: p50 17.24 ms, p95 17.24 ms, p99 17.24 ms; no sampled frames exceeded 25, 33, or 50 ms.
- Peak live heap: approximately 2.46 MB; 15.0 MB allocated across 156,005 small allocations during the trace.
- Pixmap cache: one request, one successful load, zero failures, and zero unaccounted entries.
- Profiler parser reported no QML errors.

## Hotspots

The largest repeated QML binding hotspot was the variable panel's model binding (249 calls, about 1,466 ms accumulated). The trace also showed repeated creation of row and label objects while the playback state changed. These events motivated moving variable rows into a C++ `QAbstractListModel`, which updates row data without rebuilding delegates when the variable names remain stable.

## Scope and limits

This trace was captured before the current C++ variable-model implementation. It characterizes a sustained playback workload and the binding/object-creation path that was subsequently changed; it does not measure the final model implementation. The frame-time values are profiler estimates for this single workload and machine, not a cross-device guarantee. Full graph and comparison workloads were not included.

> AI assistance has been used to create this output.
