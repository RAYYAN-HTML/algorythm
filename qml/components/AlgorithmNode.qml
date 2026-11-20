import QtQuick

Item {
    id: root
    property int value: 0
    property string state: "default"
    property color accent: "#A855F7"
    property color activeFill: "#38245B"
    property color compareFill: "#40351C"
    property color foundFill: "#514018"
    property color doneFill: "#15382F"
    property color idleFill: "#1A1930"
    property int animationDuration: 380
    Accessible.name: "Value " + root.value
    Accessible.description: root.state === "found" ? "Search target found" : root.state === "compare" ? "Currently being compared" : root.state === "active" ? "Current algorithm element" : root.state === "done" ? "Completed element" : "Unprocessed element"
    implicitWidth: 62
    implicitHeight: 62
    scale: state === "active" || state === "compare" ? 1.08 : 1.0
    Behavior on x { NumberAnimation { duration: root.animationDuration
 easing.type: Easing.InOutCubic } }
    Behavior on y { NumberAnimation { duration: root.animationDuration
 easing.type: Easing.InOutCubic } }
    Behavior on scale { NumberAnimation { duration: root.animationDuration === 0 ? 0 : 180
 easing.type: Easing.OutCubic } }
    Rectangle {
        anchors.fill: parent
 radius: width / 2
        color: root.state === "active" ? root.activeFill : root.state === "compare" || root.state === "found" ? root.state === "found" ? root.foundFill : root.compareFill : root.state === "done" ? root.doneFill : root.idleFill
        border.width: root.state === "active" || root.state === "compare" || root.state === "found" ? 2 : 1
        border.color: root.state === "active" ? root.accent : root.state === "compare" || root.state === "found" ? "#FBBF24" : root.state === "done" ? "#34D399" : "#594477"
        Behavior on color { ColorAnimation { duration: root.animationDuration * 0.7 } }
        Behavior on border.color { ColorAnimation { duration: root.animationDuration * 0.7 } }
        Rectangle { anchors.fill: parent
 anchors.margins: -5
 radius: width / 2
 color: "transparent"
 border.width: 1
 border.color: parent.border.color
 opacity: root.state === "default" ? 0.12 : 0.28
 z: -1 }
        Text { anchors.centerIn: parent
 text: root.value
 color: "#F8FAFC"
 font.pixelSize: 17
 font.bold: true }
    }
}

