import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: panel
    required property AppTheme theme
    property color panelColor: theme.panel
    color: panelColor
    radius: 14
    border.color: theme.border
    implicitHeight: content.implicitHeight + 30

    ColumnLayout {
        id: content
        anchors.fill: parent
        anchors.margins: 15
        spacing: 8

        RowLayout {
            Layout.fillWidth: true
            Label { text: "{ }"; color: theme.purple; font.bold: true }
            Label { text: "Current variables"; color: theme.text; font.bold: true; font.pixelSize: 13 }
            Item { Layout.fillWidth: true }
            Label { text: "STEP STATE"; color: theme.muted; font.pixelSize: 8; font.letterSpacing: 0.8 }
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
                    color: theme.muted
                    font.family: "Consolas"
                    font.pixelSize: 10
                    elide: Text.ElideRight
                }
                Label {
                    Layout.fillWidth: true
                    text: String(playback.variables[modelData])
                    color: theme.code
                    font.family: "Consolas"
                    font.pixelSize: 10
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignRight
                }
            }
        }
    }
}
