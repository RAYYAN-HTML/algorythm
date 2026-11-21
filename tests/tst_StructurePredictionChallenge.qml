pragma ComponentBehavior: Bound

import QtQuick
import QtTest
import "../qml/components"

Item {
    id: root
    width: 700
    height: 600

    AppTheme { id: appTheme }

    QtObject {
        id: fakeController
        property string kind: "Stack"
        property var values: [5, 2, 8]
        property var traversal: []
        property int removeCalls: 0
        property int traverseCalls: 0
        property int previousCalls: 0
        function remove() { ++removeCalls; values = values.slice(1) }
        function traverse(order) {
            ++traverseCalls
            traversal = order === "Preorder" ? [8, 4, 2, 6, 12] : [2, 4, 6, 8, 12]
        }
        function previousTraversalStep() { ++previousCalls }
    }

    Component {
        id: challengeComponent
        StructurePredictionChallenge {
            theme: appTheme
            controller: fakeController
            traversalOrder: "Preorder"
        }
    }

    TestCase {
        name: "StructurePredictionChallengeTests"
        when: windowShown

        function init() {
            fakeController.kind = "Stack"
            fakeController.values = [5, 2, 8]
            fakeController.traversal = []
            fakeController.removeCalls = 0
            fakeController.traverseCalls = 0
            fakeController.previousCalls = 0
        }

        function test_stackChallengeRevealsAndAppliesPop() {
            const challenge = createTemporaryObject(challengeComponent, root)
            verify(!!challenge, "Challenge component is created")

            verify(challenge.prepareChallenge(), "A nonempty stack can be challenged")
            compare(challenge.expectedAnswer, "5")
            verify(challenge.choices.indexOf("5") >= 0, "The top value is offered as an answer")
            challenge.answer("5")
            compare(challenge.score, 1)
            verify(challenge.feedback.indexOf("LIFO") >= 0)
            challenge.continueChallenge()
            compare(fakeController.removeCalls, 1)
            compare(fakeController.values[0], 2)
        }

        function test_queueChallengeExplainsIncorrectChoiceAndAppliesDequeue() {
            fakeController.kind = "Queue"
            const challenge = createTemporaryObject(challengeComponent, root)
            verify(!!challenge, "Challenge component is created")

            verify(challenge.prepareChallenge(), "A nonempty queue can be challenged")
            challenge.answer("2")
            compare(challenge.score, 0)
            verify(challenge.feedback.indexOf("expected answer is 5") >= 0)
            challenge.continueChallenge()
            compare(fakeController.removeCalls, 1)
            compare(fakeController.values[0], 2)
        }

        function test_bstChallengePreviewsChoicesThenRunsTraversal() {
            fakeController.kind = "Binary Search Tree"
            const challenge = createTemporaryObject(challengeComponent, root)
            verify(!!challenge, "Challenge component is created")

            verify(challenge.prepareChallenge(), "A multi-node tree can be challenged")
            compare(challenge.expectedAnswer, "8 → 4 → 2 → 6 → 12")
            compare(fakeController.previousCalls, 1)
            challenge.answer(challenge.expectedAnswer)
            compare(challenge.score, 1)
            challenge.continueChallenge()
            compare(fakeController.traverseCalls, 2)
            compare(fakeController.removeCalls, 0)
        }
    }
}
