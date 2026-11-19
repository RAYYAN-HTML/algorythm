import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    property color panelColor: "#151F32"
    color: panelColor
 radius: 14
 border.color: "#26344D"
    implicitHeight: 190
    ColumnLayout {
        anchors.fill: parent
 anchors.margins: 16
 spacing: 10
        RowLayout { Label { text: "✦"
 color: "#22D3EE" }
 Label { text: "Learning assistant"
 color: "#F8FAFC"
 font.bold: true
 font.pixelSize: 13 }
 Item { Layout.fillWidth: true }
 Label { text: "LIVE"
 color: "#34D399"
 font.pixelSize: 9
 font.bold: true } }
        Label { text: playback.operation
 color: "#22D3EE"
 font.pixelSize: 11
 font.bold: true }
        Label { Layout.fillWidth: true
 wrapMode: Text.WordWrap
 text: playback.narration
 color: "#CBD5E1"
 font.pixelSize: 12 }
        Item { Layout.fillHeight: true }
        Button { text: "Why does this happen?"
 onClicked: whyDialog.open()
 background: Rectangle { radius: 7
 color: "#101827"
 border.color: "#26344D" }
 contentItem: Text { text: parent.text
 color: "#C4B5FD"
 font.pixelSize: 10
 horizontalAlignment: Text.AlignHCenter
 verticalAlignment: Text.AlignVCenter } }
    }
    Dialog {
        id: whyDialog
 title: "Why this operation?"
 modal: true
 anchors.centerIn: Overlay.overlay
 width: 350
        contentItem: Label { text: playback.why
 wrapMode: Text.WordWrap
 color: "#CBD5E1"
 padding: 12 }
        standardButtons: Dialog.Ok
    }
}

