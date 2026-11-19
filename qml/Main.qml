import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Algorythm

ApplicationWindow {
    id: window
    visible: true
    width: 1440
    height: 900
    minimumWidth: 780
    minimumHeight: 560
    title: "Algorythm — An Algorithm Visual Simulation"
    color: appColors.background
    property string section: "Dashboard"

    QtObject {
        id: appColors
        readonly property color background: "#080C17"
        readonly property color secondary: "#101827"
        readonly property color panel: "#151F32"
        readonly property color border: "#26344D"
        readonly property color cyan: "#22D3EE"
        readonly property color purple: "#A855F7"
        readonly property color pink: "#EC4899"
        readonly property color amber: "#FBBF24"
        readonly property color green: "#34D399"
        readonly property color text: "#F8FAFC"
        readonly property color muted: "#94A3B8"
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.preferredWidth: window.width < 980 ? 74 : window.width < 1180 ? 184 : 220
            Layout.fillHeight: true
            color: appColors.secondary
            border.color: appColors.border
            ColumnLayout {
                anchors.fill: parent
 anchors.margins: 18
 spacing: 16
                RowLayout {
                    Rectangle { width: 36
 height: 36
 radius: 11
 color: "#183447"
 border.color: appColors.cyan
                        Label { anchors.centerIn: parent
 text: "A"
 color: appColors.cyan
 font.bold: true
 font.pixelSize: 18 }
                    }
                    ColumnLayout { spacing: 0; visible: window.width >= 980
                        Label { text: "Algorythm"
 color: appColors.text
 font.pixelSize: 18
 font.bold: true }
                        Label { text: "AN ALGORITHM VISUAL SIMULATION"
 color: appColors.muted
 font.pixelSize: 9
 font.letterSpacing: 1.5 }
                    }
                }
                Rectangle { Layout.fillWidth: true
 height: 1
 color: appColors.border }
                Label { text: "WORKSPACE"; visible: window.width >= 980
 color: appColors.muted
 font.pixelSize: 10
 font.bold: true
 font.letterSpacing: 1.3 }
                Repeater {
                    model: ["Dashboard", "Sorting", "Searching", "Linked Lists", "Stacks", "Queues", "Trees", "Graphs"]
                    delegate: Rectangle {
                        Layout.fillWidth: true
 height: 38
 radius: 9
                        property bool selected: window.section === modelData
                        color: selected ? "#123244" : hover.containsMouse ? "#182438" : "transparent"
                        border.color: selected ? "#1A5264" : "transparent"
                        Label { anchors.verticalCenter: parent.verticalCenter
 anchors.left: parent.left
 anchors.leftMargin: 12
  text: ["⌂", "⌁", "⌕", "⇄", "▤", "⇥", "⌘", "◉"][index] + (window.width < 980 ? "" : "  " + modelData)
 color: parent.selected ? appColors.cyan : appColors.muted
 font.pixelSize: 13 }
                        MouseArea { id: hover
 anchors.fill: parent
 hoverEnabled: true
 cursorShape: Qt.PointingHandCursor
 onClicked: { window.section = modelData
 if (modelData === "Searching") playback.selectAlgorithm("Linear Search")
 else if (modelData === "Sorting") playback.selectAlgorithm("Bubble Sort")
 else if (modelData === "Linked Lists") structures.kind = "Linked List"
 else if (modelData === "Stacks") structures.kind = "Stack"
 else if (modelData === "Queues") structures.kind = "Queue"
 else if (modelData === "Trees") structures.kind = "Binary Search Tree" } }
                    }
                }
                Item { Layout.fillHeight: true }
                Rectangle { Layout.fillWidth: true
 height: 1
 color: appColors.border }
                Label { text: window.width < 980 ? "◈" : "◈  Compare Algorithms"
 color: appColors.muted
 font.pixelSize: 13
 Layout.leftMargin: 8
 MouseArea { anchors.fill: parent
 cursorShape: Qt.PointingHandCursor
 onClicked: window.section = "Compare" } }
                Label { text: window.width < 980 ? "⚙" : "⚙  Settings"
 color: appColors.muted
 font.pixelSize: 13
 Layout.leftMargin: 8 }
                Rectangle {
                    Layout.fillWidth: true
 height: 66
                    visible: window.width >= 980
 radius: 12
 color: "#111D30"
 border.color: appColors.border
                    RowLayout { anchors.fill: parent
 anchors.margins: 11
                        Rectangle { width: 34
 height: 34
 radius: 17
 color: "#34224C"
 Label { anchors.centerIn: parent
 text: "R"
 color: "#D8B4FE"
 font.bold: true } }
                        ColumnLayout { spacing: 2
 Label { text: "Student Mode"
 color: appColors.text
 font.pixelSize: 12
 font.bold: true }
 Label { text: "Offline workspace"
 color: appColors.muted
 font.pixelSize: 10 } }
                    }
                }
            }
        }

        StackLayout {
            id: pages
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: window.section === "Dashboard" ? 0 : ["Linked Lists", "Stacks", "Queues", "Trees"].includes(window.section) ? 2 : window.section === "Compare" ? 3 : window.section === "Graphs" ? 4 : 1
            DashboardPage { theme: appColors
 onNavigate: section => window.section = section }
            SortingPage { theme: appColors }
            StructurePage { theme: appColors }
            ComparisonPage { theme: appColors }
            GraphPage { theme: appColors }
        }
    }
}

