import QtQuick

Item {
    id: root
    required property AppTheme theme
    property int value: 0
    property string nodeState: "default"
    property color accent: theme.brightPurple
    property color activeFill: theme.activeNode
    property color compareFill: theme.compareNode
    property color foundFill: theme.foundNode
    property color doneFill: theme.visitedNode
    property color idleFill: theme.elevated
    property int animationDuration: 380
    Accessible.name: "Value " + root.value
    Accessible.description: root.nodeState === "found" ? "Search target found" : root.nodeState === "compare" ? "Currently being compared" : root.nodeState === "active" ? "Current algorithm element" : root.nodeState === "done" ? "Completed element" : "Unprocessed element"
    implicitWidth: 62
    implicitHeight: 62
    scale: nodeState === "active" || nodeState === "compare" ? 1.08 : 1.0
    Behavior on x { NumberAnimation { duration: root.animationDuration
 easing.type: Easing.InOutCubic } }
    Behavior on y { NumberAnimation { duration: root.animationDuration
 easing.type: Easing.InOutCubic } }
    Behavior on scale { NumberAnimation { duration: root.animationDuration === 0 ? 0 : 180
 easing.type: Easing.OutCubic } }
    Rectangle {
        anchors.fill: parent
 radius: width / 2
        color: root.nodeState === "active" ? root.activeFill : root.nodeState === "compare" || root.nodeState === "found" ? root.nodeState === "found" ? root.foundFill : root.compareFill : root.nodeState === "done" ? root.doneFill : root.idleFill
        border.width: root.nodeState === "active" || root.nodeState === "compare" || root.nodeState === "found" ? 2 : 1
        border.color: root.nodeState === "active" ? root.accent : root.nodeState === "compare" || root.nodeState === "found" ? root.theme.amber : root.nodeState === "done" ? root.theme.green : root.theme.nodeOutline
        Behavior on color { ColorAnimation { duration: root.animationDuration * 0.7 } }
        Behavior on border.color { ColorAnimation { duration: root.animationDuration * 0.7 } }
        Rectangle { anchors.fill: parent
 anchors.margins: -5
 radius: width / 2
 color: "transparent"
 border.width: 1
 border.color: parent.border.color
 opacity: root.nodeState === "default" ? 0.12 : 0.28
 z: -1 }
        Text { anchors.centerIn: parent
 text: root.value
 color: root.theme.text
 font.pixelSize: 17
 font.bold: true
 Accessible.ignored: true }
    }
}

