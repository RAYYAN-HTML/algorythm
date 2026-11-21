import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Rectangle {
    id: root
    required property AppTheme theme
    required property var controller
    required property var settingsController
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
            Button { objectName: "restartPlaybackButton"; Accessible.name: "Restart"; ToolTip.visible: hovered; ToolTip.text: "Restart (R)"
 onClicked: root.controller.restart()
 flat: true; contentItem: Icon { name: "restart"; color: root.theme.muted; iconSize: 18 } }
            Button { objectName: "previousPlaybackButton"; Accessible.name: "Previous step"; ToolTip.visible: hovered; ToolTip.text: "Previous step (Left Arrow)"
 onClicked: root.controller.previous()
 flat: true; contentItem: Icon { name: "previous"; color: root.theme.muted; iconSize: 18 } }
            Button {
                objectName: "playPausePlaybackButton"
                Accessible.name: root.controller.playing ? "Pause" : "Play"
                highlighted: true
                onClicked: root.controller.playPause()
                contentItem: RowLayout {
                    Icon { name: root.controller.playing ? "pause" : "play"; color: root.theme.textOnAccent; iconSize: 15 }
                    Text { text: root.controller.playing ? "Pause" : "Play"; color: root.theme.textOnAccent; font.pixelSize: 12 }
                }
            }
            Button { objectName: "nextPlaybackButton"; Accessible.name: "Next step"; ToolTip.visible: hovered; ToolTip.text: "Next step (Right Arrow)"
 onClicked: root.controller.next()
 flat: true; contentItem: Icon { name: "next"; color: root.theme.muted; iconSize: 18 } }
            Label { Layout.leftMargin: 8
 text: root.controller.stepIndex + 1 + " / " + root.controller.stepCount
 color: root.theme.muted
 font.pixelSize: 11 }
            Item { Layout.fillWidth: true }
            Label { text: root.controller.speed.toFixed(1) + "×"
 color: root.theme.purpleText
 font.bold: true
 font.pixelSize: 12 }
            Slider { id: speed
 objectName: "playbackSpeedSlider"
 Accessible.name: "Playback speed"
 Accessible.description: "Playback speed in times normal"
 from: 0.5
 to: 3.0
 stepSize: 0.5
 value: root.controller.speed
 implicitWidth: 104
 onValueChanged: {
     if (root.controller.speed !== value) root.controller.speed = value
     if (root.settingsController.playbackSpeed !== value) root.settingsController.playbackSpeed = value
 } }
        }
        Slider {
            objectName: "visualizationStepSlider"
            Accessible.name: "Visualization step"
            Accessible.description: "Current step " + (root.controller.stepIndex + 1) + " of " + root.controller.stepCount
            Layout.fillWidth: true
            Layout.maximumWidth: 760
            Layout.alignment: Qt.AlignHCenter
            from: 0
            to: Math.max(0, root.controller.stepCount - 1)
            stepSize: 1
            value: root.controller.stepIndex
            ToolTip.visible: hovered
            ToolTip.text: "Step " + (root.controller.stepIndex + 1) + " of " + root.controller.stepCount
            onValueChanged: {
                const step = Math.round(value)
                if (root.controller.stepIndex !== step) root.controller.seek(step)
            }
        }
    }
}

