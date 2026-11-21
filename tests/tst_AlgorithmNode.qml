pragma ComponentBehavior: Bound

import QtQuick
import QtTest
import "../qml/components"

Item {
    id: root
    property alias testTheme: appTheme
    QtObject {
        id: fakeController
        property string algorithm: "Bubble Sort"
    }
    width: 800
    height: 600

    AppTheme {
        id: appTheme
    }

    Component {
        id: algorithmNodeComponent

        AlgorithmNode {
            theme: root.testTheme
        }
    }

    Component {
        id: complexityPanelComponent

        ComplexityPanel {
            theme: root.testTheme
            controller: fakeController
        }
    }

    Component {
        id: compactComplexityPanelComponent

        ComplexityPanel {
            theme: root.testTheme
            controller: fakeController
            compact: true
        }
    }

    TestCase {
        name: "AlgorithmNodeTests"
        when: windowShown

        function linearChannel(value) {
            return value <= 0.04045 ? value / 12.92 : Math.pow((value + 0.055) / 1.055, 2.4)
        }

        function luminance(color) {
            return 0.2126 * linearChannel(color.r)
                    + 0.7152 * linearChannel(color.g)
                    + 0.0722 * linearChannel(color.b)
        }

        function contrastRatio(foreground, background) {
            const first = luminance(foreground)
            const second = luminance(background)
            return (Math.max(first, second) + 0.05) / (Math.min(first, second) + 0.05)
        }

        function test_defaultValueAndAccessibleLabel() {
            const node = createTemporaryObject(algorithmNodeComponent, root)
            verify(!!node, "AlgorithmNode should be created")
            compare(node.value, 0)
            compare(node.nodeState, "default")
            compare(node.Accessible.name, "Value 0")
            compare(node.Accessible.description, "Unprocessed element")
        }

        function test_stateDescriptionsFollowVisualizationState() {
            const node = createTemporaryObject(algorithmNodeComponent, root, { value: 6 })
            verify(!!node, "AlgorithmNode should be created")

            const cases = [
                ["active", "Current algorithm element"],
                ["compare", "Currently being compared"],
                ["found", "Search target found"],
                ["done", "Completed element"],
                ["default", "Unprocessed element"]
            ]

            for (const [state, description] of cases) {
                node.nodeState = state
                compare(node.Accessible.name, "Value 6")
                compare(node.Accessible.description, description)
            }
        }

        function test_semanticColorsUseThemeRoles() {
            const node = createTemporaryObject(algorithmNodeComponent, root)
            verify(!!node, "AlgorithmNode should be created")
            compare(node.activeFill, appTheme.activeNode)
            compare(node.compareFill, appTheme.compareNode)
            compare(node.foundFill, appTheme.foundNode)
            compare(node.doneFill, appTheme.visitedNode)
            compare(node.idleFill, appTheme.elevated)
        }

        function test_nonTextThemeRolesMeetMinimumContrast() {
            const pairs = [
                [appTheme.graphEdge, appTheme.secondary],
                [appTheme.treeEdge, appTheme.secondary],
                [appTheme.focusOutline, appTheme.secondary],
                [appTheme.nodeOutline, appTheme.elevated]
            ]
            for (const [foreground, background] of pairs)
                verify(contrastRatio(foreground, background) >= 3)
        }

        function test_zeroAnimationDurationAppliesPositionImmediately() {
            const node = createTemporaryObject(algorithmNodeComponent, root)
            verify(!!node, "AlgorithmNode should be created")
            node.animationDuration = 0
            node.x = 120
            tryCompare(node, "x", 120)
        }

        function test_reducedMotionDisablesColorTransitions() {
            const node = createTemporaryObject(algorithmNodeComponent, root)
            verify(!!node, "AlgorithmNode should be created")
            compare(node.colorAnimationDuration, 266)
            appTheme.reducedMotion = true
            compare(node.colorAnimationDuration, 0)
        }

        function test_complexityMetadataMatchesAlgorithms() {
            const panel = createTemporaryObject(complexityPanelComponent, root)
            verify(!!panel, "ComplexityPanel should be created")
            const cases = [
                ["Bubble Sort", "O(n)", "O(n²)", "O(n²)", "O(1)", true, true],
                ["Selection Sort", "O(n²)", "O(n²)", "O(n²)", "O(1)", false, true],
                ["Insertion Sort", "O(n)", "O(n²)", "O(n²)", "O(1)", true, true],
                ["Merge Sort", "O(n log n)", "O(n log n)", "O(n log n)", "O(n)", true, false],
                ["Quick Sort", "O(n log n)", "O(n log n)", "O(n²)", "O(log n) avg · O(n) worst", false, true],
                ["Linear Search", "O(1)", "O(n)", "O(n)", "O(1)", false, false],
                ["Binary Search", "O(n) total · O(1) search", "O(n log n) total · O(log n) search", "O(n log n) total · O(log n) search", "O(1)", false, false]
            ]
            for (const [algorithm, best, average, worst, space, stable, inPlace] of cases) {
                fakeController.algorithm = algorithm
                compare(panel.bestTime, best, algorithm + " best time")
                compare(panel.averageTime, average, algorithm + " average time")
                compare(panel.worstTime, worst, algorithm + " worst time")
                compare(panel.auxiliarySpace, space, algorithm + " auxiliary space")
                compare(panel.isStable, stable, algorithm + " stability")
                compare(panel.isInPlace, inPlace, algorithm + " in-place status")
            }
        }

        function test_compactComplexitySummaryContainsTimeAndSpaceCosts() {
            fakeController.algorithm = "Quick Sort"
            const panel = createTemporaryObject(compactComplexityPanelComponent, root)
            verify(!!panel, "Compact complexity panel should be created")
            const summary = findChild(panel, "compactComplexitySummary")
            verify(!!summary, "Compact summary label exists")
            verify(summary.text.includes("average O(n log n)"))
            verify(summary.text.includes("worst O(n²)"))
            verify(summary.text.includes("Space: O(log n) avg · O(n) worst"))
            verify(summary.text.includes("stable no · in place yes"))
        }

    }
}
