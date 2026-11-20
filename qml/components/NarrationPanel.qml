import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "."

Rectangle {
    required property AppTheme theme
    property color panelColor: theme.panel
    color: panelColor
 radius: 14
 border.color: theme.border
    implicitHeight: 190
    ColumnLayout {
        anchors.fill: parent
 anchors.margins: 16
 spacing: 10
        RowLayout { Icon { name: "sparkle"; color: theme.purple; iconSize: 16 }
 Label { text: "Learning assistant"
 color: theme.text
 font.bold: true
 font.pixelSize: 13 }
 Item { Layout.fillWidth: true }
 Label { text: "LIVE"
 color: theme.green
 font.pixelSize: 9
 font.bold: true } }
        Label { text: playback.operation
 color: theme.purpleText
 font.pixelSize: 11
 font.bold: true }
        Label { Layout.fillWidth: true
 wrapMode: Text.WordWrap
 text: playback.narration
 color: theme.content
 font.pixelSize: 12 }
        Item { Layout.fillHeight: true }
        Button { text: "Why does this happen?"
 onClicked: whyDialog.open()
 background: Rectangle { radius: 7
 color: theme.secondary
 border.color: theme.border }
 contentItem: Text { text: parent.text
 color: theme.code
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
 color: theme.content
 padding: 12 }
        standardButtons: Dialog.Ok
    }
}

