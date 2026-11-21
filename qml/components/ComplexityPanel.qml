import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    property AppTheme theme
    property var controller
    property bool compact: false

    Layout.fillWidth: true
    Layout.fillHeight: !compact
    Layout.minimumHeight: compact ? 52 : 90
    implicitHeight: compact ? 58 : 180
    color: theme.panel
    radius: 14
    border.color: theme.border

    readonly property string algorithm: controller.algorithm
    readonly property string bestTime: algorithm === "Binary Search" ? "O(n) total · O(1) search" : algorithm === "Linear Search" ? "O(1)" : algorithm === "Bubble Sort" || algorithm === "Insertion Sort" ? "O(n)" : algorithm === "Selection Sort" ? "O(n²)" : "O(n log n)"
    readonly property string averageTime: algorithm === "Binary Search" ? "O(n log n) total · O(log n) search" : algorithm === "Linear Search" ? "O(n)" : algorithm === "Quick Sort" || algorithm === "Merge Sort" ? "O(n log n)" : "O(n²)"
    readonly property string worstTime: algorithm === "Binary Search" ? "O(n log n) total · O(log n) search" : algorithm === "Linear Search" ? "O(n)" : algorithm === "Merge Sort" ? "O(n log n)" : "O(n²)"
    readonly property string auxiliarySpace: algorithm === "Merge Sort" ? "O(n)" : algorithm === "Quick Sort" ? "O(log n) avg · O(n) worst" : "O(1)"
    readonly property bool isStable: algorithm === "Bubble Sort" || algorithm === "Insertion Sort" || algorithm === "Merge Sort"
    readonly property bool isInPlace: !algorithm.endsWith("Search") && algorithm !== "Merge Sort"

    Label {
        objectName: "compactComplexitySummary"
        visible: root.compact
        anchors.fill: parent
        anchors.margins: 10
        text: "Time: best " + root.bestTime + " · average " + root.averageTime + " · worst " + root.worstTime
              + "\nSpace: " + root.auxiliarySpace
              + (root.algorithm.endsWith("Search") ? "" : " · stable " + (root.isStable ? "yes" : "no") + " · in place " + (root.isInPlace ? "yes" : "no"))
        color: root.theme.supportText
        font.family: "Consolas"
        font.pixelSize: 9
        wrapMode: Text.WordWrap
        verticalAlignment: Text.AlignVCenter
    }

    ColumnLayout {
        visible: !root.compact
        anchors.fill: parent
        anchors.margins: 15
        spacing: 5
        Label { text: "Complexity"; color: root.theme.text; font.bold: true; font.pixelSize: 13 }
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Best time"; color: root.theme.muted; font.pixelSize: 10 }
            Item { Layout.fillWidth: true }
            Label { text: root.bestTime; color: root.theme.amber; font.family: "Consolas"; font.pixelSize: 11 }
        }
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Average time"; color: root.theme.muted; font.pixelSize: 10 }
            Item { Layout.fillWidth: true }
            Label { text: root.averageTime; color: root.theme.amber; font.family: "Consolas"; font.pixelSize: 11 }
        }
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Worst time"; color: root.theme.muted; font.pixelSize: 10 }
            Item { Layout.fillWidth: true }
            Label { text: root.worstTime; color: root.theme.amber; font.family: "Consolas"; font.pixelSize: 11 }
        }
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Auxiliary space"; color: root.theme.muted; font.pixelSize: 10 }
            Item { Layout.fillWidth: true }
            Label { text: root.auxiliarySpace; color: root.theme.purpleText; font.family: "Consolas"; font.pixelSize: 11 }
        }
        Label {
            visible: root.algorithm === "Binary Search"
            Layout.fillWidth: true
            text: "Unsorted inputs are sorted first. Search itself is O(log n); total cost includes that preparation."
            wrapMode: Text.WordWrap
            color: root.theme.supportText
            font.pixelSize: 9
        }
        RowLayout {
            visible: !root.algorithm.endsWith("Search")
            Label { text: "Stable"; color: root.theme.muted; font.pixelSize: 10 }
            Item { Layout.fillWidth: true }
            Label { text: root.isStable ? "Yes" : "No"; color: root.theme.green; font.pixelSize: 11 }
        }
        RowLayout {
            visible: !root.algorithm.endsWith("Search")
            Layout.fillWidth: true
            Label { text: "In place"; color: root.theme.muted; font.pixelSize: 10 }
            Item { Layout.fillWidth: true }
            Label { text: root.isInPlace ? "Yes" : "No"; color: root.theme.green; font.pixelSize: 11 }
        }
    }
}
