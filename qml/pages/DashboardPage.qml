import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: page
    property QtObject theme
    signal navigate(string section)
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 30
        spacing: 22
        Label { text: "YOUR DSA WORKSPACE"; color: theme.cyan; font.pixelSize: 10; font.bold: true; font.letterSpacing: 1.5 }
        Label { text: "Make algorithms visible."; color: theme.text; font.pixelSize: 32; font.bold: true }
        Label { text: "Choose a lab to explore an algorithm one operation at a time."; color: theme.muted; font.pixelSize: 14 }
        GridLayout {
            Layout.fillWidth: true
            columns: page.width < 840 ? 1 : page.width < 1120 ? 2 : 3
            rowSpacing: 16
            columnSpacing: 16
            Repeater {
                model: [
                    ["Sorting", "Compare, swap, and place values with animated circular nodes.", "01"],
                    ["Searching", "Follow Linear and Binary Search as they inspect values.", "02"],
                    ["Linked Lists", "Insert, remove, search, and traverse connected nodes.", "03"],
                    ["Stacks", "Explore linked push, pop, and peek operations.", "04"],
                    ["Queues", "Track front and rear as values enter and leave.", "05"],
                    ["Trees", "Build a Binary Search Tree and inspect its traversals.", "06"],
                    ["Graphs", "Study BFS, DFS, and nonnegative shortest paths.", "07"]
                ]
                delegate: Rectangle {
                    required property var modelData
                    Layout.fillWidth: true
                    Layout.preferredHeight: 146
                    radius: 15
                    color: hover.containsMouse ? "#1A2940" : theme.panel
                    border.color: hover.containsMouse ? theme.cyan : theme.border
                    scale: hover.containsMouse ? 1.015 : 1
                    Behavior on color { ColorAnimation { duration: 160 } }
                    Behavior on scale { NumberAnimation { duration: theme.reducedMotion ? 0 : 150; easing.type: Easing.OutCubic } }
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 18
                        spacing: 8
                        Label { text: modelData[2]; color: theme.purple; font.family: "Consolas"; font.pixelSize: 11 }
                        Label { text: modelData[0]; color: theme.text; font.pixelSize: 17; font.bold: true }
                        Label { Layout.fillWidth: true; text: modelData[1]; color: theme.muted; font.pixelSize: 11; wrapMode: Text.WordWrap }
                    }
                    MouseArea { id: hover; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: page.navigate(modelData[0]) }
                }
            }
        }
        Item { Layout.fillHeight: true }
        Rectangle {
            Layout.fillWidth: true
            height: 74
            radius: 14
            color: "#101827"
            border.color: theme.border
            RowLayout {
                anchors.fill: parent
                anchors.margins: 18
                Label { text: "✦"; color: theme.cyan; font.pixelSize: 18 }
                Label { text: "Start with Bubble Sort"; color: theme.text; font.bold: true }
                Item { Layout.fillWidth: true }
                Button {
                    text: "Open sorting lab  →"
                    highlighted: true
                    onClicked: page.navigate("Sorting")
                    background: Rectangle {
                        radius: 10
                        color: parent.down ? "#0891B2" : parent.hovered ? "#22D3EE" : "#06B6D4"
                        border.color: "#67E8F9"
                        Behavior on color { ColorAnimation { duration: 120 } }
                    }
                    contentItem: Text {
                        text: parent.text
                        color: "#06111F"
                        font.pixelSize: 12
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: 14
                        rightPadding: 14
                    }
                }
            }
        }
    }
}
