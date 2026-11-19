import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: page
    property QtObject theme
    property var px: [0.10, 0.29, 0.29, 0.49, 0.49, 0.72, 0.90]
    property var py: [0.48, 0.20, 0.76, 0.43, 0.86, 0.53, 0.35]
    property int startNode: 0
    property int fromNode: 0
    property int toNode: 1
    property int weight: 1
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 22
        spacing: 14
        RowLayout {
            ColumnLayout {
                Label { text: "GRAPH LAB"; color: theme.cyan; font.pixelSize: 10; font.bold: true; font.letterSpacing: 1.5 }
                Label { text: graph.algorithm; color: theme.text; font.pixelSize: 25; font.bold: true }
                Label { text: "Traverse the sample graph or add a nonnegative weighted edge."; color: theme.muted; font.pixelSize: 11 }
            }
            Item { Layout.fillWidth: true }
            ComboBox { model: ["Breadth-First Search", "Depth-First Search", "Dijkstra's Shortest Path"]; currentIndex: model.indexOf(graph.algorithm); onActivated: graph.algorithm = currentText; implicitWidth: 210 }
        }
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 17
            color: theme.secondary
            border.color: theme.border
            Canvas {
                id: edgeCanvas
                anchors.fill: parent
                anchors.margins: 18
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)
                    var edges = graph.edgeList
                    for (var i = 0; i < edges.length; ++i) {
                        var e = edges[i]
                        var x1 = page.px[e.from] * width, y1 = page.py[e.from] * height
                        var x2 = page.px[e.to] * width, y2 = page.py[e.to] * height
                        var active = (graph.active === e.from && graph.edgeTo === e.to) || (graph.active === e.to && graph.edgeTo === e.from)
                        ctx.beginPath(); ctx.moveTo(x1, y1); ctx.lineTo(x2, y2)
                        ctx.strokeStyle = active ? "#22D3EE" : "#34435D"
                        ctx.lineWidth = active ? 3 : 1.5; ctx.stroke()
                        ctx.fillStyle = "#94A3B8"; ctx.font = "12px sans-serif"
                        ctx.fillText(String(e.weight), (x1+x2)/2 + 5, (y1+y2)/2 - 5)
                    }
                }
                Connections { target: graph; function onChanged() { edgeCanvas.requestPaint() } }
            }
            Repeater {
                model: 7
                delegate: Rectangle {
                    required property int index
                    width: 54; height: 54; radius: 27
                    x: 18 + page.px[index] * (parent.width - 36) - width / 2
                    y: 18 + page.py[index] * (parent.height - 36) - height / 2
                    color: index === graph.active ? "#123B4B" : graph.visited.indexOf(index) >= 0 ? "#15382F" : "#211B39"
                    border.width: index === graph.active ? 3 : 1.5
                    border.color: index === graph.active ? theme.cyan : graph.visited.indexOf(index) >= 0 ? theme.green : theme.purple
                    scale: index === graph.active ? 1.12 : 1.0
                    Behavior on x { NumberAnimation { duration: 260 } }
                    Behavior on color { ColorAnimation { duration: 240 } }
                    Behavior on border.color { ColorAnimation { duration: 240 } }
                    Behavior on scale { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
                    Label { anchors.centerIn: parent; text: index; color: theme.text; font.bold: true; font.pixelSize: 16 }
                    Label { visible: graph.algorithm === "Dijkstra's Shortest Path"; anchors.top: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter; text: graph.distances[index] || "∞"; color: theme.amber; font.pixelSize: 10 }
                }
            }
        }
        Rectangle {
            Layout.fillWidth: true
            radius: 13
            color: theme.panel
            border.color: theme.border
            implicitHeight: 150
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 13
                spacing: 8
                RowLayout {
                    Label { text: graph.narration; color: theme.text; font.pixelSize: 11; Layout.fillWidth: true; wrapMode: Text.WordWrap }
                    Label { text: "Edges examined  " + graph.edgesExamined; color: theme.amber; font.pixelSize: 10 }
                }
                RowLayout {
                    Label { text: "Start"; color: theme.muted; font.pixelSize: 10 }
                    SpinBox { from: 0; to: 6; value: page.startNode; onValueModified: page.startNode = value }
                    Button { text: "Run"; onClicked: graph.run(page.startNode) }
                    Button { text: "↶"; onClicked: graph.restart() }
                    Button { text: "◀"; onClicked: graph.previous() }
                    Button { text: graph.playing ? "Ⅱ" : "▶"; onClicked: graph.playPause() }
                    Button { text: "▶|"; onClicked: graph.next() }
                    Label { text: graph.stepIndex + 1 + " / " + graph.stepCount; color: theme.muted; font.pixelSize: 10 }
                    Item { Layout.fillWidth: true }
                }
                RowLayout {
                    Label { text: "Add weighted edge"; color: theme.muted; font.pixelSize: 10 }
                    SpinBox { from: 0; to: 6; value: page.fromNode; onValueModified: page.fromNode = value }
                    Label { text: "→"; color: theme.muted }
                    SpinBox { from: 0; to: 6; value: page.toNode; onValueModified: page.toNode = value }
                    SpinBox { from: 0; to: 999; value: page.weight; onValueModified: page.weight = value }
                    Button { text: "Add edge"; onClicked: graph.addEdge(page.fromNode, page.toNode, page.weight); background: Rectangle { radius: 8; color: "#123244"; border.color: theme.cyan }
 contentItem: Text { text: parent.text; color: theme.cyan; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter } }
                }
            }
        }
    }
    Connections { target: graph; function onError(message) { console.warn(message) } }
}
