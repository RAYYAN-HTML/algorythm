import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    property AppTheme theme
    property var controller
    property int score: 0
    property string feedback: ""
    property bool resumeAfterFeedback: false

    function openPrediction() {
        resumeAfterFeedback = controller.playing
        if (resumeAfterFeedback) controller.playPause()
        prediction.open()
    }

    function answer(alreadyDiscovered) {
        const neighbor = controller.edgeTo
        const expectedAlreadyDiscovered = controller.discovered.indexOf(neighbor) >= 0
        const explanation = expectedAlreadyDiscovered
            ? "The neighbor has already been discovered, so this edge does not add it to the frontier again."
            : "The neighbor is new. The algorithm adds it to the frontier and will visit it later."
        feedback = (alreadyDiscovered === expectedAlreadyDiscovered ? "Correct. " : "Not quite. ") + explanation
        if (alreadyDiscovered === expectedAlreadyDiscovered) ++score
        prediction.close()
        feedbackDialog.open()
    }

    function continueAfterFeedback() {
        controller.next()
        if (resumeAfterFeedback) controller.playPause()
        resumeAfterFeedback = false
    }

    Dialog {
        id: prediction
        title: "Predict the next graph step"
        modal: true
        width: 390
        anchors.centerIn: Overlay.overlay
        standardButtons: Dialog.NoButton
        contentItem: ColumnLayout {
            Label {
                text: "Has node " + root.controller.edgeTo + " already been discovered from node " + root.controller.active + "?"
                color: root.theme.text
                font.pixelSize: 13
                wrapMode: Text.WordWrap
            }
            Label {
                text: "BFS and DFS avoid adding an already discovered node to their frontier a second time."
                color: root.theme.muted
                font.pixelSize: 11
                wrapMode: Text.WordWrap
            }
            RowLayout {
                Button { text: "Yes, already discovered"; onClicked: root.answer(true) }
                Button { text: "No, it is new"; onClicked: root.answer(false) }
            }
        }
    }

    Dialog {
        id: feedbackDialog
        title: "Prediction"
        modal: true
        width: 390
        anchors.centerIn: Overlay.overlay
        standardButtons: Dialog.Ok
        onAccepted: root.continueAfterFeedback()
        contentItem: Label { text: root.feedback; color: root.theme.text; wrapMode: Text.WordWrap; padding: 12 }
    }
}
