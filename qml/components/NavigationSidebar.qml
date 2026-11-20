import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    property QtObject theme
    property QtObject appSettings
    property string section: "Dashboard"
    property bool sidebarCollapsed: false
    property bool reducedMotion: false
    property int windowWidth: 1440
    property int windowHeight: 900

    signal navigationRequested(string section)
    signal collapseRequested()
    signal reducedMotionToggled(bool enabled)
    signal sidebarCollapsedToggled(bool enabled)
    signal defaultsRestored()

    Layout.preferredWidth: sidebarCollapsed || windowWidth < 980 ? 68 : windowWidth < 1180 ? 184 : 220
    Layout.fillHeight: true
    color: theme.secondary
    border.color: theme.border

    ColumnLayout {
        anchors.fill: parent
        anchors.leftMargin: root.windowWidth < 980 || root.sidebarCollapsed ? 10 : 18
        anchors.rightMargin: root.windowWidth < 980 || root.sidebarCollapsed ? 10 : 18
        anchors.topMargin: root.windowHeight < 700 ? 10 : 18
        anchors.bottomMargin: root.windowHeight < 700 ? 10 : 18
        spacing: root.windowHeight < 700 ? 6 : 16

        RowLayout {
            spacing: 6
            Rectangle {
                visible: root.windowWidth >= 980 && !root.sidebarCollapsed
                width: 36; height: 36; radius: 11
                color: "#183447"; border.color: root.theme.cyan
                Label { anchors.centerIn: parent; text: "A"; color: root.theme.cyan; font.bold: true; font.pixelSize: 18 }
            }
            ColumnLayout {
                spacing: 0
                visible: root.windowWidth >= 980 && !root.sidebarCollapsed
                Layout.fillWidth: true
                Layout.minimumWidth: 0
                Layout.preferredWidth: root.windowWidth < 1180 ? 68 : 108
                Layout.maximumWidth: root.windowWidth < 1180 ? 68 : 108
                Label { Layout.fillWidth: true; text: root.windowWidth < 1180 ? "AlgoViz" : "Algorythm"; elide: Text.ElideRight; color: root.theme.text; font.pixelSize: 18; font.bold: true }
                Label { Layout.fillWidth: true; text: "ALGORITHM STUDIO"; elide: Text.ElideRight; color: root.theme.muted; font.pixelSize: 9; font.letterSpacing: 1.0 }
            }
            Button {
                implicitWidth: root.windowWidth < 980 || root.sidebarCollapsed ? 36 : 28
                implicitHeight: 30
                Layout.alignment: Qt.AlignVCenter
                Accessible.name: root.sidebarCollapsed ? "Expand navigation" : "Collapse navigation"
                ToolTip.visible: hovered
                ToolTip.text: Accessible.name
                onClicked: root.collapseRequested()
                background: Rectangle { radius: 7; color: parent.hovered ? "#182438" : "transparent" }
                contentItem: Icon { name: "menu"; color: root.theme.muted; iconSize: 18 }
            }
        }

        Rectangle { Layout.fillWidth: true; height: 1; color: root.theme.border }
        Label { text: "WORKSPACE"; visible: root.windowWidth >= 980; color: root.theme.muted; font.pixelSize: 10; font.bold: true; font.letterSpacing: 1.3 }

        ScrollView {
            id: navigationScroll
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            ScrollBar.vertical.policy: ScrollBar.AsNeeded
            ColumnLayout {
                id: navigationItems
                width: navigationScroll.availableWidth
                spacing: root.windowHeight < 700 ? 5 : 8
                Repeater {
                    model: [
                        { name: "Dashboard", icon: "dashboard" },
                        { name: "Sorting", icon: "sorting" },
                        { name: "Searching", icon: "search" },
                        { name: "Linked Lists", icon: "linked-list" },
                        { name: "Stacks", icon: "stack" },
                        { name: "Queues", icon: "queue" },
                        { name: "Trees", icon: "tree" },
                        { name: "Graphs", icon: "graph" }
                    ]
                    delegate: Button {
                        required property var modelData
                        Layout.fillWidth: true
                        implicitHeight: root.windowHeight < 700 ? 34 : 42
                        padding: 0
                        checkable: true
                        property bool selected: root.section === modelData.name
                        checked: selected
                        Accessible.name: modelData.name
                        Accessible.description: "Open the " + modelData.name + " learning lab"
                        ToolTip.visible: (root.sidebarCollapsed || root.windowWidth < 980) && hovered
                        ToolTip.text: modelData.name
                        onClicked: root.navigationRequested(modelData.name)
                        background: Rectangle {
                            radius: 10
                            color: parent.selected ? "#123244" : parent.hovered ? "#182438" : "transparent"
                            border.color: parent.selected ? "#1A5264" : "transparent"
                            Behavior on color { ColorAnimation { duration: root.reducedMotion ? 0 : 140 } }
                            Rectangle { x: 0; y: 6; width: 3; height: parent.height - 12; radius: 2; color: root.theme.cyan; visible: parent.parent.selected }
                        }
                        contentItem: RowLayout {
                            spacing: 11
                            Icon { name: modelData.icon; color: selected ? root.theme.cyan : root.theme.muted; iconSize: 17; Layout.leftMargin: 12 }
                            Label { text: modelData.name; visible: root.windowWidth >= 980 && !root.sidebarCollapsed; color: selected ? root.theme.text : root.theme.muted; font.pixelSize: 12; font.bold: selected; Layout.fillWidth: true; horizontalAlignment: Text.AlignLeft }
                        }
                    }
                }
            }
        }

        Rectangle { Layout.fillWidth: true; height: 1; color: root.theme.border }
        Button {
            Layout.fillWidth: true
            implicitHeight: root.windowHeight < 700 ? 34 : 42
            padding: 0
            checkable: true
            checked: root.section === "Compare"
            Accessible.name: "Compare algorithms"
            ToolTip.visible: (root.sidebarCollapsed || root.windowWidth < 980) && hovered
            ToolTip.text: "Compare algorithms"
            onClicked: root.navigationRequested("Compare")
            background: Rectangle { radius: 9; color: parent.checked ? "#123244" : parent.hovered ? "#182438" : "transparent"; border.color: parent.checked ? "#1A5264" : "transparent" }
            contentItem: RowLayout {
                Icon { name: "compare"; color: root.section === "Compare" ? root.theme.cyan : root.theme.muted; iconSize: 17; Layout.leftMargin: 12 }
                Label { text: "Compare Algorithms"; visible: root.windowWidth >= 980 && !root.sidebarCollapsed; color: root.section === "Compare" ? root.theme.cyan : root.theme.muted; font.pixelSize: 11; Layout.fillWidth: true }
            }
        }
        Button {
            implicitHeight: root.windowHeight < 700 ? 34 : 42
            Layout.fillWidth: true
            padding: 0
            Accessible.name: "Settings"
            ToolTip.visible: (root.sidebarCollapsed || root.windowWidth < 980) && hovered
            ToolTip.text: "Settings"
            onClicked: settingsMenu.open()
            background: Rectangle { radius: 8; color: parent.hovered ? "#182438" : "transparent" }
            contentItem: RowLayout {
                Icon { name: "settings"; color: root.theme.muted; iconSize: 17; Layout.leftMargin: 12 }
                Label { text: "Settings"; visible: root.windowWidth >= 980 && !root.sidebarCollapsed; color: root.theme.muted; font.pixelSize: 11; Layout.fillWidth: true }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 66
            visible: root.windowWidth >= 980 && !root.sidebarCollapsed && root.windowHeight >= 700
            radius: 12; color: "#111D30"; border.color: root.theme.border
            RowLayout {
                anchors.fill: parent; anchors.margins: 11
                Rectangle { width: 34; height: 34; radius: 17; color: "#34224C"; Label { anchors.centerIn: parent; text: "R"; color: "#D8B4FE"; font.bold: true } }
                ColumnLayout {
                    spacing: 2
                    Label { text: "Student Mode"; color: root.theme.text; font.pixelSize: 12; font.bold: true }
                    Label { text: "Offline workspace"; color: root.theme.muted; font.pixelSize: 10 }
                }
            }
        }
    }

    SettingsPopup {
        id: settingsMenu
        theme: root.theme
        appSettings: root.appSettings
        reducedMotion: root.reducedMotion
        sidebarCollapsed: root.sidebarCollapsed
        windowWidth: root.windowWidth
        windowHeight: root.windowHeight
        onReducedMotionToggled: enabled => root.reducedMotionToggled(enabled)
        onSidebarCollapsedToggled: enabled => root.sidebarCollapsedToggled(enabled)
        onDefaultsRestored: root.defaultsRestored()
    }
}
