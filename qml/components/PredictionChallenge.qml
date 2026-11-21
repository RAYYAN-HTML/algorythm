import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    property AppTheme theme
    property var controller
    property int score: 0
    property string feedback: ""
    property string predictionKind: "swap"
    property bool resumeAfterFeedback: false

    function openPrediction(kind) {
        predictionKind = kind || "swap"
        resumeAfterFeedback = controller.playing
        controller.pausePlayback()
        prediction.open()
    }

    function answer(predictedYes) {
        var value = controller.values[controller.activeA]
        var expectedYes = false
        var correctExplanation = ""
        if (predictionKind === "target") {
            expectedYes = value === controller.searchTarget
            correctExplanation = expectedYes
                ? "This value matches the target, so Linear Search stops here."
                : "This value does not match, so Linear Search continues to the next index."
        } else if (predictionKind === "direction") {
            expectedYes = controller.searchTarget > value
            correctExplanation = controller.searchTarget === value
                ? "The target equals the midpoint, so Binary Search has found it."
                : expectedYes
                    ? "The target is larger than the midpoint, so Binary Search discards the lower half."
                    : "The target is smaller than the midpoint, so Binary Search discards the upper half."
        } else if (predictionKind === "minimum") {
            var currentMinimum = controller.values[controller.activeA]
            var candidate = controller.values[controller.activeB]
            expectedYes = candidate < currentMinimum
            correctExplanation = expectedYes
                ? "The candidate is smaller than the current minimum, so Selection Sort records it as the new minimum."
                : "The candidate is not smaller, so Selection Sort keeps the current minimum."
        } else if (predictionKind === "moveLeft") {
            var leftValue = controller.values[controller.activeA]
            var keyValue = controller.values[controller.activeB]
            expectedYes = leftValue > keyValue
            correctExplanation = expectedYes
                ? "The preceding value is greater than the key, so Insertion Sort moves the key left."
                : "The preceding value is not greater than the key, so the sorted prefix is in order."
        } else if (predictionKind === "partition") {
            expectedYes = value <= controller.values[controller.activeB]
            correctExplanation = expectedYes
                ? "The value is no greater than the pivot, so Quick Sort keeps it in the left partition."
                : "The value is greater than the pivot, so Quick Sort leaves it in the right partition."
        } else if (predictionKind === "merge") {
            expectedYes = value <= controller.values[controller.activeB]
            correctExplanation = expectedYes
                ? "The left value is smaller or equal, so Merge Sort writes it next to preserve ascending order."
                : "The right value is smaller, so Merge Sort writes it next to preserve ascending order."
        } else {
            expectedYes = value > controller.values[controller.activeB]
            correctExplanation = expectedYes
                ? "The pair is out of order, so Bubble Sort swaps them."
                : "The pair is already in ascending order, so it stays in place."
        }
        feedback = predictedYes === expectedYes
            ? "Correct. " + correctExplanation
            : "Not quite. " + correctExplanation
        if (predictedYes === expectedYes) ++score
        prediction.close()
        feedbackDialog.open()
    }

    function continueAfterFeedback() {
        controller.next()
        if (resumeAfterFeedback) controller.startPlayback()
        resumeAfterFeedback = false
    }

    Dialog {
        id: prediction
        title: "Predict the operation"
        modal: true
        width: 360
        anchors.centerIn: Overlay.overlay
        standardButtons: Dialog.NoButton
        contentItem: ColumnLayout {
            Label {
                text: root.predictionKind === "minimum"
                    ? "Is candidate " + root.controller.values[root.controller.activeB] + " smaller than current minimum " + root.controller.values[root.controller.activeA] + "?"
                    : root.predictionKind === "moveLeft"
                        ? "Should key " + root.controller.values[root.controller.activeB] + " move left past " + root.controller.values[root.controller.activeA] + "?"
                        : root.predictionKind === "partition"
                            ? "Does " + root.controller.values[root.controller.activeA] + " belong in the left partition of pivot " + root.controller.values[root.controller.activeB] + "?"
                            : root.predictionKind === "merge"
                                ? "Should " + root.controller.values[root.controller.activeA] + " from the left half be written before " + root.controller.values[root.controller.activeB] + "?"
                                : root.predictionKind === "target"
                    ? "Does inspected value " + root.controller.values[root.controller.activeA] + " match target " + root.controller.searchTarget + "?"
                    : root.predictionKind === "direction"
                        ? "Is target " + root.controller.searchTarget + " greater than midpoint " + root.controller.values[root.controller.activeA] + "?"
                        : "Should " + root.controller.values[root.controller.activeA] + " and " + root.controller.values[root.controller.activeB] + " swap?"
                color: root.theme.text
                font.pixelSize: 13
                wrapMode: Text.WordWrap
            }
            Label {
                text: root.predictionKind === "minimum" || root.predictionKind === "moveLeft" || root.predictionKind === "partition" || root.predictionKind === "merge"
                    ? "Use the values and the algorithm's ordering rule."
                    : root.predictionKind === "direction"
                    ? "Predict which half of the current range can be discarded."
                    : root.predictionKind === "target"
                        ? "If it does not match, Linear Search checks the next value."
                        : "Use ascending order to decide."
                color: root.theme.muted
                font.pixelSize: 11
                wrapMode: Text.WordWrap
            }
            RowLayout {
                Button {
                    text: root.predictionKind === "target" ? "Yes, it matches" : root.predictionKind === "direction" ? "Yes, target is greater" : root.predictionKind === "minimum" ? "Yes, new minimum" : root.predictionKind === "moveLeft" ? "Yes, move left" : root.predictionKind === "partition" ? "Yes, left side" : root.predictionKind === "merge" ? "Yes, left first" : "Yes, swap"
                    onClicked: root.answer(true)
                }
                Button {
                    text: root.predictionKind === "target" ? "No, keep searching" : root.predictionKind === "direction" ? "No, equal or smaller" : root.predictionKind === "minimum" ? "No, keep minimum" : root.predictionKind === "moveLeft" ? "No, keep order" : root.predictionKind === "partition" ? "No, right side" : root.predictionKind === "merge" ? "No, right first" : "No, keep order"
                    onClicked: root.answer(false)
                }
            }
        }
    }

    Dialog {
        id: feedbackDialog
        title: "Prediction"
        modal: true
        width: 360
        anchors.centerIn: Overlay.overlay
        standardButtons: Dialog.Ok
        onAccepted: root.continueAfterFeedback()
        contentItem: Label { text: root.feedback; color: root.theme.text; wrapMode: Text.WordWrap; padding: 12 }
    }
}
