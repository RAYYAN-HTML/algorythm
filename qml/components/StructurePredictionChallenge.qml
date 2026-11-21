pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    property AppTheme theme
    property var controller
    property string traversalOrder: "Inorder"
    property int score: 0
    property string expectedAnswer: ""
    property var choices: []
    property string feedback: ""
    property bool answered: false

    function prepareChallenge() {
        answered = false
        feedback = ""
        if (controller.kind === "Binary Search Tree") {
            controller.traverse(traversalOrder)
            controller.previousTraversalStep()
            var sequence = controller.traversal
            expectedAnswer = sequence.join(" → ")
            var reverse = sequence.slice().reverse().join(" → ")
            var rotated = sequence.slice(1).concat(sequence.slice(0, 1)).join(" → ")
            choices = [expectedAnswer]
            if (reverse !== expectedAnswer) choices.push(reverse)
            if (rotated !== expectedAnswer && rotated !== reverse) choices.push(rotated)
            if (choices.length < 2) return false
        } else {
            var values = controller.values
            if (!values || values.length === 0) return false
            expectedAnswer = String(values[0])
            choices = []
            for (var i = 0; i < values.length && choices.length < 3; ++i) {
                var candidate = String(values[i])
                if (choices.indexOf(candidate) < 0) choices.push(candidate)
            }
            var fallback = Number(expectedAnswer) + 1
            while (choices.length < Math.min(3, values.length + 1)) {
                var fallbackText = String(fallback++)
                if (choices.indexOf(fallbackText) < 0) choices.push(fallbackText)
            }
        }
        prediction.open()
        return true
    }

    function answer(choice) {
        var correct = choice === expectedAnswer
        if (correct) ++score
        feedback = correct
            ? controller.kind === "Binary Search Tree"
                ? "Correct. " + traversalOrder + " visits nodes in the displayed sequence."
                : controller.kind === "Stack"
                    ? "Correct. A stack removes its top value first (LIFO)."
                    : "Correct. A queue removes its front value first (FIFO)."
            : "Not quite. The expected answer is " + expectedAnswer + "."
        answered = true
        root.theme.announce(feedback)
    }

    function continueChallenge() {
        if (controller.kind === "Binary Search Tree")
            controller.traverse(traversalOrder)
        else
            controller.remove()
        prediction.close()
    }

    Button {
        visible: root.controller && (root.controller.kind === "Stack" || root.controller.kind === "Queue" || root.controller.kind === "Binary Search Tree")
        text: "Predict next"
        Accessible.name: root.controller && root.controller.kind === "Binary Search Tree" ? "Predict the tree traversal sequence" : "Predict the next structure value"
        onClicked: root.prepareChallenge()
    }

    Dialog {
        id: prediction
        title: "Structure challenge"
        modal: true
        width: Math.min(440, parent ? parent.width - 32 : 440)
        anchors.centerIn: Overlay.overlay
        standardButtons: Dialog.NoButton

        contentItem: ColumnLayout {
            spacing: 12
            Label {
                Layout.fillWidth: true
                text: root.controller.kind === "Binary Search Tree"
                    ? "Choose the " + root.traversalOrder + " traversal sequence."
                    : root.controller.kind === "Stack"
                        ? "Which value will Pop remove from the top of this stack?"
                        : "Which value will Dequeue remove from the front of this queue?"
                color: root.theme.text
                wrapMode: Text.WordWrap
            }
            Repeater {
                model: root.choices
                delegate: Button {
                    required property string modelData
                    Layout.fillWidth: true
                    visible: !root.answered
                    text: modelData
                    onClicked: root.answer(modelData)
                }
            }
            Label {
                Layout.fillWidth: true
                visible: root.answered
                text: root.feedback
                color: root.theme.text
                wrapMode: Text.WordWrap
            }
            Button {
                visible: root.answered
                text: "Continue"
                highlighted: true
                onClicked: root.continueChallenge()
            }
        }
    }
}
