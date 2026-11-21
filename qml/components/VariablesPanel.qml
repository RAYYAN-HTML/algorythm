pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: panel
    required property AppTheme theme
    required property var controller
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
            Label { text: "{ }"; color: panel.theme.purpleText; font.bold: true }
            Label { text: "Current variables"; color: panel.theme.text; font.bold: true; font.pixelSize: 13 }
            Item { Layout.fillWidth: true }
            Label { text: "STEP STATE"; color: panel.theme.muted; font.pixelSize: 8; font.letterSpacing: 0.8 }
        }

        Repeater {
            model: panel.controller.variableEntries
            delegate: RowLayout {
                id: variableRow
                required property string variableName
                required property var variableValue
                objectName: "variableRow_" + variableRow.variableName
                Layout.fillWidth: true
                spacing: 10
                Label {
                    Layout.preferredWidth: 78
                    text: variableRow.variableName
                    color: panel.theme.muted
                    font.family: "Consolas"
                    font.pixelSize: 10
                    elide: Text.ElideRight
                }
                Label {
                    objectName: "variableValue_" + variableRow.variableName
                    Layout.fillWidth: true
                    text: String(variableRow.variableValue)
                    color: panel.theme.code
                    font.family: "Consolas"
                    font.pixelSize: 10
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignRight
                }
            }
        }
    }
}
