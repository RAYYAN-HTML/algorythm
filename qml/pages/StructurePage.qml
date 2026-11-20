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
        anchors.margins: page.width < 880 ? 18 : 28
        spacing: page.width < 880 ? 12 : 18
        RowLayout {
            ColumnLayout {
                Label { text: "DATA STRUCTURES"
 color: theme.purple
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
 onActivated: structures.kind = currentText
 implicitWidth: page.width < 880 ? 180 : 210 }
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
 color: theme.purple
 font.pixelSize: 11
 font.bold: true }
                }
                Item { Layout.fillWidth: true
 Layout.fillHeight: true
 Layout.minimumHeight: page.width < 880 ? 150 : 250
 Layout.maximumHeight: page.width < 880 ? 360 : 16777215
                    RowLayout {
                        visible: structures.kind === "Linked List" || structures.kind === "Queue"
                        anchors.centerIn: parent
                        spacing: 10
                        Label { visible: structures.values.length > 0; text: structures.kind === "Queue" ? "FRONT →" : "HEAD →"; color: theme.purple; font.pixelSize: 9; font.bold: true }
                        ListView {
                            visible: structures.visualModel.count > 0
                            model: structures.visualModel
                            orientation: ListView.Horizontal
                            spacing: 3
                            clip: true
                            Layout.preferredWidth: Math.min(page.width - 250, Math.max(82, structures.visualModel.count * 82))
                            Layout.preferredHeight: 68
                            delegate: Item {
                                required property int value
                                required property int index
                                width: 82; height: 68
                                Rectangle {
                                    width: 58; height: 58; radius: 29
                                    anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter
                                    color: index === 0 ? "#2B2042" : "#1A1930"
                                    border.width: 2; border.color: index === 0 ? theme.purple : theme.purple
                                    Label { anchors.centerIn: parent; text: value; color: theme.text; font.pixelSize: 18; font.bold: true }
                                }
                                Label { visible: index < structures.visualModel.count - 1; anchors.left: parent.left; anchors.leftMargin: 61; anchors.verticalCenter: parent.verticalCenter; text: "→"; color: theme.purple; font.pixelSize: 17 }
                            }
                            add: Transition { NumberAnimation { properties: "opacity,scale"; from: 0.25; to: 1; duration: theme.reducedMotion ? 0 : 200; easing.type: Easing.OutCubic } }
                            remove: Transition { NumberAnimation { properties: "opacity,scale"; to: 0.15; duration: theme.reducedMotion ? 0 : 170; easing.type: Easing.InCubic } }
                            displaced: Transition { NumberAnimation { properties: "x,y"; duration: theme.reducedMotion ? 0 : 260; easing.type: Easing.InOutCubic } }
                        }
                        Label { visible: structures.values.length > 0; text: structures.kind === "Queue" ? "← REAR" : "TAIL"; color: theme.brightPurple; font.pixelSize: 9; font.bold: true }
                    }
                    ColumnLayout {
                        visible: structures.kind === "Stack"
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 8
                        Label { visible: structures.values.length > 0
 text: "TOP ↓"
 color: theme.brightPurple
 font.pixelSize: 10
 font.bold: true }
                        ListView {
                            model: structures.visualModel
                            orientation: ListView.Vertical
                            spacing: 8
                            clip: true
                            Layout.preferredWidth: 140
                            Layout.preferredHeight: Math.min(320, Math.max(55, structures.visualModel.count * 55))
                            delegate: Item {
                                required property int value
                                required property int index
                                width: 116; height: 47
                                Rectangle { anchors.fill: parent; radius: 10; color: index === 0 ? "#2B2042" : "#1A1930"; border.color: index === 0 ? theme.purple : theme.purple
                                    Label { anchors.centerIn: parent; text: value; color: theme.text; font.pixelSize: 16; font.bold: true }
                                }
                            }
                            add: Transition { NumberAnimation { properties: "opacity,scale"; from: 0.2; to: 1; duration: theme.reducedMotion ? 0 : 200; easing.type: Easing.OutBack } }
                            remove: Transition { NumberAnimation { properties: "opacity,scale"; to: 0.1; duration: theme.reducedMotion ? 0 : 170; easing.type: Easing.InCubic } }
                            displaced: Transition { NumberAnimation { properties: "x,y"; duration: theme.reducedMotion ? 0 : 240; easing.type: Easing.OutCubic } }
                        }
                        Label { visible: structures.values.length === 0
 text: "Stack is empty"
 color: theme.muted }
                    }
                    Item {
                        id: treeArea
                        anchors.fill: parent
                        visible: structures.kind === "Binary Search Tree"
                        readonly property real treeTop: page.width < 880 ? 34 : 54
                        readonly property real treeRowSpacing: page.width < 880 ? 58 : 78
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
                                    ctx.moveTo(n.parentX * width, treeArea.treeTop + n.parentY * treeArea.treeRowSpacing)
                                    ctx.lineTo(n.x * width, treeArea.treeTop + n.y * treeArea.treeRowSpacing)
                                    ctx.stroke()
                                }
                            }
                            Connections { target: structures; function onChanged() { treeEdges.requestPaint() } }
                        }
                        Repeater {
                            anchors.fill: parent
                            model: structures.treeVisualModel
                            delegate: Rectangle {
                                id: treeNode
                                required property int value
                                required property real posX
                                required property real posY
                                property bool entering: true
                                opacity: entering ? 0 : 1
                                scale: entering ? 0.65 : 1
                                width: 52
                                height: 52
                                radius: 26
                                x: posX * treeArea.width - width / 2
                                y: treeArea.treeTop + posY * treeArea.treeRowSpacing
                                color: "#1A1930"
                                border.width: 2
                                border.color: theme.purple
                                Behavior on x { NumberAnimation { duration: theme.reducedMotion ? 0 : 240 } }
                                Behavior on y { NumberAnimation { duration: theme.reducedMotion ? 0 : 240 } }
                                Label { anchors.centerIn: parent; text: value; color: theme.text; font.bold: true }
                                ParallelAnimation {
                                    id: nodeEntrance
                                    NumberAnimation { target: treeNode; property: "opacity"; to: 1; duration: theme.reducedMotion ? 0 : 220; easing.type: Easing.OutCubic }
                                    NumberAnimation { target: treeNode; property: "scale"; to: 1; duration: theme.reducedMotion ? 0 : 260; easing.type: Easing.OutBack }
                                    onFinished: treeNode.entering = false
                                }
                                Component.onCompleted: { if (theme.reducedMotion) entering = false; else nodeEntrance.start() }
                            }
                        }
                    }
                }
                Label { Layout.fillWidth: true
 visible: structures.kind !== "Binary Search Tree"
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
            implicitHeight: page.width < 880 ? 150 : 104
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 12
                Flow {
                    Layout.fillWidth: true
                    Layout.preferredHeight: page.width < 880 ? 80 : 36
                    spacing: 8
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
                    Button { text: structures.kind === "Stack" ? "Push" : structures.kind === "Queue" ? "Enqueue" : "Insert"
 highlighted: true
 onClicked: structures.insert(page.itemValue, page.position) }
                    Button { text: structures.kind === "Stack" ? "Pop" : structures.kind === "Queue" ? "Dequeue" : "Delete"
 flat: true
 onClicked: structures.remove(page.position) }
                    Button { text: "Search / Peek"
 flat: true
 onClicked: structures.search(page.itemValue) }
                    Button { text: "Traverse"
 flat: true
 onClicked: structures.traverse(orderBox.currentText) }
                    ComboBox { id: orderBox
 visible: structures.kind === "Binary Search Tree"
 model: ["Inorder", "Preorder", "Postorder"] }
                    Button { text: "Reset"
 flat: true
 onClicked: structures.reset() }
                }
                Label { text: structures.kind === "Binary Search Tree" ? structures.status : "Linked list insertion and deletion use zero based positions. Stack and queue underflow produce a clear message."
 color: theme.muted
 font.pixelSize: 10 }
            }
        }
    }
}
