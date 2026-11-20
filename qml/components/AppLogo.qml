import QtQuick
import QtQuick.Shapes

Rectangle {
    id: root
    property AppTheme theme
    property int size: 36

    width: size
    height: size
    radius: Math.round(size * 0.27)
    border.width: 1
    color: "#241A3B"
    border.color: theme.purple

    Item {
        id: mark
        anchors.centerIn: parent
        width: root.size * 0.64
        height: root.size * 0.64

        Shape {
            anchors.fill: parent
            ShapePath {
                strokeColor: root.theme ? root.theme.brightPurple : "#C084FC"
                strokeWidth: 2.2
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                joinStyle: ShapePath.RoundJoin
                PathSvg { path: "M5 19 12 5l7 14M8 14h8" }
            }
        }
    }
}
