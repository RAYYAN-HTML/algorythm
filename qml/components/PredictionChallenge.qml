import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    property AppTheme theme
    property var controller
    property int score: 0
    property string feedback: ""

    function openPrediction() { prediction.open() }

    function answer(predictedSwap) {
        var shouldSwap = controller.values[controller.activeA] > controller.values[controller.activeB]
        feedback = predictedSwap === shouldSwap
            ? "Correct. " + (shouldSwap ? "The pair is out of order, so Bubble Sort swaps them." : "The pair is already in ascending order, so it stays in place.")
            : "Not quite. " + (shouldSwap ? "The left value is larger, so this pair swaps." : "The left value is smaller, so this pair stays in place.")
        if (predictedSwap === shouldSwap) ++score
        prediction.close()
        feedbackDialog.open()
    }

    Dialog {
        id: prediction
        title: "Predict the operation"
        modal: true
        width: 360
        anchors.centerIn: Overlay.overlay
        standardButtons: Dialog.NoButton
        contentItem: ColumnLayout {
            Label { text: "Should " + root.controller.values[root.controller.activeA] + " and " + root.controller.values[root.controller.activeB] + " swap?"; color: root.theme.text; font.pixelSize: 13 }
            Label { text: "Use ascending order to decide."; color: root.theme.muted; font.pixelSize: 11 }
            RowLayout {
                Button { text: "Yes, swap"; onClicked: root.answer(true) }
                Button { text: "No, keep order"; onClicked: root.answer(false) }
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
        contentItem: Label { text: root.feedback; color: root.theme.text; wrapMode: Text.WordWrap; padding: 12 }
    }
}
