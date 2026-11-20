import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "."

Rectangle {
    property color panelColor: "#17172A"
    color: panelColor
 radius: 14
 border.color: "#29243E"
    implicitHeight: 190
    ColumnLayout {
        anchors.fill: parent
 anchors.margins: 16
 spacing: 10
        RowLayout { Icon { name: "sparkle"; color: "#8B5CF6"; iconSize: 16 }
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
 color: "#8B5CF6"
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
 color: "#0D0D1A"
 border.color: "#29243E" }
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

