pragma ComponentBehavior: Bound

import QtQuick
import QtTest
import "../qml/components"

Item {
    id: root
    width: 420
    height: 500

    AppTheme { id: appTheme }

    ListModel { id: variablesModel }

    QtObject {
        id: fakeController
        property var variableEntries: variablesModel
        property var stableVariableNames: []

        function publish(nextVariables) {
            const names = stableVariableNames.length ? stableVariableNames : Object.keys(nextVariables)
            let keysChanged = names.length !== variablesModel.count
            if (!keysChanged) {
                for (let i = 0; i < names.length; ++i) {
                    if (names[i] !== variablesModel.get(i).variableName) {
                        keysChanged = true
                        break
                    }
                }
            }

            if (keysChanged) {
                variablesModel.clear()
                for (const name of names) {
                    const present = Object.prototype.hasOwnProperty.call(nextVariables, name)
                    variablesModel.append({ variableName: name, variableValue: present ? nextVariables[name] : "",
                                            variableVisible: present })
                }
            } else {
                for (let i = 0; i < names.length; ++i) {
                    const present = Object.prototype.hasOwnProperty.call(nextVariables, names[i])
                    variablesModel.setProperty(i, "variableValue", present ? nextVariables[names[i]] : "")
                    variablesModel.setProperty(i, "variableVisible", present)
                }
            }
        }
    }

    Component {
        id: panelComponent
        VariablesPanel {
            width: root.width
            theme: appTheme
            controller: fakeController
        }
    }

    TestCase {
        name: "VariablesPanelTests"
        when: windowShown

        function init() {
            fakeController.stableVariableNames = []
            fakeController.publish({ n: 3, comparisons: 0, swaps: 0, array: "3, 2, 1" })
        }

        function test_stepUpdatesReuseVariableRows() {
            const panel = createTemporaryObject(panelComponent, root)
            verify(!!panel, "Variables panel is created")
            compare(variablesModel.count, 4)

            const comparisonsRow = findChild(panel, "variableRow_comparisons")
            const comparisonsValue = findChild(panel, "variableValue_comparisons")
            verify(!!comparisonsRow, "Comparison row exists")
            verify(!!comparisonsValue, "Comparison value exists")

            fakeController.publish({ n: 3, comparisons: 1, swaps: 1, array: "2, 3, 1" })

            tryCompare(comparisonsValue, "text", "1")
            compare(findChild(panel, "variableRow_comparisons"), comparisonsRow,
                    "Unchanged variable keys retain their row objects")
        }

        function test_algorithmKeyChangesUpdateTheRows() {
            const panel = createTemporaryObject(panelComponent, root)
            verify(!!panel, "Variables panel is created")

            fakeController.publish({ low: 0, high: 2, pivot: 1 })

            tryCompare(variablesModel, "count", 3)
            verify(!!findChild(panel, "variableRow_low"), "New variable row exists")
            verify(!findChild(panel, "variableRow_comparisons"), "Removed variable row is destroyed")
        }

        function test_optionalVariablesHideWithoutReplacingRows() {
            fakeController.stableVariableNames = ["comparisons", "left", "right"]
            fakeController.publish({ comparisons: 1, left: 4 })
            const panel = createTemporaryObject(panelComponent, root)
            verify(!!panel, "Variables panel is created")
            const leftRow = findChild(panel, "variableRow_left")
            const rightRow = findChild(panel, "variableRow_right")
            verify(!!leftRow, "Optional left variable row exists")
            verify(!!rightRow, "Optional right variable row exists")
            compare(leftRow.visible, true)
            compare(rightRow.visible, false)

            fakeController.publish({ comparisons: 2, right: 3 })
            tryCompare(leftRow, "visible", false)
            tryCompare(rightRow, "visible", true)
            compare(findChild(panel, "variableRow_left"), leftRow,
                    "An absent optional variable keeps its delegate instance")
        }
    }
}
