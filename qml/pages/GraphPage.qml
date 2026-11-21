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
    property int destinationNode: 6
    property int fromNode: 0
    property int toNode: 1
    property int removeNodeIndex: 6
    property int weight: 1
    property string edgeFeedback: "Add or remove graph nodes and weighted edges."
    property bool edgeError: false

    function recordGraphActivity() {
        var savedGraph = graph.configuration()
        savedGraph.destinationNode = page.destinationNode
        appSettings.recordRecentActivity({ section: "Graphs", algorithm: graph.algorithm, graph: savedGraph })
    }
    function addWeightedEdge() {
        if (graph.addEdge(fromNode, toNode, weight)) {
            edgeError = false
            edgeFeedback = "Added edge " + fromNode + " ↔ " + toNode + " with weight " + weight + "."
            page.theme.announce(edgeFeedback)
            recordGraphActivity()
        }
    }
    function removeSelectedEdge() {
        if (graph.removeEdge(fromNode, toNode)) {
            edgeError = false
            edgeFeedback = "Removed edge " + fromNode + " ↔ " + toNode + "."
            page.theme.announce(edgeFeedback)
            recordGraphActivity()
        }
    }
    function addGraphNode() {
        if (graph.addNode()) {
            removeNodeIndex = graph.nodeCount - 1
            edgeError = false
            edgeFeedback = "Added node " + removeNodeIndex + "."
            page.theme.announce(edgeFeedback)
            recordGraphActivity()
        }
    }
    function removeSelectedNode() {
        var removed = removeNodeIndex
        if (graph.removeNode(removed)) {
            edgeError = false
            edgeFeedback = "Removed node " + removed + " and its connected edges."
            page.theme.announce(edgeFeedback)
            recordGraphActivity()
        }
    }
    function nodeX(index) {
        if (graph.nodeCount === 7) return page.px[index]
        var angle = 2 * Math.PI * index / graph.nodeCount - Math.PI / 2
        return 0.5 + 0.38 * Math.cos(angle)
    }
    function nodeY(index) {
        if (graph.nodeCount === 7) return page.py[index]
        var angle = 2 * Math.PI * index / graph.nodeCount - Math.PI / 2
        return 0.5 + 0.38 * Math.sin(angle)
    }
    function remapSelection(selectedNode, removedNode) {
        if (selectedNode > removedNode) return selectedNode - 1
        if (selectedNode === removedNode) return Math.min(removedNode, graph.nodeCount - 1)
        return selectedNode
    }
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 22
        spacing: 14
        RowLayout {
            ColumnLayout {
                Label { text: "GRAPH LAB"; color: theme.purpleText; font.pixelSize: 10; font.bold: true; font.letterSpacing: 1.5 }
                Label { text: graph.algorithm; color: theme.text; font.pixelSize: 25; font.bold: true }
                Label { text: "Edit nodes and weighted edges, then explore a traversal or shortest path."; color: theme.muted; font.pixelSize: 11 }
            }
            Item { Layout.fillWidth: true }
            ComboBox {
                model: ["Breadth-First Search", "Depth-First Search", "Dijkstra's Shortest Path"]
                currentIndex: model.indexOf(graph.algorithm)
                implicitWidth: 210
                onActivated: {
                    graph.algorithm = currentText
                    page.recordGraphActivity()
                }
            }
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
                        var x1 = page.nodeX(e.from) * width, y1 = page.nodeY(e.from) * height
                        var x2 = page.nodeX(e.to) * width, y2 = page.nodeY(e.to) * height
                        ctx.beginPath(); ctx.moveTo(x1, y1); ctx.lineTo(x2, y2)
                        ctx.strokeStyle = theme.graphEdge
                        ctx.lineWidth = 1.5; ctx.stroke()
                        ctx.fillStyle = theme.supportText; ctx.font = "12px sans-serif"
                        ctx.fillText(String(e.weight), (x1+x2)/2 + 5, (y1+y2)/2 - 5)
                    }
                    if (graph.active >= 0 && graph.edgeTo >= 0) {
                        var sx = page.nodeX(graph.active) * width, sy = page.nodeY(graph.active) * height
                        var ex = page.nodeX(graph.edgeTo) * width, ey = page.nodeY(graph.edgeTo) * height
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
                model: graph.nodeCount
                delegate: Rectangle {
                    required property int index
                    width: 54; height: 54; radius: 27
                    x: 18 + page.nodeX(index) * (graphPanel.width - 36) - width / 2
                    y: 18 + page.nodeY(index) * (graphPanel.height - 36) - height / 2
                    color: index === graph.active ? theme.activeNode : graph.visited.indexOf(index) >= 0 ? theme.visitedNode : theme.elevated
                    Accessible.name: "Graph node " + index
                    Accessible.description: index === graph.active ? "Current node. " + (graph.algorithm === "Dijkstra's Shortest Path" ? "Distance " + (graph.distances[index] || "infinity") : "") : graph.visited.indexOf(index) >= 0 ? "Visited node. " + (graph.algorithm === "Dijkstra's Shortest Path" ? "Distance " + (graph.distances[index] || "infinity") : "") : "Not yet visited."
                    border.width: index === graph.active ? 3 : 1.5
                    border.color: index === graph.active ? theme.purple : graph.visited.indexOf(index) >= 0 ? theme.green : theme.purple
                    scale: index === graph.active ? 1.12 : 1.0
                    Behavior on x { NumberAnimation { duration: theme.reducedMotion ? 0 : 260 } }
                    Behavior on color { ColorAnimation { duration: theme.reducedMotion ? 0 : 240 } }
                    Behavior on border.color { ColorAnimation { duration: theme.reducedMotion ? 0 : 240 } }
                    Behavior on scale { NumberAnimation { duration: theme.reducedMotion ? 0 : 220; easing.type: Easing.OutCubic } }
                    Label { anchors.centerIn: parent; text: index; color: theme.text; font.bold: true; font.pixelSize: 16; Accessible.ignored: true }
                    Label { visible: graph.algorithm === "Dijkstra's Shortest Path"; anchors.top: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter; text: graph.distances[index] || "∞"; color: theme.amber; font.pixelSize: 10 }
                }
            }
        }
        Rectangle {
            Layout.fillWidth: true
            radius: 13
            color: theme.panel
            border.color: theme.border
            implicitHeight: graph.algorithm === "Dijkstra's Shortest Path" ? 320 : 250
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 13
                spacing: 8
                RowLayout {
                    Label { text: graph.narration; color: theme.text; font.pixelSize: 11; Layout.fillWidth: true; wrapMode: Text.WordWrap }
                    Button {
                        visible: (graph.algorithm === "Breadth-First Search" || graph.algorithm === "Depth-First Search") && graph.active >= 0 && graph.edgeTo >= 0
                        text: "Predict node"
                        Accessible.name: "Predict whether the graph neighbor is new"
                        onClicked: graphChallenge.openPrediction()
                    }
                    Label { text: "Edges examined  " + graph.edgesExamined; color: theme.amber; font.pixelSize: 10 }
                }
                RowLayout {
                    Label { text: "Start"; color: theme.muted; font.pixelSize: 10 }
                    SpinBox { Accessible.name: "Start node"; from: 0; to: graph.nodeCount - 1; value: page.startNode; onValueModified: { page.startNode = value; page.recordGraphActivity() } }
                    Button { text: "Run"; highlighted: true; onClicked: { graph.run(page.startNode); page.recordGraphActivity() } }
                    Button { Accessible.name: "Restart graph"; onClicked: graph.restart(); contentItem: Icon { name: "restart"; color: theme.muted; iconSize: 16 } }
                    Button { Accessible.name: "Previous graph step"; onClicked: graph.previous(); contentItem: Icon { name: "previous"; color: theme.muted; iconSize: 16 } }
                    Button { Accessible.name: graph.playing ? "Pause graph" : "Play graph"; onClicked: graph.playPause(); contentItem: Icon { name: graph.playing ? "pause" : "play"; color: graph.playing ? theme.amber : theme.purple; iconSize: 16 } }
                    Button { Accessible.name: "Next graph step"; onClicked: graph.next(); contentItem: Icon { name: "next"; color: theme.muted; iconSize: 16 } }
                    Label { text: graph.stepIndex + 1 + " / " + graph.stepCount; color: theme.muted; font.pixelSize: 10 }
                    Item { Layout.fillWidth: true }
                }
                RowLayout {
                    visible: graph.algorithm === "Dijkstra's Shortest Path"
                    Label { text: "Destination"; color: theme.muted; font.pixelSize: 10 }
                    SpinBox { Accessible.name: "Destination node"; from: 0; to: graph.nodeCount - 1; value: page.destinationNode; onValueModified: { page.destinationNode = value; page.recordGraphActivity() } }
                    Label {
                        Layout.fillWidth: true
                        text: {
                            var route = graph.shortestPathTo(page.destinationNode)
                            if (!route.length) return "No known path to node " + page.destinationNode
                            var label = graph.stepIndex + 1 >= graph.stepCount ? "Shortest path: " : "Current best route: "
                            return label + route.join(" → ") + " · distance " + graph.distances[page.destinationNode]
                        }
                        color: theme.code
                        font.pixelSize: 10
                        wrapMode: Text.WordWrap
                    }
                }
                GridLayout {
                    visible: graph.algorithm === "Dijkstra's Shortest Path"
                    Layout.fillWidth: true
                    columns: Math.min(graph.nodeCount, page.width < 1120 ? 4 : 7)
                    rowSpacing: 3
                    columnSpacing: 8
                    Repeater {
                    model: graph.nodeCount
                        delegate: Label {
                            required property int index
                            Layout.fillWidth: true
                            text: "N" + index + "  d=" + (graph.distances[index] || "∞") + "  prev=" + (graph.previousNodes[index] || "—") + "  " + (graph.visited.indexOf(index) >= 0 ? "settled" : graph.distances[index] && graph.distances[index] !== "∞" ? "tentative" : "unreached")
                            color: graph.visited.indexOf(index) >= 0 ? theme.green : graph.distances[index] && graph.distances[index] !== "∞" ? theme.amber : theme.muted
                            font.pixelSize: 9
                            wrapMode: Text.WordWrap
                            Accessible.name: "Node " + index + ", " + (graph.visited.indexOf(index) >= 0 ? "settled" : graph.distances[index] && graph.distances[index] !== "∞" ? "tentative" : "unreached") + " distance " + (graph.distances[index] || "infinity") + ", previous node " + (graph.previousNodes[index] || "none")
                        }
                    }
                }
                RowLayout {
                    visible: graph.algorithm === "Dijkstra's Shortest Path"
                    Label { text: "Priority queue"; color: theme.muted; font.pixelSize: 9 }
                    Label {
                        Layout.fillWidth: true
                        text: graph.priorityQueue.length ? graph.priorityQueue.join("  →  ") : "empty"
                        color: theme.amber
                        font.family: "Consolas"
                        font.pixelSize: 9
                        wrapMode: Text.WordWrap
                        Accessible.name: "Priority queue, next node first: " + text
                    }
                }
                RowLayout {
                    Label { text: "Graph nodes"; color: theme.muted; font.pixelSize: 10 }
                    Button { text: "Add node"; Accessible.name: "Add graph node"; onClicked: page.addGraphNode() }
                    SpinBox { Accessible.name: "Node to remove"; from: 0; to: graph.nodeCount - 1; value: page.removeNodeIndex; onValueModified: page.removeNodeIndex = value }
                    Button { text: "Remove node"; Accessible.name: "Remove selected graph node"; onClicked: page.removeSelectedNode() }
                    Label { text: graph.nodeCount + " nodes"; color: theme.muted; font.pixelSize: 10 }
                    Item { Layout.fillWidth: true }
                }
                RowLayout {
                    Label { text: "Add weighted edge"; color: theme.muted; font.pixelSize: 10 }
                    SpinBox { Accessible.name: "Edge source node"; from: 0; to: graph.nodeCount - 1; value: page.fromNode; onValueModified: page.fromNode = value }
                    Label { text: "→"; color: theme.muted }
                    SpinBox { Accessible.name: "Edge destination node"; from: 0; to: graph.nodeCount - 1; value: page.toNode; onValueModified: page.toNode = value }
                    SpinBox { Accessible.name: "Edge weight"; from: 0; to: 999; value: page.weight; onValueModified: page.weight = value }
                    Button { id: addEdgeButton; text: "Add edge"; onClicked: page.addWeightedEdge(); background: Rectangle { radius: 8; color: addEdgeButton.hovered || addEdgeButton.visualFocus ? theme.activeNode : theme.highlightSurface; border.width: addEdgeButton.visualFocus ? 2 : 1; border.color: addEdgeButton.visualFocus ? theme.brightPurple : theme.purple }
                        contentItem: Text { text: addEdgeButton.text; color: page.theme.purpleText; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                    }
                    Button {
                        id: removeEdgeButton
                        text: "Remove"
                        Accessible.name: "Remove edge between selected nodes"
                        onClicked: page.removeSelectedEdge()
                    }
                }
                Label { Layout.fillWidth: true; text: page.edgeFeedback; color: page.edgeError ? theme.error : page.edgeFeedback.startsWith("Added") || page.edgeFeedback.startsWith("Removed") ? theme.green : theme.muted; font.pixelSize: 10; wrapMode: Text.WordWrap; Accessible.name: "Graph editing status" }
            }
        }
    }
    Connections {
        target: graph
        function onNodeRemoved(node) {
            page.startNode = page.remapSelection(page.startNode, node)
            page.destinationNode = page.remapSelection(page.destinationNode, node)
            page.fromNode = page.remapSelection(page.fromNode, node)
            page.toNode = page.remapSelection(page.toNode, node)
            page.removeNodeIndex = page.remapSelection(page.removeNodeIndex, node)
        }
        function onChanged() {
            const maximum = graph.nodeCount - 1
            page.startNode = Math.min(page.startNode, maximum)
            page.destinationNode = Math.min(page.destinationNode, maximum)
            page.fromNode = Math.min(page.fromNode, maximum)
            page.toNode = Math.min(page.toNode, maximum)
            page.removeNodeIndex = Math.min(page.removeNodeIndex, maximum)
        }
        function onError(message) {
            page.edgeFeedback = message
            page.edgeError = true
            page.theme.announce(message)
        }
    }
    GraphPredictionChallenge {
        id: graphChallenge
        theme: page.theme
        controller: graph
    }
}
