import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Item {
    id: page
    property QtObject theme
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

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: page.width < 900 ? 184 : 190
                radius: 20
                color: "#101C2E"
                border.color: "#263B56"
                clip: true
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: page.width < 900 ? 20 : 28
                    spacing: 18
                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.minimumWidth: 0
                        spacing: 9
                        Label { text: "ALGORITHM STUDIO  /  DSA WORKSPACE"; color: page.theme.cyan; font.pixelSize: 9; font.bold: true; font.letterSpacing: 1.4 }
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
                            background: Rectangle { radius: 9; color: parent.down ? "#0891B2" : parent.hovered ? "#22D3EE" : "#06B6D4"; border.color: "#67E8F9" }
                            contentItem: RowLayout {
                                Label { text: "Start with sorting"; color: "#06111F"; font.pixelSize: 11; font.bold: true; leftPadding: 12 }
                                Icon { name: "arrow-right"; color: "#06111F"; iconSize: 15; Layout.rightMargin: 10 }
                            }
                        }
                    }
                    Item {
                        visible: page.width >= 900
                        Layout.preferredWidth: 190
                        Layout.fillHeight: true
                        Rectangle { anchors.fill: parent; radius: 16; color: "#0B1422"; border.color: "#1D3047" }
                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 16
                            RowLayout {
                                Label { text: "TRACE"; color: page.theme.muted; font.pixelSize: 8; font.bold: true; font.letterSpacing: 1.2 }
                                Item { Layout.fillWidth: true }
                                Label { text: "07 ITEMS"; color: page.theme.cyan; font.pixelSize: 8; font.family: "Consolas" }
                            }
                            RowLayout {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                spacing: 6
                                Repeater {
                                    model: [38, 66, 48, 82, 56, 72, 44]
                                    delegate: Rectangle {
                                        required property int modelData
                        required property int index
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        Layout.maximumHeight: 86
                                        Layout.alignment: Qt.AlignBottom
                                        height: modelData
                                        radius: 5
                                        color: index === 3 ? page.theme.cyan : index % 2 ? "#5A42A2" : "#313B65"
                                        opacity: index === 3 ? 1 : 0.72
                                    }
                                }
                            }
                            Label { text: "COMPARE     ·     SWAP     ·     SORT"; color: page.theme.muted; font.pixelSize: 7; font.family: "Consolas"; Layout.alignment: Qt.AlignHCenter }
                        }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Label { text: "Choose a lab"; color: page.theme.text; font.pixelSize: 19; font.bold: true }
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
