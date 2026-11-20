import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    property AppTheme theme
    property var controller

    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.minimumHeight: 90
    color: theme.panel
    radius: 14
    border.color: theme.border

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 7
        Label { text: "Complexity"; color: root.theme.text; font.bold: true; font.pixelSize: 13 }
        RowLayout {
            Label { text: "Time"; color: root.theme.muted; font.pixelSize: 10 }
            Item { Layout.fillWidth: true }
            Label {
                text: root.controller.algorithm === "Binary Search" ? "O(log n)" : root.controller.algorithm === "Linear Search" ? "O(n)" : root.controller.algorithm === "Merge Sort" ? "O(n log n)" : root.controller.algorithm === "Quick Sort" ? "O(n²) worst" : "O(n²)"
                color: root.theme.amber; font.family: "Consolas"; font.pixelSize: 11
            }
        }
        RowLayout {
            Label { text: "Auxiliary space"; color: root.theme.muted; font.pixelSize: 10 }
            Item { Layout.fillWidth: true }
            Label {
                text: root.controller.algorithm === "Merge Sort" ? "O(n)" : root.controller.algorithm === "Quick Sort" ? "O(log n) avg" : "O(1)"
                color: root.theme.purpleText; font.family: "Consolas"; font.pixelSize: 11
            }
        }
        RowLayout {
            visible: !root.controller.algorithm.endsWith("Search")
            Label { text: "Stable"; color: root.theme.muted; font.pixelSize: 10 }
            Item { Layout.fillWidth: true }
            Label {
                text: root.controller.algorithm === "Quick Sort" || root.controller.algorithm === "Selection Sort" ? "No" : "Yes"
                color: root.theme.green; font.pixelSize: 11
            }
        }
    }
}
