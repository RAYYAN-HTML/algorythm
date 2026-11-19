import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: page
    property QtObject theme
    property int itemValue: 12
    property int position: 0
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 28
        spacing: 18
        RowLayout {
            ColumnLayout {
                Label { text: "DATA STRUCTURES"
 color: theme.cyan
 font.pixelSize: 10
 font.bold: true
 font.letterSpacing: 1.5 }
                Label { text: structures.kind
 color: theme.text
 font.pixelSize: 25
 font.bold: true }
                Label { text: "Explore operations and observe how the structure changes."
 color: theme.muted
 font.pixelSize: 12 }
            }
            Item { Layout.fillWidth: true }
            ComboBox { model: ["Linked List", "Stack", "Queue", "Binary Search Tree"]
 currentIndex: model.indexOf(structures.kind)
 onActivated: structures.kind = currentText }
        }
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 18
            color: theme.secondary
            border.color: theme.border
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 26
                spacing: 20
                RowLayout {
                    Label { text: "LIVE STRUCTURE"
 color: theme.muted
 font.pixelSize: 10
 font.bold: true
 font.letterSpacing: 1.2 }
                    Item { Layout.fillWidth: true }
                    Label { text: "SIZE  " + structures.size
 color: theme.cyan
 font.pixelSize: 11
 font.bold: true }
                }
                Item { Layout.fillWidth: true
 Layout.fillHeight: true
 Layout.minimumHeight: 250
                    RowLayout {
                        visible: structures.kind === "Linked List" || structures.kind === "Queue"
                        anchors.centerIn: parent
                        spacing: 10
                        Label { visible: structures.values.length > 0; text: structures.kind === "Queue" ? "FRONT →" : "HEAD →"; color: theme.cyan; font.pixelSize: 9; font.bold: true }
                        Repeater {
                            model: structures.values
                            delegate: RowLayout {
                                required property var modelData
                                required property int index
                                spacing: 8
                                Rectangle {
                                    width: 62
 height: 62
 radius: 31
                                    color: "#211B39"
 border.width: 2
 border.color: index === 0 ? theme.cyan : theme.purple
                                    scale: 1
                                    Behavior on scale { NumberAnimation { duration: 220
 easing.type: Easing.OutBack } }
                                    Label { anchors.centerIn: parent
 text: modelData
 color: theme.text
 font.pixelSize: 18
 font.bold: true }
                                }
                                Label { visible: index < structures.values.length - 1
 text: "→"
 color: theme.cyan
 font.pixelSize: 20 }
                            }
                        }
                        Label { visible: structures.values.length > 0; text: structures.kind === "Queue" ? "← REAR" : "TAIL"; color: theme.pink; font.pixelSize: 9; font.bold: true }
                    }
                    ColumnLayout {
                        visible: structures.kind === "Stack"
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 8
                        Label { visible: structures.values.length > 0
 text: "TOP ↓"
 color: theme.pink
 font.pixelSize: 10
 font.bold: true }
                        Repeater {
                            model: structures.values
                            delegate: Rectangle {
                                required property var modelData
                                width: 116
 height: 47
 radius: 10
                                color: index === 0 ? "#183447" : "#211B39"
                                border.color: index === 0 ? theme.cyan : theme.purple
                                Label { anchors.centerIn: parent
 text: modelData
 color: theme.text
 font.pixelSize: 16
 font.bold: true }
                            }
                        }
                        Label { visible: structures.values.length === 0
 text: "Stack is empty"
 color: theme.muted }
                    }
                    Item {
                        visible: structures.kind === "Binary Search Tree"
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Canvas {
                            id: treeEdges
                            anchors.fill: parent
                            onPaint: {
                                var ctx = getContext("2d")
                                ctx.clearRect(0, 0, width, height)
                                ctx.strokeStyle = "#52617D"
                                ctx.lineWidth = 2
                                var nodes = structures.treeNodes
                                for (var i = 1; i < nodes.length; ++i) {
                                    var n = nodes[i]
                                    ctx.beginPath()
                                    ctx.moveTo(n.parentX * width, 54 + n.parentY * 78)
                                    ctx.lineTo(n.x * width, 54 + n.y * 78)
                                    ctx.stroke()
                                }
                            }
                            Connections { target: structures; function onChanged() { treeEdges.requestPaint() } }
                        }
                        Repeater {
                            model: structures.treeNodes
                            delegate: Rectangle {
                                required property var modelData
                                width: 52
                                height: 52
                                radius: 26
                                x: modelData.x * parent.width - width / 2
                                y: 54 + modelData.y * 78
                                color: "#211B39"
                                border.width: 2
                                border.color: theme.purple
                                Behavior on x { NumberAnimation { duration: 240 } }
                                Label { anchors.centerIn: parent; text: modelData.value; color: theme.text; font.bold: true }
                            }
                        }
                    }
                }
                Label { Layout.fillWidth: true
 text: structures.status
 color: theme.text
 font.pixelSize: 13
 wrapMode: Text.WordWrap
 horizontalAlignment: Text.AlignHCenter }
            }
        }
        Rectangle {
            Layout.fillWidth: true
            radius: 14
            color: theme.panel
            border.color: theme.border
            implicitHeight: 104
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 12
                RowLayout {
                    Label { text: "Value"
 color: theme.muted
 font.pixelSize: 11 }
                    SpinBox { from: -9999
 to: 9999
 value: page.itemValue
 onValueModified: page.itemValue = value }
                    Label { visible: structures.kind === "Linked List"
 text: "Position"
 color: theme.muted
 font.pixelSize: 11 }
                    SpinBox { visible: structures.kind === "Linked List"
 from: 0
 to: structures.size
 value: page.position
 onValueModified: page.position = value }
                    Item { Layout.fillWidth: true }
                    Button { text: structures.kind === "Stack" ? "Push" : structures.kind === "Queue" ? "Enqueue" : "Insert"
 onClicked: structures.insert(page.itemValue, page.position) }
                    Button { text: structures.kind === "Stack" ? "Pop" : structures.kind === "Queue" ? "Dequeue" : "Delete"
 onClicked: structures.remove(page.position) }
                    Button { text: "Search / Peek"
 onClicked: structures.search(page.itemValue) }
                    Button { text: "Traverse"
 onClicked: structures.traverse(orderBox.currentText) }
                    ComboBox { id: orderBox
 visible: structures.kind === "Binary Search Tree"
 model: ["Inorder", "Preorder", "Postorder"] }
                    Button { text: "Reset"
 onClicked: structures.reset() }
                }
                Label { text: "Linked list insertion and deletion use zero based positions. Stack and queue underflow produce a clear message."
 color: theme.muted
 font.pixelSize: 10 }
            }
        }
    }
}
