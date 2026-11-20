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
    property bool assistantVisible: page.width >= 980

    SplitView {
        id: workspaceSplit
        anchors.fill: parent
        anchors.margins: 22
        orientation: page.width < 980 ? Qt.Vertical : Qt.Horizontal
        handle: Rectangle {
            implicitWidth: 6
            implicitHeight: 6
            color: SplitHandle.pressed ? theme.purple : SplitHandle.hovered ? "#53647E" : "#29243E"
            radius: 3
            Behavior on color { ColorAnimation { duration: 140 } }
        }
        Component.onCompleted: {
            var savedState = appSettings.workspaceState()
            if (savedState && orientation === Qt.Horizontal) restoreState(savedState)
        }
        Component.onDestruction: if (orientation === Qt.Horizontal) appSettings.saveWorkspaceState(saveState())
        ColumnLayout {
            SplitView.minimumWidth: workspaceSplit.orientation === Qt.Horizontal ? 420 : 0
            SplitView.minimumHeight: workspaceSplit.orientation === Qt.Vertical ? 420 : 0
            SplitView.preferredWidth: page.width - 306
            SplitView.preferredHeight: page.height - 190
            SplitView.fillWidth: workspaceSplit.orientation === Qt.Vertical
            SplitView.fillHeight: workspaceSplit.orientation === Qt.Horizontal
 spacing: 16
            ColumnLayout {
                spacing: 10
                RowLayout {
                    ColumnLayout { spacing: 4
                    Label { text: "SORTING LAB"
 color: theme.purple
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
                }
                RowLayout {
                    ComboBox { model: ["Bubble Sort", "Selection Sort", "Insertion Sort", "Merge Sort", "Quick Sort", "Linear Search", "Binary Search"]
 currentIndex: model.indexOf(playback.algorithm)
 onActivated: playback.selectAlgorithm(currentText)
 implicitWidth: 145 }
                    Button { text: "Focus mode"
 checkable: true
 onToggled: page.focusMode = checked
 background: Rectangle { radius: 8
 color: parent.checked ? "#30204E" : theme.secondary
 border.color: theme.border }
 contentItem: Text { text: parent.text
 color: parent.checked ? theme.purple : theme.muted
 font.pixelSize: 11
 horizontalAlignment: Text.AlignHCenter
 verticalAlignment: Text.AlignVCenter } }
                    Button { text: page.assistantVisible ? "Hide assistant" : "Show assistant"
                    onClicked: page.assistantVisible = !page.assistantVisible
                    background: Rectangle { radius: 8; color: theme.secondary; border.color: theme.border }
                    contentItem: Text { text: parent.text; color: theme.muted; font.pixelSize: 10; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                }
                    Item { Layout.fillWidth: true }
                }
            }
            Rectangle {
                Layout.fillWidth: true
 Layout.fillHeight: true
 Layout.minimumHeight: page.width < 980 ? 190 : 270
                radius: 18
 color: theme.secondary
 border.color: theme.border
 clip: true
                // Subtle canvas grid
                Repeater { model: Math.floor(parent.width / 44)
 delegate: Rectangle { x: index * 44
 width: 1
 height: parent.height
 color: "#1A1930"
 opacity: 0.48 } }
                Repeater { model: Math.floor(parent.height / 44)
 delegate: Rectangle { y: index * 44
 height: 1
 width: parent.width
 color: "#1A1930"
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
 color: theme.purple }
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
                                state: playback.complete ? "done" : nodePosition === playback.activeA ? "active" : nodePosition === playback.activeB ? "compare" : "default"
                                opacity: page.focusMode && playback.activeA >= 0 && nodePosition !== playback.activeA && nodePosition !== playback.activeB ? 0.25 : 1.0
                                x: (parent.width - playback.values.length * Math.min(72, parent.width / playback.values.length) + Math.min(72, parent.width / playback.values.length)) / 2 + nodePosition * Math.min(72, parent.width / playback.values.length) - width / 2
                                y: (parent.height - height) / 2
                                Behavior on opacity { NumberAnimation { duration: theme.reducedMotion ? 0 : playback.animationDuration } }
                            }
                        }
                    }
                    RowLayout { Layout.fillWidth: true
                        Label { text: "Step: " + playback.operation
 color: theme.amber
 font.pixelSize: 11
 font.bold: true }
                        Item { Layout.fillWidth: true }
                        Label { visible: playback.algorithm === "Bubble Sort"
 text: "Challenge score " + challenge.score
 color: theme.muted
 font.pixelSize: 9 }
                        Button { visible: playback.algorithm === "Bubble Sort" && playback.operation === "Compare neighbors"
 text: "Predict"
 onClicked: challenge.openPrediction() }
                        Label { text: playback.complete ? "COMPLETE" : "RUNNING TRACE"
 color: playback.complete ? theme.green : theme.purple
 font.pixelSize: 9
 font.bold: true }
                    }
                }
            }
            AlgorithmInputBar {
                id: inputBar
                theme: page.theme
                controller: playback
                userInput: page.userInput
                onInputApplied: page.errorMessage = ""
            }
            Label { visible: page.errorMessage !== ""
 text: page.errorMessage
 color: theme.error
 font.pixelSize: 11 }
            PlaybackControls { Layout.fillWidth: true }
        }

        ScrollView {
            id: assistantScroll
            visible: page.assistantVisible
            SplitView.minimumWidth: workspaceSplit.orientation === Qt.Horizontal ? (page.width < 920 ? 208 : 230) : 0
            SplitView.preferredWidth: page.width < 920 ? 230 : page.width < 1120 ? 250 : 284
            SplitView.minimumHeight: workspaceSplit.orientation === Qt.Vertical ? 170 : 0
            SplitView.preferredHeight: 220
            SplitView.maximumWidth: 420
            SplitView.fillWidth: workspaceSplit.orientation === Qt.Vertical
            SplitView.fillHeight: workspaceSplit.orientation === Qt.Horizontal
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
            ComplexityPanel { theme: page.theme; controller: playback }
            }
        }
    }

    Connections { target: playback
 function onInputError(message) { page.errorMessage = message } }
    PredictionChallenge { id: challenge; theme: page.theme; controller: playback }
    Keys.onPressed: event => {
        if (event.isAutoRepeat || inputBar.inputFocused) return
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

