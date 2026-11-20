import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Item {
    id: page
    property QtObject theme
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
 color: theme.cyan
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
        Label { Layout.fillWidth: true; visible: page.inputError !== ""; text: page.inputError; color: theme.pink; font.pixelSize: 11 }
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
                    height: page.width < 900 ? 270 : 360
                    radius: 16
                    color: theme.secondary
                    border.color: index === 0 ? "#1A5264" : "#54356E"
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 12
                        RowLayout {
                            Label { text: index === 0 ? "ALGORITHM A" : "ALGORITHM B"
 color: index === 0 ? theme.cyan : "#D8B4FE"
 font.pixelSize: 9
 font.bold: true }
                            Item { Layout.fillWidth: true }
                            ComboBox { model: ["Bubble Sort", "Selection Sort", "Insertion Sort", "Merge Sort", "Quick Sort"]
 currentIndex: model.indexOf(modelData.algorithm)
 onActivated: modelData.selectAlgorithm(currentText)
 implicitWidth: page.width < 900 ? 112 : 140 }
                        }
                        Item {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.minimumHeight: 90
                            Repeater {
                                model: modelData.nodes
                                delegate: AlgorithmNode {
                                    id: compareNode
                                    required property int index
                                    required property int nodePosition
                                    required property int nodeValue
                                    value: nodeValue
                                    state: nodePosition === card.modelData.activeA || nodePosition === card.modelData.activeB ? "compare" : card.modelData.complete ? "done" : "default"
                                    readonly property real nodeGap: Math.min(68, Math.max(0, (parent.width - width) / Math.max(1, card.modelData.values.length - 1)))
                                    x: card.modelData.values.length <= 1 ? (parent.width - width) / 2 : (parent.width - (card.modelData.values.length - 1) * nodeGap - width) / 2 + nodePosition * nodeGap
                                    y: parent.height / 2
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
 color: theme.pink
 font.pixelSize: 11 }
                        }
                        ProgressBar { Layout.fillWidth: true
 from: 0
 to: Math.max(1, modelData.stepCount - 1)
 value: modelData.stepIndex }
                    }
                }
            }
            }
        }
        Rectangle {
            Layout.fillWidth: true
            height: 76
            radius: 13
            color: theme.panel
            border.color: theme.border
            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                Button { Accessible.name: "Restart both"; onClicked: { playbackA.restart(); playbackB.restart() }
                    contentItem: RowLayout {
                        Icon { name: "restart"; color: theme.muted; iconSize: 16 }
                        Label { text: "Restart"; color: theme.text }
                    }
                }
                Button { Accessible.name: "Previous step both"; onClicked: { playbackA.previous(); playbackB.previous() }
                    contentItem: RowLayout {
                        Icon { name: "previous"; color: theme.muted; iconSize: 16 }
                        Label { text: "Step"; color: theme.text }
                    }
                }
                Button { Accessible.name: playbackA.playing && playbackB.playing ? "Pause both" : "Run both"
                    highlighted: true
                    onClicked: page.toggleBothPlayback()
                    contentItem: RowLayout {
                        Icon { name: playbackA.playing && playbackB.playing ? "pause" : "play"; color: "#06111F"; iconSize: 15 }
                        Label { text: playbackA.playing && playbackB.playing ? "Pause both" : "Run both"; color: "#06111F"; font.bold: true }
                    }
                }
                Button { Accessible.name: "Next step both"; onClicked: { playbackA.next(); playbackB.next() }
                    contentItem: RowLayout {
                        Label { text: "Step"; color: theme.text }
                        Icon { name: "next"; color: theme.muted; iconSize: 16 }
                    }
                }
                Item { Layout.fillWidth: true }
                Label { text: playbackA.complete && playbackB.complete ? "Comparison complete — compare the operation counts above." : "Both traces use the same starting input."
 color: theme.muted
 font.pixelSize: 11 }
            }
        }
    }
}
