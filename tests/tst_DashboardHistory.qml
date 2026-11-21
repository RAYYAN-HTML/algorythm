pragma ComponentBehavior: Bound

import QtQuick
import QtTest
import "../qml/components"
import "../qml/pages"

Item {
    id: root
    width: 1000
    height: 800
    property var activities: []

    AppTheme { id: appTheme }
    Component {
        id: dashboardComponent
        DashboardPage {
            width: root.width
            height: root.height
            theme: appTheme
            recentActivities: root.activities
        }
    }
    SignalSpy { id: resumeSpy; signalName: "resumeRecent" }

    TestCase {
        name: "DashboardHistoryTests"
        when: windowShown

        function init() {
            root.width = 1000
            root.height = 800
            root.activities = []
            resumeSpy.target = null
            resumeSpy.clear()
        }

        function test_emptyHistoryShowsHelpfulMessage() {
            const dashboard = createTemporaryObject(dashboardComponent, root)
            verify(!!dashboard, "Dashboard is created")
            const emptyState = findChild(dashboard, "emptyRecentActivities")
            verify(!!emptyState, "History empty state exists")
            compare(emptyState.visible, true)
        }

        function test_recentActivityResumesWithItsConfiguration() {
            root.activities = [{ section: "Searching", algorithm: "Binary Search", input: "1, 3, 8", target: 3 }]
            const dashboard = createTemporaryObject(dashboardComponent, root)
            verify(!!dashboard, "Dashboard is created")
            resumeSpy.target = dashboard
            const recentActivity = findChild(dashboard, "recentActivity_0")
            verify(!!recentActivity, "Recent activity control exists")
            compare(recentActivity.Accessible.name, "Resume Binary Search in Searching")

            mouseClick(recentActivity)

            compare(resumeSpy.count, 1)
            compare(resumeSpy.signalArguments[0][0].algorithm, "Binary Search")
            compare(resumeSpy.signalArguments[0][0].input, "1, 3, 8")
            compare(resumeSpy.signalArguments[0][0].target, 3)
        }

        function test_graphActivityShowsSavedGraphConfiguration() {
            root.activities = [{
                section: "Graphs",
                algorithm: "Dijkstra's Shortest Path",
                graph: { nodeCount: 8, startNode: 2, destinationNode: 6, edges: [{ from: 0, to: 1, weight: 4 }] }
            }]
            const dashboard = createTemporaryObject(dashboardComponent, root)
            verify(!!dashboard, "Dashboard is created")
            const details = findChild(dashboard, "recentActivityDetails_0")
            verify(!!details, "Graph configuration summary exists")
            compare(details.text, "8 nodes · 1 edge · start 2 · destination 6")
        }

        function test_dashboardCardsReflowAtNarrowAndWideWidths() {
            const dashboard = createTemporaryObject(dashboardComponent, root)
            verify(!!dashboard, "Dashboard is created")
            const stats = findChild(dashboard, "dashboardStatsGrid")
            verify(!!stats, "Dashboard statistics grid exists")

            root.width = 700
            tryCompare(stats, "columns", 1)
            root.width = 840
            tryCompare(stats, "columns", 2)
            root.width = 1500
            tryCompare(stats, "columns", 3)
        }

        function test_dashboardReflowsAtRequestedWindowWidths() {
            const dashboard = createTemporaryObject(dashboardComponent, root)
            verify(!!dashboard, "Dashboard is created")
            const stats = findChild(dashboard, "dashboardStatsGrid")
            verify(!!stats, "Dashboard statistics grid exists")
            const widths = [800, 1024, 1280, 1366, 1920]
            const expectedColumns = [1, 2, 2, 2, 3]
            for (let i = 0; i < widths.length; ++i) {
                root.width = widths[i]
                tryCompare(stats, "columns", expectedColumns[i])
                tryVerify(function() { return stats.width <= dashboard.width }, 1000,
                          "Statistics grid stays within the page at " + widths[i] + " px")
            }
        }
    }
}
