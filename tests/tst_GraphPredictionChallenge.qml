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
        property var discovered: [0, 1]
        property int active: 1
        property int edgeTo: 2
        property bool playing: false
        property int nextCalls: 0
        property int playPauseCalls: 0
        function next() { ++nextCalls }
        function playPause() { ++playPauseCalls; playing = !playing }
    }

    Component {
        id: challengeComponent
        GraphPredictionChallenge {
            theme: appTheme
            controller: fakeController
        }
    }

    TestCase {
        name: "GraphPredictionChallengeTests"
        when: windowShown

        function init() {
            fakeController.discovered = [0, 1]
            fakeController.playing = false
            fakeController.nextCalls = 0
            fakeController.playPauseCalls = 0
        }

        function test_newNeighborPredictionPausesAndResumesPlayback() {
            fakeController.playing = true
            const challenge = createTemporaryObject(challengeComponent, root)
            verify(!!challenge, "Graph prediction component exists")

            challenge.openPrediction()
            compare(fakeController.playing, false)
            challenge.answer(false)
            compare(challenge.score, 1)
            challenge.continueAfterFeedback()

            compare(fakeController.nextCalls, 1)
            compare(fakeController.playPauseCalls, 2)
            compare(fakeController.playing, true)
        }

        function test_discoveredNeighborPredictionExplainsDuplicateSuppression() {
            fakeController.discovered = [0, 1, 2]
            const challenge = createTemporaryObject(challengeComponent, root)
            verify(!!challenge, "Graph prediction component exists")

            challenge.openPrediction()
            challenge.answer(true)

            compare(challenge.score, 1)
            compare(challenge.feedback, "Correct. The neighbor has already been discovered, so this edge does not add it to the frontier again.")
        }

        function test_manuallyPausedPlaybackStaysPaused() {
            const challenge = createTemporaryObject(challengeComponent, root)
            verify(!!challenge, "Graph prediction component exists")

            challenge.openPrediction()
            challenge.answer(false)
            challenge.continueAfterFeedback()

            compare(fakeController.nextCalls, 1)
            compare(fakeController.playPauseCalls, 0)
            compare(fakeController.playing, false)
        }
    }
}
