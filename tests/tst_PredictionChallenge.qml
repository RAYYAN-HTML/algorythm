pragma ComponentBehavior: Bound

import QtQuick
import QtTest
import "../qml/components"

Item {
    id: root
    width: 800
    height: 600

    AppTheme {
        id: appTheme
    }

    QtObject {
        id: fakeController
        property var values: [8, 3]
        property int searchTarget: 3
        property int activeA: 0
        property int activeB: 1
        property bool playing: false
        property int nextCalls: 0
        property int startCalls: 0
        function pausePlayback() { playing = false }
        function next() { ++nextCalls }
        function startPlayback() { ++startCalls; playing = true }
    }

    Component {
        id: challengeComponent

        PredictionChallenge {
            theme: appTheme
            controller: fakeController
        }
    }

    TestCase {
        name: "PredictionChallengeTests"
        when: windowShown

        function test_predictionPausesAndResumesAutoplayAfterFeedback() {
            fakeController.values = [8, 3]
            fakeController.activeA = 0
            fakeController.activeB = 1
            fakeController.playing = true
            fakeController.nextCalls = 0
            fakeController.startCalls = 0
            const challenge = createTemporaryObject(challengeComponent, root)
            verify(!!challenge, "Component exists")

            challenge.openPrediction()
            compare(fakeController.playing, false)
            challenge.answer(true)
            compare(challenge.score, 1)
            challenge.continueAfterFeedback()

            compare(fakeController.nextCalls, 1)
            compare(fakeController.startCalls, 1)
            compare(fakeController.playing, true)
        }

        function test_predictionKeepsManuallyPausedTracePaused() {
            fakeController.values = [8, 3]
            fakeController.activeA = 0
            fakeController.activeB = 1
            fakeController.playing = false
            fakeController.nextCalls = 0
            fakeController.startCalls = 0
            const challenge = createTemporaryObject(challengeComponent, root)
            verify(!!challenge, "Component exists")

            challenge.openPrediction()
            challenge.answer(false)
            challenge.continueAfterFeedback()

            compare(fakeController.nextCalls, 1)
            compare(fakeController.startCalls, 0)
            compare(fakeController.playing, false)
        }

        function test_linearSearchPredictsWhetherInspectedValueMatches() {
            fakeController.values = [8, 3]
            fakeController.activeA = 1
            fakeController.activeB = 0
            fakeController.searchTarget = 3
            const challenge = createTemporaryObject(challengeComponent, root)
            verify(!!challenge, "Component exists")

            challenge.openPrediction("target")
            challenge.answer(true)

            compare(challenge.score, 1)
            compare(challenge.feedback, "Correct. This value matches the target, so Linear Search stops here.")
        }

        function test_binarySearchPredictsRangeOrMidpointMatch() {
            fakeController.values = [3, 8]
            fakeController.activeA = 1
            fakeController.activeB = 0
            fakeController.searchTarget = 3
            const challenge = createTemporaryObject(challengeComponent, root)
            verify(!!challenge, "Component exists")

            challenge.openPrediction("direction")
            challenge.answer(false)

            compare(challenge.score, 1)
            compare(challenge.feedback, "Correct. The target is smaller than the midpoint, so Binary Search discards the upper half.")
        }

        function test_binarySearchPredictionExplainsExactMidpointMatch() {
            fakeController.values = [3, 8]
            fakeController.activeA = 0
            fakeController.activeB = 1
            fakeController.searchTarget = 3
            const challenge = createTemporaryObject(challengeComponent, root)
            verify(!!challenge, "Component exists")

            challenge.openPrediction("direction")
            challenge.answer(false)

            compare(challenge.score, 1)
            compare(challenge.feedback, "Correct. The target equals the midpoint, so Binary Search has found it.")
        }

        function test_selectionSortPredictsNewMinimum() {
            fakeController.values = [4, 2]
            fakeController.activeA = 0
            fakeController.activeB = 1
            const challenge = createTemporaryObject(challengeComponent, root)
            verify(!!challenge, "Component exists")

            challenge.openPrediction("minimum")
            challenge.answer(true)

            compare(challenge.score, 1)
            compare(challenge.feedback, "Correct. The candidate is smaller than the current minimum, so Selection Sort records it as the new minimum.")
        }

        function test_insertionSortPredictsMovingKeyLeft() {
            fakeController.values = [5, 3]
            fakeController.activeA = 0
            fakeController.activeB = 1
            const challenge = createTemporaryObject(challengeComponent, root)
            verify(!!challenge, "Component exists")

            challenge.openPrediction("moveLeft")
            challenge.answer(true)

            compare(challenge.score, 1)
            compare(challenge.feedback, "Correct. The preceding value is greater than the key, so Insertion Sort moves the key left.")
        }

        function test_quickSortPredictsPartitionSide() {
            fakeController.values = [2, 4]
            fakeController.activeA = 0
            fakeController.activeB = 1
            const challenge = createTemporaryObject(challengeComponent, root)
            verify(!!challenge, "Component exists")

            challenge.openPrediction("partition")
            challenge.answer(true)

            compare(challenge.score, 1)
            compare(challenge.feedback, "Correct. The value is no greater than the pivot, so Quick Sort keeps it in the left partition.")
        }

        function test_mergeSortPredictsNextHalfValue() {
            fakeController.values = [2, 3]
            fakeController.activeA = 0
            fakeController.activeB = 1
            const challenge = createTemporaryObject(challengeComponent, root)
            verify(!!challenge, "Component exists")

            challenge.openPrediction("merge")
            challenge.answer(true)

            compare(challenge.score, 1)
            compare(challenge.feedback, "Correct. The left value is smaller or equal, so Merge Sort writes it next to preserve ascending order.")
        }
    }
}
