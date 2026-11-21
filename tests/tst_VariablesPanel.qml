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

        function publish(nextVariables) {
            const names = Object.keys(nextVariables)
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
                for (const name of names)
                    variablesModel.append({ variableName: name, variableValue: nextVariables[name] })
            } else {
                for (let i = 0; i < names.length; ++i)
                    variablesModel.setProperty(i, "variableValue", nextVariables[names[i]])
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
    }
}
