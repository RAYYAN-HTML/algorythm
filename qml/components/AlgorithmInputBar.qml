import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    property QtObject theme
    property var controller
    property string userInput: ""
    property bool inputFocused: false

    signal inputApplied()

    Layout.fillWidth: true
    implicitHeight: 52
    radius: 12
    color: theme.secondary
    border.color: theme.border

    function applyPreset(preset) {
        var values = []
        if (preset === 1) {
            for (var i = 0; i < 7; ++i) values.push(1 + Math.floor(Math.random() * 99))
        } else if (preset === 2) values = [1, 3, 4, 6, 8, 9, 12]
        else if (preset === 3) values = [12, 9, 8, 6, 4, 3, 1]
        else return
        inputField.text = values.join(", ")
        applyInput()
    }

    function applyInput() {
        inputApplied()
        var requestedTarget = Number(targetField.text)
        if (controller.sortInput(inputField.text) && controller.algorithm.endsWith("Search"))
            controller.setSearchTarget(requestedTarget)
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 13
        anchors.rightMargin: 10
        spacing: 9
        Label { text: "Input"; color: root.theme.muted; font.pixelSize: 11 }
        TextField {
            id: inputField
            Layout.fillWidth: true
            text: root.userInput
            onActiveFocusChanged: root.inputFocused = activeFocus
            selectByMouse: true
            Accessible.name: "Algorithm input values"
            color: root.theme.text
            font.family: "Consolas"
            font.pixelSize: 12
            background: Rectangle { radius: 6; color: "#080812"; border.color: root.theme.border }
        }
        ComboBox {
            model: ["Custom", "Random", "Sorted", "Reverse"]
            Accessible.name: "Input preset"
            onActivated: root.applyPreset(index)
            implicitWidth: 100
        }
        TextField {
            id: targetField
            visible: root.controller.algorithm.endsWith("Search")
            Layout.preferredWidth: 72
            text: root.controller.searchTarget.toString()
            validator: IntValidator {}
            Accessible.name: "Search target"
            color: root.theme.text
            placeholderText: "Target"
            background: Rectangle { radius: 6; color: "#080812"; border.color: root.theme.border }
            onAccepted: root.applyInput()
        }
        Button {
            text: root.controller.algorithm.endsWith("Search") ? "Search" : "Apply input"
            Accessible.name: text
            highlighted: true
            onClicked: root.applyInput()
        }
    }
}
