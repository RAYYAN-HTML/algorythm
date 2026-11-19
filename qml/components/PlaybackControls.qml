import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    property color panelColor: "#151F32"
    color: panelColor
 radius: 14
 border.color: "#26344D"
    implicitHeight: 88
    ColumnLayout {
        anchors.fill: parent
 anchors.margins: 14
 spacing: 10
        RowLayout {
            spacing: 8
            Button { text: "↶"
 onClicked: playback.restart()
 ToolTip.visible: hovered
 ToolTip.text: "Restart (R)"
 flat: true }
            Button { text: "◀"
 onClicked: playback.previous()
 ToolTip.visible: hovered
 ToolTip.text: "Previous step (←)"
 flat: true }
            Button { text: playback.playing ? "Ⅱ  Pause" : "▶  Play"
 highlighted: true
 onClicked: playback.playPause() }
            Button { text: "▶|"
 onClicked: playback.next()
 ToolTip.visible: hovered
 ToolTip.text: "Next step (→)"
 flat: true }
            Label { Layout.leftMargin: 8
 text: playback.stepIndex + 1 + " / " + playback.stepCount
 color: "#94A3B8"
 font.pixelSize: 11 }
            Item { Layout.fillWidth: true }
            Label { text: playback.speed.toFixed(1) + "×"
 color: "#22D3EE"
 font.bold: true
 font.pixelSize: 12 }
            Slider { id: speed
 from: 0.5
 to: 3.0
 stepSize: 0.5
 value: playback.speed
 implicitWidth: 104
 onMoved: playback.speed = value }
        }
        Slider { Layout.fillWidth: true
 from: 0
 to: Math.max(0, playback.stepCount - 1)
 stepSize: 1
 value: playback.stepIndex
 onMoved: playback.seek(value) }
    }
}

