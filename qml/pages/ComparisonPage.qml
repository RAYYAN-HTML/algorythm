import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Item {
    id: page
    property AppTheme theme
    property string inputValues: "8, 3, 6, 1, 9, 4, 2"
    property string inputError: ""

    function applySharedInput() {
        var text = data.text.trim()
        var parts = text.length ? text.split(/[,\s]+/) : []
        if (parts.length === 0 || parts.length > 16 || parts.some(function (part) {
                if (!/^[+-]?\d+$/.test(part)) return true
                var value = Number(part)
                return !Number.isSafeInteger(value) || value < -2147483648 || value > 2147483647
            })) {
            page.inputError = "Enter 1–16 whole numbers in the 32-bit integer range."
            return
        }
        page.inputValues = text
        page.inputError = ""
        playbackA.sortInput(text)
        playbackB.sortInput(text)
    }

    function toggleBothPlayback() {
        var shouldRun = !(playbackA.playing && playbackB.playing)
        if (shouldRun) {
            if (playbackA.complete) playbackA.restart()
            if (playbackB.complete) playbackB.restart()
            playbackA.startPlayback()
            playbackB.startPlayback()
        } else {
            playbackA.pausePlayback()
            playbackB.pausePlayback()
        }
    }

    Keys.onPressed: event => {
        if (event.isAutoRepeat || data.activeFocus || event.accepted) return
        if (event.key === Qt.Key_Space) {
            page.toggleBothPlayback()
            event.accepted = true
        } else if (event.key === Qt.Key_Right) {
            playbackA.next()
            playbackB.next()
            event.accepted = true
        } else if (event.key === Qt.Key_Left) {
            playbackA.previous()
            playbackB.previous()
            event.accepted = true
        } else if (event.key === Qt.Key_R) {
            playbackA.restart()
            playbackB.restart()
            event.accepted = true
        }
    }

    focus: true
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 22
        spacing: 14
        RowLayout {
            ColumnLayout {
                Layout.minimumWidth: 0
                Layout.preferredWidth: Math.min(page.width < 900 ? 250 : 496, page.width * 0.42)
                Layout.maximumWidth: page.width < 900 ? 250 : 496
                Label { text: "ALGORITHM ARENA"
 color: theme.purpleText
 font.pixelSize: 10
 font.bold: true
 font.letterSpacing: 1.5 }
                Label { text: "Compare algorithms"
 color: theme.text
 font.pixelSize: 25
 font.bold: true }
                Label { text: "Operation counts are the comparison. Animation time is only presentation pacing."
 color: theme.muted
 font.pixelSize: 11
 Layout.fillWidth: true
 wrapMode: Text.WordWrap }
            }
            Item { Layout.fillWidth: true }
            TextField { id: data
 text: page.inputValues
 Layout.preferredWidth: page.width < 900 ? 140 : 190
 Layout.minimumWidth: 120
 color: theme.text
 placeholderText: "shared input" }
            Button { text: page.width < 900 ? "Apply input" : "Apply shared input"
 highlighted: true
 onClicked: page.applySharedInput() }
        }
        Label { Layout.fillWidth: true; visible: page.inputError !== ""; text: page.inputError; color: theme.error; font.pixelSize: 11 }
        ScrollView {
            id: cardsScroll
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            ScrollBar.vertical.policy: ScrollBar.AsNeeded
            Flow {
                width: cardsScroll.availableWidth
                height: childrenRect.height
                spacing: 14
                Repeater {
                    model: [playbackA, playbackB]
                    delegate: Rectangle {
                    id: card
                    required property var modelData
                    required property int index
                    width: page.width < 900 ? cardsScroll.availableWidth : (cardsScroll.availableWidth - 14) / 2
                    height: page.width < 900 ? 320 : Math.min(460, Math.max(360, page.height * 0.48))
                    radius: 16
                    color: theme.secondary
                    border.color: theme.border
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 12
                        RowLayout {
                            Label { text: index === 0 ? "ALGORITHM A" : "ALGORITHM B"
 color: index === 0 ? theme.purpleText : "#D8B4FE"
 font.pixelSize: 9
 font.bold: true }
                            Item { Layout.fillWidth: true }
                            ComboBox { model: ["Bubble Sort", "Selection Sort", "Insertion Sort", "Merge Sort", "Quick Sort"]
 currentIndex: model.indexOf(modelData.algorithm)
 onActivated: modelData.selectAlgorithm(currentText)
 implicitWidth: page.width < 900 ? 112 : 140 }
                        }
                        Item {
                            id: visualArea
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.preferredWidth: Math.max(1, card.width - 32)
                            Layout.preferredHeight: 180
                            Layout.minimumHeight: 90
                            Repeater {
                                model: modelData.nodes
                                delegate: AlgorithmNode {
                                    id: compareNode
                                    required property int index
                                    required property int nodePosition
                                    required property int nodeValue
                                    readonly property int displayPosition: card.modelData.stepIndex === 0 ? index : nodePosition
                                    animationDuration: theme.reducedMotion || card.modelData.stepIndex === 0 ? 0 : card.modelData.animationDuration
                                    theme: page.theme
                                    value: nodeValue
                                    nodeState: card.modelData.complete ? "done" : displayPosition === card.modelData.activeA ? "active" : displayPosition === card.modelData.activeB ? "compare" : "default"
                                    readonly property real traceWidth: Math.max(1, (page.width < 900 ? cardsScroll.availableWidth : (cardsScroll.availableWidth - 14) / 2) - 32)
                                    readonly property real nodeGap: Math.min(68, Math.max(0, (traceWidth - width) / Math.max(1, card.modelData.values.length - 1)))
                                    x: card.modelData.values.length <= 1 ? (traceWidth - width) / 2 : (traceWidth - (card.modelData.values.length - 1) * nodeGap - width) / 2 + displayPosition * nodeGap
                                    y: (visualArea.height - height) / 2
                                }
                            }
                        }
                        Label { Layout.fillWidth: true
 wrapMode: Text.WordWrap
 text: modelData.narration
 color: theme.muted
 font.pixelSize: 10 }
                        RowLayout {
                            Layout.fillWidth: true
                            Label { text: "Comparisons  " + modelData.comparisons
 color: theme.amber
 font.pixelSize: 11 }
                            Item { Layout.fillWidth: true }
                            Label { text: "Swaps  " + modelData.swaps
 color: theme.brightPurple
 font.pixelSize: 11 }
                        }
                        ProgressBar { Layout.fillWidth: true
 from: 0
 to: Math.max(1, modelData.stepCount - 1)
 value: modelData.stepIndex }
                        ComplexityPanel {
                            theme: page.theme
                            controller: modelData
                            compact: true
                        }
                    }
                }
            }
            }
        }
        ComparisonPlaybackControls {
            theme: page.theme
            controllerA: playbackA
            controllerB: playbackB
            settingsController: appSettings
            onPlayPauseRequested: page.toggleBothPlayback()
        }
    }
}
