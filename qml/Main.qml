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
    Material.accent: appColors.purple
    Material.primary: appColors.action
    Material.foreground: appColors.text
    Material.background: appColors.secondary

    property string section: "Dashboard"
    property QtObject settingsController: appSettings
    property bool sidebarCollapsed: appSettings.sidebarCollapsed
    property bool reducedMotion: appSettings.reducedMotion

    function navigateSection(destination, recordActivity) {
        section = destination
        if (destination === "Searching") playback.selectAlgorithm("Linear Search")
        else if (destination === "Sorting") playback.selectAlgorithm("Bubble Sort")
        else if (destination === "Linked Lists") structures.kind = "Linked List"
        else if (destination === "Stacks") structures.kind = "Stack"
        else if (destination === "Queues") structures.kind = "Queue"
        else if (destination === "Trees") structures.kind = "Binary Search Tree"
        if (recordActivity !== false && (destination === "Sorting" || destination === "Searching")) {
            appSettings.recordRecentActivity({ section: destination, algorithm: playback.algorithm })
        } else if (recordActivity !== false && destination === "Graphs") {
            appSettings.recordRecentActivity({ section: destination, algorithm: graph.algorithm, graph: graph.configuration() })
        }
    }

    function resumeRecent(activity) {
        if (activity.section === "Sorting" || activity.section === "Searching") {
            navigateSection(activity.section, false)
            if (sortingPage.item === null) sortingPage.active = true
            if (sortingPage.item === null) return
            sortingPage.item.userInput = activity.input || sortingPage.item.userInput
            playback.selectAlgorithm(activity.algorithm)
            if (activity.input && playback.sortInput(activity.input) && activity.algorithm.endsWith("Search") && activity.target !== undefined)
                playback.setSearchTarget(activity.target)
        } else if (activity.section === "Graphs") {
            navigateSection("Graphs", false)
            if (graphPage.item === null) graphPage.active = true
            graph.algorithm = activity.algorithm
            if (activity.graph) {
                graph.restoreConfiguration(activity.graph)
                graphPage.item.startNode = activity.graph.startNode
                graphPage.item.destinationNode = Math.max(0, Math.min(activity.graph.destinationNode === undefined ? graphPage.item.destinationNode : activity.graph.destinationNode, graph.nodeCount - 1))
            }
        }
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

    AppTheme {
        id: appColors
        reducedMotion: window.reducedMotion
    }

    Component {
        id: comparisonPageComponent
        ComparisonPage { theme: appColors }
    }
    Component {
        id: sortingPageComponent
        SortingPage { theme: appColors }
    }
    Component {
        id: structurePageComponent
        StructurePage { theme: appColors }
    }
    Component {
        id: graphPageComponent
        GraphPage { theme: appColors }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        NavigationSidebar {
            id: navigationSidebar
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
            Layout.minimumWidth: 0
            Layout.preferredWidth: Math.max(0, window.width - navigationSidebar.sidebarWidth)
            Layout.maximumWidth: Math.max(0, window.width - navigationSidebar.sidebarWidth)
            clip: true
            currentIndex: window.section === "Dashboard" ? 0 : ["Linked Lists", "Stacks", "Queues", "Trees"].includes(window.section) ? 2 : window.section === "Compare" ? 3 : window.section === "Graphs" ? 4 : 1
            DashboardPage {
                theme: appColors
                recentActivities: appSettings.recentActivities
                onNavigate: destination => window.navigateSection(destination)
                onResumeRecent: activity => window.resumeRecent(activity)
            }
            Loader {
                id: sortingPage
                property bool activatedOnce: false
                Layout.fillWidth: true
                Layout.fillHeight: true
                active: pages.currentIndex === 1 || activatedOnce
                sourceComponent: sortingPageComponent
                onLoaded: activatedOnce = true
            }
            Loader {
                property bool activatedOnce: false
                Layout.fillWidth: true
                Layout.fillHeight: true
                active: pages.currentIndex === 2 || activatedOnce
                sourceComponent: structurePageComponent
                onLoaded: activatedOnce = true
            }
            Loader {
                property bool activatedOnce: false
                Layout.fillWidth: true
                Layout.fillHeight: true
                active: pages.currentIndex === 3 || activatedOnce
                sourceComponent: comparisonPageComponent
                onLoaded: activatedOnce = true
            }
            Loader {
                id: graphPage
                property bool activatedOnce: false
                Layout.fillWidth: true
                Layout.fillHeight: true
                active: pages.currentIndex === 4 || activatedOnce
                sourceComponent: graphPageComponent
                onLoaded: activatedOnce = true
            }
        }
    }
}
