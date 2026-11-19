import QtQuick

Item {
    id: root
    property int value: 0
    property string state: "default"
    property color accent: "#A855F7"
    property int animationDuration: 380
    implicitWidth: 62
    implicitHeight: 62
    scale: state === "active" || state === "compare" ? 1.08 : 1.0
    Behavior on x { NumberAnimation { duration: root.animationDuration
 easing.type: Easing.InOutCubic } }
    Behavior on y { NumberAnimation { duration: root.animationDuration
 easing.type: Easing.InOutCubic } }
    Behavior on scale { NumberAnimation { duration: 180
 easing.type: Easing.OutCubic } }
    Rectangle {
        anchors.fill: parent
 radius: width / 2
        color: root.state === "active" ? "#123B4B" : root.state === "compare" ? "#40351C" : root.state === "done" ? "#15382F" : "#211B39"
        border.width: root.state === "active" || root.state === "compare" ? 2 : 1
        border.color: root.state === "active" ? "#22D3EE" : root.state === "compare" ? "#FBBF24" : root.state === "done" ? "#34D399" : "#8050C8"
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

