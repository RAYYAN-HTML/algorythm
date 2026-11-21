pragma ComponentBehavior: Bound

import QtQuick
import QtTest
import "../qml/components"

Item {
    id: root
    width: 800
    height: 600

    AppTheme { id: appTheme }
    QtObject {
        id: fakeSettings
        property real playbackSpeed: 1.0
        function resetPreferences() { playbackSpeed = 1.0 }
    }

    Component {
        id: sidebarComponent
        NavigationSidebar {
            width: 220
            height: 600
            theme: appTheme
            appSettings: fakeSettings
            windowWidth: 1200
            windowHeight: 800
        }
    }

    SignalSpy {
        id: navigationSpy
        signalName: "navigationRequested"
    }

    TestCase {
        name: "NavigationSidebarTests"
        when: windowShown

        function init() {
            navigationSpy.clear()
            navigationSpy.target = null
        }

        function test_navigationButtonsEmitRequestedSection() {
            const sidebar = createTemporaryObject(sidebarComponent, root)
            verify(!!sidebar, "Navigation sidebar is created")
            navigationSpy.target = sidebar

            const sortingButton = findChild(sidebar, "navigation_Sorting")
            const searchingButton = findChild(sidebar, "navigation_Searching")
            verify(!!sortingButton, "Sorting navigation button exists")
            verify(!!searchingButton, "Searching navigation button exists")
            compare(sortingButton.Accessible.name, "Sorting")

            mouseClick(sortingButton)
            compare(navigationSpy.count, 1)
            compare(navigationSpy.signalArguments[0][0], "Sorting")

            mouseClick(searchingButton)
            compare(navigationSpy.count, 2)
            compare(navigationSpy.signalArguments[1][0], "Searching")
        }
    }
}
