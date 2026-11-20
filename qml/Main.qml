import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
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
    Material.theme: Material.Dark
    Material.accent: "#22D3EE"
    Material.primary: "#A855F7"
    Material.foreground: "#F8FAFC"
    Material.background: "#101827"
    property string section: "Dashboard"
    property bool sidebarCollapsed: appSettings.sidebarCollapsed
    property bool reducedMotion: appSettings.reducedMotion
    readonly property int themeMotionDuration: reducedMotion ? 0 : 140
    onReducedMotionChanged: appSettings.reducedMotion = reducedMotion
    onSidebarCollapsedChanged: appSettings.sidebarCollapsed = sidebarCollapsed
    Component.onCompleted: {
        playback.speed = appSettings.playbackSpeed
        playbackA.speed = appSettings.playbackSpeed
        playbackB.speed = appSettings.playbackSpeed
    }

    Connections {
        target: appSettings
        function onPlaybackSpeedChanged() {
            playback.speed = appSettings.playbackSpeed
            playbackA.speed = appSettings.playbackSpeed
            playbackB.speed = appSettings.playbackSpeed
        }
    }

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
        readonly property bool reducedMotion: window.reducedMotion
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.preferredWidth: window.sidebarCollapsed || window.width < 980 ? 68 : window.width < 1180 ? 184 : 220
            Layout.fillHeight: true
            color: appColors.secondary
            border.color: appColors.border
            ColumnLayout {
                anchors.fill: parent
                anchors.leftMargin: window.width < 980 || window.sidebarCollapsed ? 12 : 18
                anchors.rightMargin: window.width < 980 || window.sidebarCollapsed ? 12 : 18
                anchors.topMargin: 18
                anchors.bottomMargin: 18
 spacing: 16
                RowLayout {
                    spacing: 6
                    Rectangle { visible: window.width >= 980 && !window.sidebarCollapsed
 width: 36
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
                    ColumnLayout {
                        spacing: 0
                        visible: window.width >= 980 && !window.sidebarCollapsed
                        Layout.fillWidth: true
                        Layout.minimumWidth: 0
                        Layout.preferredWidth: window.width < 1180 ? 68 : 108
                        Layout.maximumWidth: window.width < 1180 ? 68 : 108
                        Label { Layout.fillWidth: true
 text: window.width < 1180 ? "AlgoViz" : "Algorythm"
 elide: Text.ElideRight
 color: appColors.text
 font.pixelSize: 18
 font.bold: true }
                        Label { Layout.fillWidth: true
 text: "ALGORITHM STUDIO"
 elide: Text.ElideRight
 color: appColors.muted
 font.pixelSize: 9
 font.letterSpacing: 1.0 }
                    }
                    Button {
                        text: "≡"
                        implicitWidth: window.width < 980 || window.sidebarCollapsed ? 36 : 28
                        implicitHeight: 30
                        Layout.alignment: Qt.AlignVCenter
                        onClicked: window.sidebarCollapsed = !window.sidebarCollapsed
                        Accessible.name: window.sidebarCollapsed ? "Expand navigation" : "Collapse navigation"
                        background: Rectangle { radius: 7; color: parent.hovered ? "#182438" : "transparent" }
                        contentItem: Text { text: parent.text; color: appColors.muted; font.pixelSize: 18; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
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
                    delegate: Button {
                        required property string modelData
                        required property int index
                        Layout.fillWidth: true
                        implicitHeight: 42
                        padding: 0
                        checkable: true
                        property bool selected: window.section === modelData
                        checked: selected
                        onClicked: {
                            window.section = modelData
                            if (modelData === "Searching") playback.selectAlgorithm("Linear Search")
                            else if (modelData === "Sorting") playback.selectAlgorithm("Bubble Sort")
                            else if (modelData === "Linked Lists") structures.kind = "Linked List"
                            else if (modelData === "Stacks") structures.kind = "Stack"
                            else if (modelData === "Queues") structures.kind = "Queue"
                            else if (modelData === "Trees") structures.kind = "Binary Search Tree"
                        }
                        Accessible.name: modelData
                        Accessible.description: "Open the " + modelData + " learning lab"
                        ToolTip.visible: window.sidebarCollapsed && hovered
                        ToolTip.text: modelData
                        background: Rectangle {
                            radius: 10
                            color: parent.selected ? "#123244" : parent.hovered ? "#182438" : "transparent"
                            border.color: parent.selected ? "#1A5264" : "transparent"
                            Behavior on color { ColorAnimation { duration: window.themeMotionDuration } }
                            Rectangle { x: 0; y: 8; width: 3; height: parent.height - 16; radius: 2; color: appColors.cyan; visible: parent.parent.selected }
                        }
                        contentItem: RowLayout {
                            spacing: 11
                            Label { text: ["⌂", "⌁", "⌕", "⇄", "▤", "⇥", "⌘", "◉"][index]; color: selected ? appColors.cyan : appColors.muted; font.pixelSize: 15; Layout.leftMargin: 12 }
                            Label { text: modelData; visible: window.width >= 980 && !window.sidebarCollapsed; color: selected ? appColors.text : appColors.muted; font.pixelSize: 12; font.bold: selected; Layout.fillWidth: true; horizontalAlignment: Text.AlignLeft }
                        }
                    }
                }
                Item { Layout.fillHeight: true }
                Rectangle { Layout.fillWidth: true
 height: 1
 color: appColors.border }
                Button {
                    text: window.width < 980 || window.sidebarCollapsed ? "◈" : "◈  Compare Algorithms"
                    Layout.fillWidth: true
                    checkable: true
                    checked: window.section === "Compare"
                    onClicked: window.section = "Compare"
                    Accessible.name: "Compare algorithms"
                    ToolTip.visible: window.sidebarCollapsed && hovered
                    ToolTip.text: "Compare algorithms"
                    background: Rectangle { radius: 9; color: parent.checked ? "#123244" : parent.hovered ? "#182438" : "transparent"; border.color: parent.checked ? "#1A5264" : "transparent"; Behavior on color { ColorAnimation { duration: window.themeMotionDuration } } }
                    contentItem: Text { text: parent.text; color: parent.checked ? appColors.cyan : appColors.muted; font.pixelSize: 12; leftPadding: 11; verticalAlignment: Text.AlignVCenter }
                }
                Button {
                    id: settingsButton
                    text: window.width < 980 || window.sidebarCollapsed ? "⚙" : "⚙  Settings"
                    Layout.fillWidth: true
                    Layout.leftMargin: 4
                    onClicked: settingsMenu.open()
                    background: Rectangle { radius: 8; color: parent.hovered ? "#182438" : "transparent" }
                    contentItem: Text { text: parent.text; color: appColors.muted; font.pixelSize: 13; leftPadding: 6; verticalAlignment: Text.AlignVCenter }
                }
                Popup {
                    id: settingsMenu
                    parent: Overlay.overlay
                    width: 320
                    padding: 18
                    x: Math.max(12, Math.min(window.sidebarCollapsed || window.width < 980 ? 76 : 228, window.width - width - 12))
                    y: Math.max(12, window.height - height - 90)
                    background: Rectangle { radius: 12; color: appColors.panel; border.color: appColors.border }
                    contentItem: ColumnLayout {
                        spacing: 12
                        Label { text: "Settings"; color: appColors.text; font.bold: true; font.pixelSize: 18 }
                        Label { text: "PLAYBACK"; color: appColors.cyan; font.pixelSize: 10; font.bold: true; font.letterSpacing: 1.1 }
                        RowLayout {
                            Layout.fillWidth: true
                            Label { text: "Playback speed"; color: appColors.text; font.pixelSize: 12 }
                            Item { Layout.fillWidth: true }
                            Label { text: appSettings.playbackSpeed.toFixed(1) + "×"; color: appColors.cyan; font.bold: true }
                        }
                        Slider {
                            Layout.fillWidth: true
                            from: 0.5; to: 3.0; stepSize: 0.5
                            value: appSettings.playbackSpeed
                            onMoved: appSettings.playbackSpeed = value
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: appColors.border }
                        Label { text: "ACCESSIBILITY & LAYOUT"; color: appColors.cyan; font.pixelSize: 10; font.bold: true; font.letterSpacing: 1.1 }
                        Switch {
                            text: "Reduced motion"
                            checked: window.reducedMotion
                            onToggled: window.reducedMotion = checked
                        }
                        Switch {
                            text: "Compact sidebar"
                            checked: window.sidebarCollapsed
                            onToggled: window.sidebarCollapsed = checked
                        }
                        Label { text: "Preferences and workspace layout are saved on this device."; color: appColors.muted; font.pixelSize: 10; wrapMode: Text.WordWrap; Layout.fillWidth: true }
                        Button {
                            text: "Restore default settings"
                            Layout.fillWidth: true
                            onClicked: {
                                appSettings.resetPreferences()
                                window.reducedMotion = false
                                window.sidebarCollapsed = false
                                playback.speed = 1.0
                                playbackA.speed = 1.0
                                playbackB.speed = 1.0
                                settingsMenu.close()
                            }
                            background: Rectangle { radius: 8; color: parent.hovered ? "#22314A" : "#101827"; border.color: appColors.border }
                            contentItem: Text { text: parent.text; color: appColors.text; font.pixelSize: 11; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                        }
                    }
                }
                Rectangle {
                    Layout.fillWidth: true
 height: 66
                    visible: window.width >= 980 && !window.sidebarCollapsed
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

