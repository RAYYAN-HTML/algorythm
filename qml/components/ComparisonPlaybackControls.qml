import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "."

Rectangle {
    id: root
    required property AppTheme theme
    required property var controllerA
    required property var controllerB
    required property var settingsController

    signal playPauseRequested()

    Layout.fillWidth: true
    implicitHeight: 104
    radius: 13
    color: theme.panel
    border.color: theme.border

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 6

        RowLayout {
            Layout.fillWidth: true
            Button {
                Accessible.name: "Restart both"
                onClicked: { root.controllerA.restart(); root.controllerB.restart() }
                contentItem: RowLayout {
                    Icon { name: "restart"; color: root.theme.muted; iconSize: 16 }
                    Label { text: "Restart"; color: root.theme.text }
                }
            }
            Button {
                Accessible.name: "Previous step both"
                onClicked: { root.controllerA.previous(); root.controllerB.previous() }
                contentItem: RowLayout {
                    Icon { name: "previous"; color: root.theme.muted; iconSize: 16 }
                    Label { text: "Step"; color: root.theme.text }
                }
            }
            Button {
                Accessible.name: root.controllerA.playing && root.controllerB.playing ? "Pause both" : "Run both"
                highlighted: true
                onClicked: root.playPauseRequested()
                contentItem: RowLayout {
                    Icon { name: root.controllerA.playing && root.controllerB.playing ? "pause" : "play"; color: root.theme.textOnAccent; iconSize: 15 }
                    Label { text: root.controllerA.playing && root.controllerB.playing ? "Pause both" : "Run both"; color: root.theme.textOnAccent; font.bold: true }
                }
            }
            Button {
                Accessible.name: "Next step both"
                onClicked: { root.controllerA.next(); root.controllerB.next() }
                contentItem: RowLayout {
                    Label { text: "Step"; color: root.theme.text }
                    Icon { name: "next"; color: root.theme.muted; iconSize: 16 }
                }
            }
            Item { Layout.fillWidth: true }
        }

        RowLayout {
            Layout.fillWidth: true
            Label { text: "Speed"; color: root.theme.muted; font.pixelSize: 10 }
            Slider {
                id: speedSlider
                objectName: "comparisonSpeedSlider"
                Accessible.name: "Comparison playback speed"
                Accessible.description: "Shared playback speed in times normal for both algorithms"
                Layout.fillWidth: true
                Layout.maximumWidth: 200
                from: 0.5
                to: 3.0
                stepSize: 0.5
                value: root.controllerA.speed
                onValueChanged: {
                    if (root.controllerA.speed !== value || root.controllerB.speed !== value) {
                        root.controllerA.speed = value
                        root.controllerB.speed = value
                        root.settingsController.playbackSpeed = value
                    }
                }
            }
            Label { text: root.controllerA.speed.toFixed(1) + "×"; color: root.theme.purpleText; font.bold: true; font.pixelSize: 10 }
            Item { Layout.fillWidth: true }
            Label {
                Layout.fillWidth: true
                text: root.controllerA.complete && root.controllerB.complete ? "Comparison complete — compare operation counts." : "Both traces use the same starting input."
                color: root.theme.muted
                font.pixelSize: 10
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignRight
            }
        }
    }
}
