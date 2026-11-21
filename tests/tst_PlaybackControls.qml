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
        id: fakeController
        property int stepIndex: 2
        property int stepCount: 8
        property bool playing: false
        property real speed: 1.0
        property int restartCalls: 0
        property int previousCalls: 0
        property int nextCalls: 0
        property int playPauseCalls: 0
        property real lastSeek: -1
        function restart() { ++restartCalls; stepIndex = 0 }
        function previous() { ++previousCalls; stepIndex = Math.max(0, stepIndex - 1) }
        function next() { ++nextCalls; stepIndex = Math.min(stepCount - 1, stepIndex + 1) }
        function playPause() { ++playPauseCalls; playing = !playing }
        function seek(index) { lastSeek = index; stepIndex = index }
    }
    QtObject {
        id: fakeSettings
        property real playbackSpeed: 1.0
    }

    Component {
        id: controlsComponent
        PlaybackControls {
            width: root.width
            theme: appTheme
            controller: fakeController
            settingsController: fakeSettings
        }
    }

    TestCase {
        name: "PlaybackControlsTests"
        when: windowShown

        function init() {
            fakeController.stepIndex = 2
            fakeController.playing = false
            fakeController.speed = 1.0
            fakeController.restartCalls = 0
            fakeController.previousCalls = 0
            fakeController.nextCalls = 0
            fakeController.playPauseCalls = 0
            fakeController.lastSeek = -1
            fakeSettings.playbackSpeed = 1.0
        }

        function test_playPauseAndStepButtonsCallController() {
            const controls = createTemporaryObject(controlsComponent, root)
            verify(!!controls, "Playback controls are created")

            const playPause = findChild(controls, "playPausePlaybackButton")
            const previous = findChild(controls, "previousPlaybackButton")
            const next = findChild(controls, "nextPlaybackButton")
            verify(!!playPause, "Play/pause button exists")
            verify(!!previous, "Previous button exists")
            verify(!!next, "Next button exists")

            mouseClick(playPause)
            compare(fakeController.playing, true)
            mouseClick(next)
            compare(fakeController.stepIndex, 3)
            mouseClick(previous)
            compare(fakeController.stepIndex, 2)
            compare(fakeController.playPauseCalls, 1)
            compare(fakeController.nextCalls, 1)
            compare(fakeController.previousCalls, 1)
        }

        function test_restartAndSeekUpdateTracePosition() {
            const controls = createTemporaryObject(controlsComponent, root)
            verify(!!controls, "Playback controls are created")
            const restart = findChild(controls, "restartPlaybackButton")
            verify(!!restart, "Restart button exists")

            mouseClick(restart)
            compare(fakeController.stepIndex, 0)
            compare(fakeController.restartCalls, 1)

            const stepSlider = findChild(controls, "visualizationStepSlider")
            verify(!!stepSlider, "Step slider is present")
            stepSlider.value = 7
            tryCompare(fakeController, "lastSeek", 7)
            compare(fakeController.stepIndex, 7)
        }

        function test_speedSliderUpdatesControllerAndSavedPreference() {
            const controls = createTemporaryObject(controlsComponent, root)
            verify(!!controls, "Playback controls are created")
            const slider = findChild(controls, "playbackSpeedSlider")
            verify(!!slider, "Speed slider exists")

            slider.value = 2.5

            tryCompare(fakeController, "speed", 2.5)
            tryCompare(fakeSettings, "playbackSpeed", 2.5)
        }
    }
}
