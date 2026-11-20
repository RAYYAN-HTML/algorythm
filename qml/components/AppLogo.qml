import QtQuick
import QtQuick.Shapes

Rectangle {
    id: root
    property QtObject theme
    property int size: 36

    width: size
    height: size
    radius: Math.round(size * 0.29)
    border.width: 1
    border.color: theme ? Qt.darker(theme.purple, 0.72) : "#6D28D9"
    gradient: Gradient {
        GradientStop { position: 0.0; color: "#2B1D48" }
        GradientStop { position: 1.0; color: "#141222" }
    }

    Item {
        id: mark
        anchors.centerIn: parent
        width: root.size * 0.64
        height: root.size * 0.64

        Shape {
            anchors.fill: parent
            ShapePath {
                strokeColor: root.theme ? root.theme.brightPurple : "#C084FC"
                strokeWidth: Math.max(1.5, root.size * 0.055)
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                joinStyle: ShapePath.RoundJoin
                PathSvg { path: "M4 19 12 4l8 15M7.3 13h9.4" }
            }
            ShapePath {
                strokeColor: root.theme ? root.theme.purple : "#8B5CF6"
                strokeWidth: Math.max(1.5, root.size * 0.05)
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                joinStyle: ShapePath.RoundJoin
                PathSvg { path: "M4 19h4m8 0h4" }
            }
        }

        Repeater {
            model: [
                { px: 4, py: 19, tint: "#C084FC" },
                { px: 12, py: 4, tint: "#A855F7" },
                { px: 20, py: 19, tint: "#38BDF8" },
                { px: 12, py: 13, tint: "#F8FAFC" }
            ]
            delegate: Rectangle {
                required property var modelData
                width: Math.max(3, root.size * 0.12)
                height: width
                radius: width / 2
                x: modelData.px / 24 * mark.width - width / 2
                y: modelData.py / 24 * mark.height - height / 2
                color: modelData.tint
                border.width: 0.7
                border.color: "#0D0D1A"
            }
        }
    }
}
