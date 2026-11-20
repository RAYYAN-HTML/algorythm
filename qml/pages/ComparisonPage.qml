import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Item {
    id: page
    property QtObject theme
    property string inputValues: "8, 3, 6, 1, 9, 4, 2"
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 22
        spacing: 14
        RowLayout {
            ColumnLayout {
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
 font.pixelSize: 11 }
            }
            Item { Layout.fillWidth: true }
            TextField { id: data
 text: page.inputValues
 implicitWidth: 190
 color: theme.text
 placeholderText: "shared input" }
            Button { text: "Apply shared input"
 highlighted: true
 onClicked: { page.inputValues = data.text
 playbackA.sortInput(data.text)
 playbackB.sortInput(data.text) } }
        }
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 14
            Repeater {
                model: [playbackA, playbackB]
                delegate: Rectangle {
                    id: card
                    required property var modelData
                    required property int index
                    Layout.fillWidth: true
                    Layout.fillHeight: true
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
 implicitWidth: 140 }
                        }
                        Item {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Repeater {
                                model: modelData.nodes
                                delegate: AlgorithmNode {
                                    required property int index
                                    required property int nodePosition
                                    required property int nodeValue
                                    value: nodeValue
                                    state: nodePosition === card.modelData.activeA || nodePosition === card.modelData.activeB ? "compare" : card.modelData.complete ? "done" : "default"
                                    x: parent.width / 2 - card.modelData.values.length * 34 + nodePosition * 68
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
        Rectangle {
            Layout.fillWidth: true
            height: 76
            radius: 13
            color: theme.panel
            border.color: theme.border
            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                Button { text: "↶ Restart"
 onClicked: { playbackA.restart()
 playbackB.restart() } }
                Button { text: "◀ Step"
 onClicked: { playbackA.previous()
 playbackB.previous() } }
                Button { text: "▶ Run both"
 highlighted: true
 onClicked: { playbackA.playPause()
 playbackB.playPause() } }
                Button { text: "Step ▶"
 onClicked: { playbackA.next()
 playbackB.next() } }
                Item { Layout.fillWidth: true }
                Label { text: playbackA.complete && playbackB.complete ? "Comparison complete — compare the operation counts above." : "Both traces use the same starting input."
 color: theme.muted
 font.pixelSize: 11 }
            }
        }
    }
}
