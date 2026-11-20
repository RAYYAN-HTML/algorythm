import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Item {
    id: page
    property QtObject theme
    property string userInput: "8, 3, 6, 1, 9, 4, 2"
    property string errorMessage: ""
    property bool focusMode: false
    property bool assistantVisible: true
    property int challengeScore: 0
    property string challengeMessage: ""

    function applyPreset(preset) {
        var values = []
        if (preset === 1) {
            for (var i = 0; i < 7; ++i) values.push(1 + Math.floor(Math.random() * 99))
        } else if (preset === 2) values = [1, 3, 4, 6, 8, 9, 12]
        else if (preset === 3) values = [12, 9, 8, 6, 4, 3, 1]
        else return
        inputField.text = values.join(", ")
        playback.sortInput(inputField.text)
    }

    function answerChallenge(predictedSwap) {
        var shouldSwap = playback.values[playback.activeA] > playback.values[playback.activeB]
        challengeMessage = predictedSwap === shouldSwap
            ? "Correct. " + (shouldSwap ? "The pair is out of order, so Bubble Sort swaps them." : "The pair is already in ascending order, so it stays in place.")
            : "Not quite. " + (shouldSwap ? "The left value is larger, so this pair swaps." : "The left value is smaller, so this pair stays in place.")
        if (predictedSwap === shouldSwap) ++challengeScore
        prediction.close()
        challengeFeedback.open()
    }

    SplitView {
        id: workspaceSplit
        anchors.fill: parent
        anchors.margins: 22
        orientation: Qt.Horizontal
        handle: Rectangle {
            implicitWidth: 6
            color: SplitHandle.pressed ? theme.cyan : SplitHandle.hovered ? "#53647E" : "#26344D"
            radius: 3
            Behavior on color { ColorAnimation { duration: 140 } }
        }
        Component.onCompleted: {
            var savedState = appSettings.workspaceState()
            if (savedState) restoreState(savedState)
        }
        Component.onDestruction: appSettings.saveWorkspaceState(saveState())
        ColumnLayout {
            SplitView.minimumWidth: 420
            SplitView.preferredWidth: page.width - 306
            SplitView.fillWidth: true
 spacing: 16
            RowLayout {
                ColumnLayout { spacing: 4
                    Label { text: "SORTING LAB"
 color: theme.cyan
 font.pixelSize: 10
 font.bold: true
 font.letterSpacing: 1.6 }
                    Label { text: playback.algorithm
 color: theme.text
 font.pixelSize: 25
 font.bold: true }
                    Label { text: playback.algorithm.endsWith("Search") ? "Follow each inspection as the search narrows toward its target." : "Watch adjacent comparisons move larger values toward their final position."
 color: theme.muted
 font.pixelSize: 12 }
                }
                Item { Layout.fillWidth: true }
                ComboBox { model: ["Bubble Sort", "Selection Sort", "Insertion Sort", "Merge Sort", "Quick Sort", "Linear Search", "Binary Search"]
 currentIndex: model.indexOf(playback.algorithm)
 onActivated: playback.selectAlgorithm(currentText)
 implicitWidth: 145 }
                Button { text: "Focus mode"
 checkable: true
 onToggled: page.focusMode = checked
 background: Rectangle { radius: 8
 color: parent.checked ? "#123244" : theme.secondary
 border.color: theme.border }
 contentItem: Text { text: parent.text
 color: parent.checked ? theme.cyan : theme.muted
 font.pixelSize: 11
 horizontalAlignment: Text.AlignHCenter
 verticalAlignment: Text.AlignVCenter } }
                Button { text: page.assistantVisible ? "Hide assistant" : "Show assistant"
                    onClicked: page.assistantVisible = !page.assistantVisible
                    background: Rectangle { radius: 8; color: theme.secondary; border.color: theme.border }
                    contentItem: Text { text: parent.text; color: theme.muted; font.pixelSize: 10; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                }
            }
            Rectangle {
                Layout.fillWidth: true
 Layout.fillHeight: true
 Layout.minimumHeight: 270
                radius: 18
 color: theme.secondary
 border.color: theme.border
 clip: true
                // Subtle canvas grid
                Repeater { model: Math.floor(parent.width / 44)
 delegate: Rectangle { x: index * 44
 width: 1
 height: parent.height
 color: "#182438"
 opacity: 0.48 } }
                Repeater { model: Math.floor(parent.height / 44)
 delegate: Rectangle { y: index * 44
 height: 1
 width: parent.width
 color: "#182438"
 opacity: 0.48 } }
                ColumnLayout {
                    anchors.fill: parent
 anchors.margins: 22
 spacing: 14
                    RowLayout { Layout.fillWidth: true
                        Label { text: "VISUALIZATION CANVAS"
 color: theme.muted
 font.pixelSize: 9
 font.bold: true
 font.letterSpacing: 1.2 }
                        Item { Layout.fillWidth: true }
                        Rectangle { width: 8
 height: 8
 radius: 4
 color: theme.cyan }
                        Label { text: "Active step"
 color: theme.muted
 font.pixelSize: 10 }
                    }
                    Item { Layout.fillHeight: true
 Layout.fillWidth: true
                        Repeater {
                            model: playback.nodes
                            delegate: AlgorithmNode {
                                required property int index
                                required property int nodePosition
                                required property int nodeValue
                                animationDuration: theme.reducedMotion ? 0 : playback.animationDuration
                                value: nodeValue
                                state: nodePosition === playback.activeA || nodePosition === playback.activeB ? "compare" : playback.complete ? "done" : "default"
                                opacity: page.focusMode && playback.activeA >= 0 && nodePosition !== playback.activeA && nodePosition !== playback.activeB ? 0.25 : 1.0
                                x: (parent.width - playback.values.length * Math.min(72, parent.width / playback.values.length) + Math.min(72, parent.width / playback.values.length)) / 2 + nodePosition * Math.min(72, parent.width / playback.values.length) - width / 2
                                y: (parent.height - height) / 2
                                Behavior on opacity { NumberAnimation { duration: theme.reducedMotion ? 0 : playback.animationDuration } }
                            }
                        }
                    }
                    RowLayout { Layout.fillWidth: true
                        Label { text: "●  " + playback.operation
 color: theme.amber
 font.pixelSize: 11
 font.bold: true }
                        Item { Layout.fillWidth: true }
                        Label { visible: playback.algorithm === "Bubble Sort"
 text: "Challenge score " + page.challengeScore
 color: theme.muted
 font.pixelSize: 9 }
                        Button { visible: playback.algorithm === "Bubble Sort" && playback.operation === "Compare neighbors"
 text: "Predict"
 onClicked: prediction.open() }
                        Label { text: playback.complete ? "✓ COMPLETE" : "● RUNNING TRACE"
 color: playback.complete ? theme.green : theme.cyan
 font.pixelSize: 9
 font.bold: true }
                    }
                }
            }
            Rectangle {
                Layout.fillWidth: true
 height: 52
 radius: 12
 color: theme.secondary
 border.color: theme.border
                RowLayout { anchors.fill: parent
 anchors.leftMargin: 13
 anchors.rightMargin: 10
 spacing: 9
                    Label { text: "Input"
 color: theme.muted
 font.pixelSize: 11 }
                    TextField { id: inputField
 Layout.fillWidth: true
 text: page.userInput
 selectByMouse: true
 color: theme.text
 font.family: "Consolas"
 font.pixelSize: 12
 background: Rectangle { radius: 6
 color: "#080C17"
 border.color: theme.border }
 // The adjacent Input label already identifies this field; avoid Material's floating placeholder overlapping populated values.
 }
                    ComboBox { model: ["Custom", "Random", "Sorted", "Reverse"]
 onActivated: page.applyPreset(index)
 implicitWidth: 100 }
                    TextField { id: targetField
 visible: playback.algorithm.endsWith("Search")
 Layout.preferredWidth: 72
 text: playback.searchTarget
 validator: IntValidator {}
 color: theme.text
 placeholderText: "Target"
 background: Rectangle { radius: 6
 color: "#080C17"
 border.color: theme.border } }
                    Button { text: playback.algorithm.endsWith("Search") ? "Search" : "Apply input"
 highlighted: true
 onClicked: { playback.sortInput(inputField.text)
 if (targetField.visible) playback.setSearchTarget(Number(targetField.text))
 page.errorMessage = "" } }
                }
            }
            Label { visible: page.errorMessage !== ""
 text: page.errorMessage
 color: theme.pink
 font.pixelSize: 11 }
            PlaybackControls { Layout.fillWidth: true }
        }

        ScrollView {
            id: assistantScroll
            visible: page.assistantVisible
            SplitView.minimumWidth: page.width < 920 ? 208 : 230
            SplitView.preferredWidth: page.width < 920 ? 230 : page.width < 1120 ? 250 : 284
            SplitView.maximumWidth: 420
            SplitView.fillHeight: true
            clip: true
            ScrollBar.vertical.policy: ScrollBar.AsNeeded
            ColumnLayout {
                width: assistantScroll.availableWidth
                height: Math.max(implicitHeight, assistantScroll.availableHeight)
 spacing: 14
            NarrationPanel { Layout.fillWidth: true }
            PseudocodePanel { Layout.fillWidth: true }
            StatisticsPanel { Layout.fillWidth: true }
            VariablesPanel { Layout.fillWidth: true }
            Rectangle {
                Layout.fillWidth: true
 Layout.fillHeight: true
 Layout.minimumHeight: 90
                color: theme.panel
 radius: 14
 border.color: theme.border
                ColumnLayout { anchors.fill: parent
 anchors.margins: 15
 spacing: 7
                    Label { text: "Complexity"
 color: theme.text
 font.bold: true
 font.pixelSize: 13 }
                    RowLayout { Label { text: "Time"
 color: theme.muted
 font.pixelSize: 10 }
 Item { Layout.fillWidth: true }
 Label { text: playback.algorithm === "Binary Search" ? "O(log n)" : playback.algorithm === "Linear Search" ? "O(n)" : playback.algorithm === "Merge Sort" ? "O(n log n)" : playback.algorithm === "Quick Sort" ? "O(n²) worst" : "O(n²)"
 color: theme.amber
 font.family: "Consolas"
 font.pixelSize: 11 } }
                    RowLayout { Label { text: "Auxiliary space"
 color: theme.muted
 font.pixelSize: 10 }
 Item { Layout.fillWidth: true }
 Label { text: playback.algorithm === "Merge Sort" ? "O(n)" : playback.algorithm === "Quick Sort" ? "O(log n) avg" : "O(1)"
 color: theme.cyan
 font.family: "Consolas"
 font.pixelSize: 11 } }
                    RowLayout { visible: !playback.algorithm.endsWith("Search"); Label { text: "Stable"
 color: theme.muted
 font.pixelSize: 10 }
 Item { Layout.fillWidth: true }
 Label { text: playback.algorithm === "Quick Sort" || playback.algorithm === "Selection Sort" ? "No" : "Yes"
 color: theme.green
 font.pixelSize: 11 } }
                }
            }
            }
        }
    }

    Connections { target: playback
 function onInputError(message) { page.errorMessage = message } }
    Dialog {
        id: prediction
        title: "Predict the operation"
        modal: true
        width: 360
        anchors.centerIn: Overlay.overlay
        standardButtons: Dialog.NoButton
        contentItem: ColumnLayout {
            Label { text: "Should " + playback.values[playback.activeA] + " and " + playback.values[playback.activeB] + " swap?"; color: theme.text; font.pixelSize: 13 }
            Label { text: "Use ascending order to decide."; color: theme.muted; font.pixelSize: 11 }
            RowLayout {
                Button { text: "Yes, swap"; onClicked: page.answerChallenge(true) }
                Button { text: "No, keep order"; onClicked: page.answerChallenge(false) }
            }
        }
    }
    Dialog {
        id: challengeFeedback
        title: "Prediction"
        modal: true
        width: 360
        anchors.centerIn: Overlay.overlay
        standardButtons: Dialog.Ok
        contentItem: Label { text: page.challengeMessage; color: theme.text; wrapMode: Text.WordWrap; padding: 12 }
    }
    Keys.onPressed: event => {
        if (event.isAutoRepeat || inputField.activeFocus) return
        if (event.key === Qt.Key_Space) { playback.playPause()
 event.accepted = true }
        else if (event.key === Qt.Key_Right) { playback.next()
 event.accepted = true }
        else if (event.key === Qt.Key_Left) { playback.previous()
 event.accepted = true }
        else if (event.key === Qt.Key_R) { playback.restart()
 event.accepted = true }
    }
    focus: true
}

