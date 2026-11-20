import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: panel
    property color panelColor: "#17172A"
    color: panelColor
    radius: 14
    border.color: "#29243E"
    implicitHeight: content.implicitHeight + 30

    ColumnLayout {
        id: content
        anchors.fill: parent
        anchors.margins: 15
        spacing: 8

        RowLayout {
            Layout.fillWidth: true
            Label { text: "{ }"; color: "#8B5CF6"; font.bold: true }
            Label { text: "Current variables"; color: "#F8FAFC"; font.bold: true; font.pixelSize: 13 }
            Item { Layout.fillWidth: true }
            Label { text: "STEP STATE"; color: "#94A3B8"; font.pixelSize: 8; font.letterSpacing: 0.8 }
        }

        Repeater {
            model: Object.keys(playback.variables)
            delegate: RowLayout {
                required property string modelData
                Layout.fillWidth: true
                spacing: 10
                Label {
                    Layout.preferredWidth: 78
                    text: modelData
                    color: "#94A3B8"
                    font.family: "Consolas"
                    font.pixelSize: 10
                    elide: Text.ElideRight
                }
                Label {
                    Layout.fillWidth: true
                    text: String(playback.variables[modelData])
                    color: "#C4B5FD"
                    font.family: "Consolas"
                    font.pixelSize: 10
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignRight
                }
            }
        }
    }
}
