import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Item {
    id: page
    property AppTheme theme
    signal navigate(string section)

    ScrollView {
        id: dashboardScroll
        anchors.fill: parent
        clip: true
        ScrollBar.vertical.policy: ScrollBar.AsNeeded

        ColumnLayout {
            x: 30
            y: 30
            width: Math.max(0, dashboardScroll.availableWidth - 60)
            height: implicitHeight + 30
            spacing: 18

            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: 2
                Label { text: "YOUR DSA WORKSPACE"; color: page.theme.muted; font.pixelSize: 10; font.bold: true; font.letterSpacing: 1.5 }
                Item { Layout.fillWidth: true }
                Label { text: "LEARN · EXPLORE · VISUALIZE"; color: page.theme.subdued; font.pixelSize: 9; font.letterSpacing: 1 }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: page.width < 900 ? 184 : 190
                radius: 20
                color: "#17132A"
                border.color: "#3A2A59"
                clip: true
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#211638" }
                    GradientStop { position: 0.58; color: "#17152A" }
                    GradientStop { position: 1.0; color: "#111321" }
                }
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: page.width < 900 ? 20 : 28
                    spacing: 18
                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.minimumWidth: 0
                        spacing: 9
                        Label { text: "ALGORITHM STUDIO  /  DSA WORKSPACE"; color: page.theme.purple; font.pixelSize: 9; font.bold: true; font.letterSpacing: 1.4 }
                        Label { text: "See every step."; color: page.theme.text; font.pixelSize: page.width < 900 ? 27 : 34; font.bold: true }
                        Label {
                            Layout.fillWidth: true
                            text: "Explore how an algorithm changes data, one operation at a time."
                            color: page.theme.muted; font.pixelSize: 12; wrapMode: Text.WordWrap
                        }
                        Button {
                            text: "Start with sorting"
                            implicitHeight: 38
                            onClicked: page.navigate("Sorting")
                            background: Rectangle {
                                radius: 10
                                gradient: Gradient {
                                    GradientStop { position: 0.0; color: parent.down ? page.theme.deepPurple : parent.hovered ? page.theme.brightPurple : page.theme.purple }
                                    GradientStop { position: 1.0; color: page.theme.deepPurple }
                                }
                                border.color: page.theme.brightPurple
                            }
                            contentItem: RowLayout {
                                Label { text: "Start with sorting"; color: page.theme.textOnAccent; font.pixelSize: 11; font.bold: true; leftPadding: 12 }
                                Icon { name: "arrow-right"; color: page.theme.textOnAccent; iconSize: 15; Layout.rightMargin: 10 }
                            }
                        }
                    }
                    Item {
                        visible: page.width >= 900
                        Layout.preferredWidth: 190
                        Layout.fillHeight: true
                        property var traceValues: [8, 3, 6, 1, 9, 4, 2]
                        property var traceX: [0.08, 0.22, 0.36, 0.50, 0.64, 0.78, 0.92]
                        property var traceY: [0.65, 0.28, 0.58, 0.38, 0.72, 0.33, 0.52]
                        Rectangle { anchors.fill: parent; radius: 16; color: "#100F1D"; border.color: "#33284D" }
                        Label {
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.margins: 13
                            text: "SAMPLE TRACE  ·  7 VALUES"
                            color: page.theme.muted
                            font.pixelSize: 8
                            font.bold: true
                            font.letterSpacing: 1.0
                            z: 2
                        }
                        Canvas {
                            anchors.fill: parent
                            anchors.margins: 12
                            onPaint: {
                                const ctx = getContext("2d")
                                ctx.clearRect(0, 0, width, height)
                                ctx.beginPath()
                                for (let i = 0; i < parent.traceValues.length; ++i) {
                                    const x = parent.traceX[i] * width
                                    const y = 24 + parent.traceY[i] * Math.max(1, height - 38)
                                    if (i === 0) ctx.moveTo(x, y)
                                    else ctx.lineTo(x, y)
                                }
                                ctx.strokeStyle = page.theme.deepPurple
                                ctx.globalAlpha = 0.72
                                ctx.lineWidth = 2
                                ctx.stroke()
                            }
                        }
                        Repeater {
                            model: parent.traceValues
                            delegate: Rectangle {
                                required property int modelData
                                required property int index
                                width: 25
                                height: 25
                                x: 12 + parent.traceX[index] * (parent.width - 24) - width / 2
                                y: 12 + 24 + parent.traceY[index] * Math.max(1, parent.height - 62) - height / 2
                                radius: width / 2
                                color: index === 3 ? page.theme.activeNode : page.theme.elevated
                                border.width: index === 3 ? 2 : 1
                                border.color: index === 3 ? page.theme.purple : page.theme.nodeOutline
                                Label { anchors.centerIn: parent; text: modelData; color: page.theme.text; font.pixelSize: 10; font.bold: true }
                            }
                        }
                    }
                }
            }

            GridLayout {
                Layout.fillWidth: true
                columns: page.width < 820 ? 1 : 3
                columnSpacing: 12
                rowSpacing: 10
                StatCard { theme: page.theme; iconName: "sorting"; value: "07"; caption: "ALGORITHMS TO EXPLORE"; detail: "Five sorting · two searching" }
                StatCard { theme: page.theme; iconName: "dashboard"; value: "07"; caption: "LEARNING LABS"; detail: "Guided, interactive modules" }
                StatCard { theme: page.theme; iconName: "tree"; value: "04"; caption: "STRUCTURE TYPES"; detail: "Lists · stacks · queues · trees" }
            }

            RowLayout {
                Layout.fillWidth: true
                Label { text: "Explore a learning lab"; color: page.theme.text; font.pixelSize: 19; font.bold: true }
                Item { Layout.fillWidth: true }
                Label { text: "07 LEARNING MODULES"; color: page.theme.muted; font.pixelSize: 9; font.letterSpacing: 1 }
            }

            GridLayout {
                Layout.fillWidth: true
                columns: page.width < 820 ? 1 : page.width < 1120 ? 2 : 3
                rowSpacing: 13
                columnSpacing: 13
                Repeater {
                    model: [
                        ["Sorting", "Compare and place values with real step-by-step traces.", "sorting"],
                        ["Searching", "Follow inspections as a search narrows to its target.", "search"],
                        ["Linked Lists", "Insert, remove, search, and traverse connected nodes.", "linked-list"],
                        ["Stacks", "Explore push, pop, and peek using a linked stack.", "stack"],
                        ["Queues", "Track the front and rear as values move through a queue.", "queue"],
                        ["Trees", "Build a binary search tree and inspect its traversals.", "tree"],
                        ["Graphs", "Study BFS, DFS, and nonnegative shortest paths.", "graph"]
                    ]
                    delegate: LabCard {
                        required property var modelData
                        required property int index
                        Layout.preferredHeight: page.width < 900 ? 132 : 150
                        theme: page.theme
                        labName: modelData[0]
                        description: modelData[1]
                        iconName: modelData[2]
                        indexLabel: (index + 1).toString().padStart(2, "0")
                        onActivated: page.navigate(labName)
                    }
                }
            }
        }
    }
}
