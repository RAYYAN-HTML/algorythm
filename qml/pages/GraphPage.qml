import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Item {
    id: page
    property AppTheme theme
    property var px: [0.10, 0.29, 0.29, 0.49, 0.49, 0.72, 0.90]
    property var py: [0.48, 0.20, 0.76, 0.43, 0.86, 0.53, 0.35]
    property int startNode: 0
    property int fromNode: 0
    property int toNode: 1
    property int weight: 1
    property string edgeFeedback: "Choose two different nodes to add an edge."

    function addWeightedEdge() {
        if (graph.addEdge(fromNode, toNode, weight))
            edgeFeedback = "Added edge " + fromNode + " ↔ " + toNode + " with weight " + weight + "."
    }
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 22
        spacing: 14
        RowLayout {
            ColumnLayout {
                Label { text: "GRAPH LAB"; color: theme.purple; font.pixelSize: 10; font.bold: true; font.letterSpacing: 1.5 }
                Label { text: graph.algorithm; color: theme.text; font.pixelSize: 25; font.bold: true }
                Label { text: "Traverse the sample graph or add a nonnegative weighted edge."; color: theme.muted; font.pixelSize: 11 }
            }
            Item { Layout.fillWidth: true }
            ComboBox { model: ["Breadth-First Search", "Depth-First Search", "Dijkstra's Shortest Path"]; currentIndex: model.indexOf(graph.algorithm); onActivated: graph.algorithm = currentText; implicitWidth: 210 }
        }
        Rectangle {
            id: graphPanel
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 17
            color: theme.secondary
            border.color: theme.border
            Canvas {
                id: edgeCanvas
                property real activeEdgeProgress: 0
                property int trackedFrom: -2
                property int trackedTo: -2
                anchors.fill: parent
                anchors.margins: 18
                onActiveEdgeProgressChanged: requestPaint()
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)
                    var edges = graph.edgeList
                    for (var i = 0; i < edges.length; ++i) {
                        var e = edges[i]
                        var x1 = page.px[e.from] * width, y1 = page.py[e.from] * height
                        var x2 = page.px[e.to] * width, y2 = page.py[e.to] * height
                        ctx.beginPath(); ctx.moveTo(x1, y1); ctx.lineTo(x2, y2)
                        ctx.strokeStyle = theme.graphEdge
                        ctx.lineWidth = 1.5; ctx.stroke()
                        ctx.fillStyle = theme.supportText; ctx.font = "12px sans-serif"
                        ctx.fillText(String(e.weight), (x1+x2)/2 + 5, (y1+y2)/2 - 5)
                    }
                    if (graph.active >= 0 && graph.edgeTo >= 0) {
                        var sx = page.px[graph.active] * width, sy = page.py[graph.active] * height
                        var ex = page.px[graph.edgeTo] * width, ey = page.py[graph.edgeTo] * height
                        ctx.beginPath(); ctx.moveTo(sx, sy)
                        ctx.lineTo(sx + (ex - sx) * activeEdgeProgress, sy + (ey - sy) * activeEdgeProgress)
                        ctx.strokeStyle = theme.purple; ctx.lineWidth = 3
                        ctx.shadowColor = theme.purple; ctx.shadowBlur = 11
                        ctx.stroke(); ctx.shadowBlur = 0
                    }
                }
                Connections {
                    target: graph
                    function onChanged() {
                        var from = graph.active, to = graph.edgeTo
                        if (from !== edgeCanvas.trackedFrom || to !== edgeCanvas.trackedTo) {
                            edgeCanvas.trackedFrom = from; edgeCanvas.trackedTo = to
                            if (from >= 0 && to >= 0) {
                                edgeCanvas.activeEdgeProgress = 0
                                edgeTravel.restart()
                            } else {
                                edgeTravel.stop()
                                edgeCanvas.activeEdgeProgress = 0
                            }
                        }
                        edgeCanvas.requestPaint()
                    }
                }
                NumberAnimation {
                    id: edgeTravel
                    target: edgeCanvas
                    property: "activeEdgeProgress"
                    from: 0; to: 1
                    duration: theme.reducedMotion ? 0 : 320
                    easing.type: Easing.OutCubic
                }
            }
            Repeater {
                model: 7
                delegate: Rectangle {
                    required property int index
                    width: 54; height: 54; radius: 27
                    x: 18 + page.px[index] * (graphPanel.width - 36) - width / 2
                    y: 18 + page.py[index] * (graphPanel.height - 36) - height / 2
                    color: index === graph.active ? theme.activeNode : graph.visited.indexOf(index) >= 0 ? theme.visitedNode : theme.elevated
                    border.width: index === graph.active ? 3 : 1.5
                    border.color: index === graph.active ? theme.purple : graph.visited.indexOf(index) >= 0 ? theme.green : theme.purple
                    scale: index === graph.active ? 1.12 : 1.0
                    Behavior on x { NumberAnimation { duration: theme.reducedMotion ? 0 : 260 } }
                    Behavior on color { ColorAnimation { duration: theme.reducedMotion ? 0 : 240 } }
                    Behavior on border.color { ColorAnimation { duration: theme.reducedMotion ? 0 : 240 } }
                    Behavior on scale { NumberAnimation { duration: theme.reducedMotion ? 0 : 220; easing.type: Easing.OutCubic } }
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
            implicitHeight: 210
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
                    Button { text: "Run"; highlighted: true; onClicked: graph.run(page.startNode) }
                    Button { Accessible.name: "Restart graph"; onClicked: graph.restart(); contentItem: Icon { name: "restart"; color: theme.muted; iconSize: 16 } }
                    Button { Accessible.name: "Previous graph step"; onClicked: graph.previous(); contentItem: Icon { name: "previous"; color: theme.muted; iconSize: 16 } }
                    Button { Accessible.name: graph.playing ? "Pause graph" : "Play graph"; onClicked: graph.playPause(); contentItem: Icon { name: graph.playing ? "pause" : "play"; color: graph.playing ? theme.amber : theme.purple; iconSize: 16 } }
                    Button { Accessible.name: "Next graph step"; onClicked: graph.next(); contentItem: Icon { name: "next"; color: theme.muted; iconSize: 16 } }
                    Label { text: graph.stepIndex + 1 + " / " + graph.stepCount; color: theme.muted; font.pixelSize: 10 }
                    Item { Layout.fillWidth: true }
                }
                RowLayout {
                    Label { text: "Add weighted edge"; color: theme.muted; font.pixelSize: 10 }
                    SpinBox { from: 0; to: 6; value: page.fromNode; onValueModified: page.fromNode = value }
                    Label { text: "→"; color: theme.muted }
                    SpinBox { from: 0; to: 6; value: page.toNode; onValueModified: page.toNode = value }
                    SpinBox { from: 0; to: 999; value: page.weight; onValueModified: page.weight = value }
                    Button { text: "Add edge"; onClicked: page.addWeightedEdge(); background: Rectangle { radius: 8; color: theme.highlightSurface; border.color: theme.purple }
 contentItem: Text { text: parent.text; color: theme.purple; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter } }
                }
                Label { Layout.fillWidth: true; text: page.edgeFeedback; color: page.edgeFeedback.startsWith("Added") ? theme.green : page.edgeFeedback.length ? theme.error : theme.muted; font.pixelSize: 10; wrapMode: Text.WordWrap }
            }
        }
    }
    Connections { target: graph; function onError(message) { page.edgeFeedback = message } }
}
