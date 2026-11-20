import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Rectangle {
    id: root
    required property AppTheme theme
    property color panelColor: theme.panel
    color: panelColor
 radius: 14
 border.color: theme.border
    implicitHeight: 88
    ColumnLayout {
        anchors.fill: parent
 anchors.margins: 14
 spacing: 10
        RowLayout {
            spacing: 8
            Button { Accessible.name: "Restart"; ToolTip.visible: hovered; ToolTip.text: "Restart (R)"
 onClicked: playback.restart()
 flat: true; contentItem: Icon { name: "restart"; color: root.theme.muted; iconSize: 18 } }
            Button { Accessible.name: "Previous step"; ToolTip.visible: hovered; ToolTip.text: "Previous step (Left Arrow)"
 onClicked: playback.previous()
 flat: true; contentItem: Icon { name: "previous"; color: root.theme.muted; iconSize: 18 } }
            Button {
                Accessible.name: playback.playing ? "Pause" : "Play"
                highlighted: true
                onClicked: playback.playPause()
                contentItem: RowLayout {
                    Icon { name: playback.playing ? "pause" : "play"; color: root.theme.textOnAccent; iconSize: 15 }
                    Text { text: playback.playing ? "Pause" : "Play"; color: root.theme.textOnAccent; font.pixelSize: 12 }
                }
            }
            Button { Accessible.name: "Next step"; ToolTip.visible: hovered; ToolTip.text: "Next step (Right Arrow)"
 onClicked: playback.next()
 flat: true; contentItem: Icon { name: "next"; color: root.theme.muted; iconSize: 18 } }
            Label { Layout.leftMargin: 8
 text: playback.stepIndex + 1 + " / " + playback.stepCount
 color: root.theme.muted
 font.pixelSize: 11 }
            Item { Layout.fillWidth: true }
            Label { text: playback.speed.toFixed(1) + "×"
 color: root.theme.purple
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
        Slider {
            Layout.fillWidth: true
            Layout.maximumWidth: 760
            Layout.alignment: Qt.AlignHCenter
            from: 0
            to: Math.max(0, playback.stepCount - 1)
            stepSize: 1
            value: playback.stepIndex
            ToolTip.visible: hovered
            ToolTip.text: "Step " + (playback.stepIndex + 1) + " of " + playback.stepCount
            onMoved: playback.seek(value)
        }
    }
}

