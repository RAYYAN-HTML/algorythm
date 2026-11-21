pragma ComponentBehavior: Bound

import QtQuick
import QtTest
import "../qml/components"

Item {
    id: root
    width: 800
    height: 600

    AppTheme { id: appTheme }

    QtObject {
        id: controllerA
        property real speed: 1.0
        property bool playing: false
        property bool complete: false
        function restart() { complete = false }
        function previous() {}
        function next() {}
    }
    QtObject {
        id: controllerB
        property real speed: 1.0
        property bool playing: false
        property bool complete: false
        function restart() { complete = false }
        function previous() {}
        function next() {}
    }
    QtObject {
        id: settingsController
        property real playbackSpeed: 1.0
    }

    Component {
        id: controlsComponent
        ComparisonPlaybackControls {
            theme: appTheme
            controllerA: root.rootControllerA
            controllerB: root.rootControllerB
            settingsController: root.rootSettings
        }
    }

    // Root aliases let the component keep required-object bindings explicit.
    property QtObject rootControllerA: controllerA
    property QtObject rootControllerB: controllerB
    property QtObject rootSettings: settingsController

    TestCase {
        name: "ComparisonPlaybackControlsTests"
        when: windowShown

        function init() {
            controllerA.speed = 1.0
            controllerB.speed = 1.0
            settingsController.playbackSpeed = 1.0
        }

        function test_speedChangesSynchronizeBothTracesAndSettings() {
            const controls = createTemporaryObject(controlsComponent, root)
            verify(!!controls, "Comparison controls are created")
            const slider = findChild(controls, "comparisonSpeedSlider")
            verify(!!slider, "Shared speed slider exists")

            slider.value = 2.5

            tryCompare(controllerA, "speed", 2.5)
            tryCompare(controllerB, "speed", 2.5)
            tryCompare(settingsController, "playbackSpeed", 2.5)
        }
    }
}
