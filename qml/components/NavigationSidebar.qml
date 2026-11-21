import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    property AppTheme theme
    property QtObject appSettings
    property string section: "Dashboard"
    property bool sidebarCollapsed: false
    property bool reducedMotion: false
    property int windowWidth: 1440
    property int windowHeight: 900
    property string tooltipText: ""
    property real tooltipCenterY: 0
    property real sidebarWidth: sidebarCollapsed || windowWidth < 980 ? 68 : windowWidth < 1180 ? 184 : 220
    property Gradient activeGradient: Gradient {
        GradientStop { position: 0.0; color: "#3C2465" }
        GradientStop { position: 1.0; color: "#241A3B" }
    }

    signal navigationRequested(string section)
    signal collapseRequested()
    signal reducedMotionToggled(bool enabled)
    signal sidebarCollapsedToggled(bool enabled)
    signal defaultsRestored()

    Layout.preferredWidth: sidebarWidth
    Layout.fillHeight: true
    z: tooltipText.length > 0 ? 10 : 0
    Behavior on sidebarWidth {
        NumberAnimation { duration: root.reducedMotion ? 0 : 220; easing.type: Easing.OutCubic }
    }
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
            AppLogo {
                visible: root.windowWidth >= 980 && !root.sidebarCollapsed
                size: 36
                theme: root.theme
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
                id: collapseButton
                implicitWidth: root.windowWidth < 980 || root.sidebarCollapsed ? 36 : 28
                implicitHeight: 30
                Layout.alignment: Qt.AlignVCenter
                Accessible.name: root.sidebarCollapsed ? "Expand navigation" : "Collapse navigation"
                ToolTip.visible: hovered
                ToolTip.text: Accessible.name
                onClicked: root.collapseRequested()
                background: Rectangle { radius: 7; color: collapseButton.hovered || collapseButton.visualFocus ? root.theme.elevated : "transparent"; border.width: collapseButton.visualFocus ? 2 : 0; border.color: root.theme.brightPurple }
                contentItem: Icon { name: "menu"; color: root.theme.muted; iconSize: 18 }
            }
        }

        Rectangle { Layout.fillWidth: true; implicitHeight: 1; color: root.theme.border }
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
                        id: navigationButton
                        objectName: "navigation_" + modelData.name.replace(/\W/g, "_")
                        required property var modelData
                        Layout.fillWidth: true
                        implicitHeight: root.windowHeight < 700 ? 34 : 42
                        padding: 0
                        checkable: true
                        property bool selected: root.section === modelData.name
                        checked: selected
                        Accessible.name: modelData.name
                        Accessible.description: "Open the " + modelData.name + " learning lab"
                        onHoveredChanged: {
                            if (hovered && (root.sidebarCollapsed || root.windowWidth < 980)) {
                                root.tooltipText = modelData.name
                                root.tooltipCenterY = navigationButton.mapToItem(root, 0, navigationButton.height / 2).y
                            } else if (root.tooltipText === modelData.name) {
                                root.tooltipText = ""
                            }
                        }
                        onClicked: root.navigationRequested(modelData.name)
                        background: Rectangle {
                            radius: 10
                            color: navigationButton.selected ? "#35215A" : navigationButton.hovered || navigationButton.visualFocus ? "#211B39" : "transparent"
                            border.width: navigationButton.visualFocus ? 2 : navigationButton.selected ? 1 : 0
                            border.color: navigationButton.visualFocus ? root.theme.brightPurple : navigationButton.selected ? root.theme.deepPurple : "transparent"
                            gradient: navigationButton.selected ? activeGradient : undefined
                            Behavior on color { ColorAnimation { duration: root.reducedMotion ? 0 : 140 } }
                            Rectangle { x: 0; y: 6; width: 3; height: parent.height - 12; radius: 2; color: root.theme.purple; visible: navigationButton.selected }
                        }
                        contentItem: RowLayout {
                            spacing: 11
                            Icon { name: modelData.icon; color: selected ? root.theme.purple : root.theme.muted; iconSize: 17; Layout.leftMargin: 12 }
                            Label { text: modelData.name; visible: root.windowWidth >= 980 && !root.sidebarCollapsed; color: selected ? root.theme.text : root.theme.muted; font.pixelSize: 12; font.bold: selected; Layout.fillWidth: true; horizontalAlignment: Text.AlignLeft }
                        }
                    }
                }
            }
        }


        Rectangle { Layout.fillWidth: true; implicitHeight: 1; color: root.theme.border }
        Button {
            id: compareButton
            Layout.fillWidth: true
            implicitHeight: root.windowHeight < 700 ? 34 : 42
            padding: 0
            checkable: true
            checked: root.section === "Compare"
            Accessible.name: "Compare algorithms"
            onHoveredChanged: {
                if (hovered && (root.sidebarCollapsed || root.windowWidth < 980)) {
                    root.tooltipText = "Compare algorithms"
                    root.tooltipCenterY = compareButton.mapToItem(root, 0, compareButton.height / 2).y
                } else if (root.tooltipText === "Compare algorithms") {
                    root.tooltipText = ""
                }
            }
            onClicked: root.navigationRequested("Compare")
            background: Rectangle { radius: 9; color: compareButton.checked ? root.theme.highlightSurface : compareButton.hovered || compareButton.visualFocus ? root.theme.elevated : "transparent"; border.width: compareButton.visualFocus ? 2 : compareButton.checked ? 1 : 0; border.color: compareButton.visualFocus ? root.theme.brightPurple : compareButton.checked ? root.theme.deepPurple : "transparent" }
            contentItem: RowLayout {
                Icon { name: "compare"; color: root.section === "Compare" ? root.theme.purple : root.theme.muted; iconSize: 17; Layout.leftMargin: 12 }
                Label { text: "Compare Algorithms"; visible: root.windowWidth >= 980 && !root.sidebarCollapsed; color: root.section === "Compare" ? root.theme.purpleText : root.theme.muted; font.pixelSize: 11; Layout.fillWidth: true }
            }
        }
        Button {
            id: settingsButton
            implicitHeight: root.windowHeight < 700 ? 34 : 42
            Layout.fillWidth: true
            padding: 0
            Accessible.name: "Settings"
            onHoveredChanged: {
                if (hovered && (root.sidebarCollapsed || root.windowWidth < 980)) {
                    root.tooltipText = "Settings"
                    root.tooltipCenterY = settingsButton.mapToItem(root, 0, settingsButton.height / 2).y
                } else if (root.tooltipText === "Settings") {
                    root.tooltipText = ""
                }
            }
            onClicked: settingsMenu.open()
            background: Rectangle { radius: 8; color: settingsButton.hovered || settingsButton.visualFocus ? root.theme.elevated : "transparent"; border.width: settingsButton.visualFocus ? 2 : 0; border.color: root.theme.brightPurple }
            contentItem: RowLayout {
                Icon { name: "settings"; color: root.theme.muted; iconSize: 17; Layout.leftMargin: 12 }
                Label { text: "Settings"; visible: root.windowWidth >= 980 && !root.sidebarCollapsed; color: root.theme.muted; font.pixelSize: 11; Layout.fillWidth: true }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 66
            visible: root.windowWidth >= 980 && !root.sidebarCollapsed && root.windowHeight >= 700
            radius: 12; color: root.theme.panel; border.color: root.theme.border
            RowLayout {
                anchors.fill: parent; anchors.margins: 11
                Rectangle { implicitWidth: 34; implicitHeight: 34; radius: 17; color: "#3A235F"; Label { anchors.centerIn: parent; text: "R"; color: "#D8B4FE"; font.bold: true } }
                ColumnLayout {
                    spacing: 2
                    Label { text: "Student Mode"; color: root.theme.text; font.pixelSize: 12; font.bold: true }
                    Label { text: "Offline workspace"; color: root.theme.muted; font.pixelSize: 10 }
                }
            }
        }
    }

    Rectangle {
        visible: root.tooltipText.length > 0
        x: root.width + 8
        y: root.tooltipCenterY - height / 2
        width: tooltipLabel.implicitWidth + 20
        height: 30
        radius: 7
        color: root.theme.elevated
        border.color: root.theme.border
        z: 20

        Label {
            id: tooltipLabel
            anchors.centerIn: parent
            text: root.tooltipText
            color: root.theme.text
            font.pixelSize: 11
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
