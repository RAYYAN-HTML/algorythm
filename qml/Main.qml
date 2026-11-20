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
    Material.accent: "#8B5CF6"
    Material.primary: "#A855F7"
    Material.foreground: "#F8FAFC"
    Material.background: "#0D0D1A"

    property string section: "Dashboard"
    property QtObject settingsController: appSettings
    property bool sidebarCollapsed: appSettings.sidebarCollapsed
    property bool reducedMotion: appSettings.reducedMotion

    function navigateSection(destination) {
        section = destination
        if (destination === "Searching") playback.selectAlgorithm("Linear Search")
        else if (destination === "Sorting") playback.selectAlgorithm("Bubble Sort")
        else if (destination === "Linked Lists") structures.kind = "Linked List"
        else if (destination === "Stacks") structures.kind = "Stack"
        else if (destination === "Queues") structures.kind = "Queue"
        else if (destination === "Trees") structures.kind = "Binary Search Tree"
    }

    onReducedMotionChanged: appSettings.reducedMotion = reducedMotion
    onSidebarCollapsedChanged: appSettings.sidebarCollapsed = sidebarCollapsed

    Component.onCompleted: {
        playback.speed = appSettings.playbackSpeed
        playbackA.speed = appSettings.playbackSpeed
        playbackB.speed = appSettings.playbackSpeed
        graph.speed = appSettings.playbackSpeed
    }

    Connections {
        target: appSettings
        function onPlaybackSpeedChanged() {
            playback.speed = appSettings.playbackSpeed
            playbackA.speed = appSettings.playbackSpeed
            playbackB.speed = appSettings.playbackSpeed
            graph.speed = appSettings.playbackSpeed
        }
    }

    QtObject {
        id: appColors
        readonly property color background: "#080812"
        readonly property color secondary: "#0D0D1A"
        readonly property color panel: "#17172A"
        readonly property color elevated: "#1A1930"
        readonly property color border: "#29243E"
        readonly property color purple: "#8B5CF6"
        readonly property color brightPurple: "#A855F7"
        readonly property color deepPurple: "#6D28D9"
        readonly property color glowPurple: "#9333EA"
        readonly property color amber: "#FBBF24"
        readonly property color green: "#34D399"
        readonly property color error: "#F87171"
        readonly property color info: "#38BDF8"
        readonly property color text: "#F8FAFC"
        readonly property color muted: "#A1A1B5"
        readonly property color subdued: "#71718A"
        readonly property bool reducedMotion: window.reducedMotion
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        NavigationSidebar {
            theme: appColors
            appSettings: window.settingsController
            section: window.section
            sidebarCollapsed: window.sidebarCollapsed
            reducedMotion: window.reducedMotion
            windowWidth: window.width
            windowHeight: window.height
            onNavigationRequested: destination => window.navigateSection(destination)
            onCollapseRequested: window.sidebarCollapsed = !window.sidebarCollapsed
            onReducedMotionToggled: enabled => window.reducedMotion = enabled
            onSidebarCollapsedToggled: enabled => window.sidebarCollapsed = enabled
            onDefaultsRestored: {
                window.reducedMotion = false
                window.sidebarCollapsed = false
                playback.speed = 1.0
                playbackA.speed = 1.0
                playbackB.speed = 1.0
                graph.speed = 1.0
            }
        }

        StackLayout {
            id: pages
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: window.section === "Dashboard" ? 0 : ["Linked Lists", "Stacks", "Queues", "Trees"].includes(window.section) ? 2 : window.section === "Compare" ? 3 : window.section === "Graphs" ? 4 : 1
            DashboardPage { theme: appColors; onNavigate: destination => window.navigateSection(destination) }
            SortingPage { theme: appColors }
            StructurePage { theme: appColors }
            ComparisonPage { theme: appColors }
            GraphPage { theme: appColors }
        }
    }
}
