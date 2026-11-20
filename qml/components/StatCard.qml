import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    property AppTheme theme
    property string iconName: "dashboard"
    property string value: ""
    property string caption: ""
    property string detail: ""

    Layout.fillWidth: true
    Layout.preferredHeight: 96
    radius: 14
    color: root.theme.panel
    border.color: root.theme.border

    RowLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 12

        Rectangle {
            Layout.preferredWidth: 38
            Layout.preferredHeight: 38
            radius: 12
            color: theme.selectedSurface
            Icon { anchors.centerIn: parent; name: root.iconName; color: root.theme.purple; iconSize: 19 }
        }
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4
            Label { text: root.caption; color: root.theme.muted; font.pixelSize: 9; font.bold: true; font.letterSpacing: 0.7 }
            Label { text: root.detail; color: root.theme.subdued; font.pixelSize: 9; elide: Text.ElideRight; Layout.fillWidth: true }
        }
        Label { text: root.value; color: root.theme.text; font.pixelSize: 22; font.bold: true; font.family: "Consolas" }
    }
}
