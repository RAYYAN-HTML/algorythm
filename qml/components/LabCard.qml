import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Button {
    id: root
    property AppTheme theme
    property string labName: ""
    property string description: ""
    property string iconName: "dashboard"
    property string indexLabel: ""

    signal activated()

    Layout.fillWidth: true
    implicitHeight: 150
    padding: 0
    Accessible.name: labName
    Accessible.description: description + ". Open the " + labName + " lab."
    onClicked: root.activated()

    background: Rectangle {
        radius: 15
        color: root.down ? "#29213E" : root.hovered || root.visualFocus ? "#211B39" : root.theme.panel
        border.width: root.visualFocus ? 2 : 1
        border.color: root.hovered || root.visualFocus ? root.theme.purple : root.theme.border
        Behavior on color { ColorAnimation { duration: root.theme.reducedMotion ? 0 : 150 } }
        Behavior on border.color { ColorAnimation { duration: root.theme.reducedMotion ? 0 : 150 } }
    }

    contentItem: ColumnLayout {
        anchors.fill: parent
        anchors.margins: 17
        spacing: 8
        RowLayout {
            Layout.fillWidth: true
            Icon { name: root.iconName; color: root.theme.purple; iconSize: 21 }
            Item { Layout.fillWidth: true }
            Label { text: root.indexLabel; color: root.theme.purple; font.family: "Consolas"; font.pixelSize: 10 }
        }
        Label { text: root.labName; color: root.theme.text; font.pixelSize: 16; font.bold: true }
        RowLayout {
            Layout.fillWidth: true
            Label { Layout.fillWidth: true; text: root.description; color: root.theme.muted; font.pixelSize: 10; wrapMode: Text.WordWrap; maximumLineCount: 2; elide: Text.ElideRight }
            Icon { name: "arrow-right"; color: root.theme.muted; iconSize: 16 }
        }
    }
}
