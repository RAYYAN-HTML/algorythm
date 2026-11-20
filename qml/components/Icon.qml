import QtQuick
import QtQuick.Shapes

Item {
    id: root
    property string name: "dashboard"
    property color color: "white"
    property int iconSize: 20
    readonly property bool filled: name === "play" || name === "pause"
    readonly property string pathData: {
        switch (name) {
        case "arrow-right": return "M4 12h15m-6-6 6 6-6 6"
        case "compare": return "M4 7h13m0 0-3-3m3 3-3 3M20 17H7m0 0 3-3m-3 3 3 3"
        case "dashboard": return "M4.5 4.5h7v7h-7zM13 4.5h7v4h-7zM13 10h7v9.5h-7zM4.5 13h7v6.5h-7z"
        case "graph": return "M5 6a2 2 0 1 0 0 .01M18.5 5a2 2 0 1 0 0 .01M11 18a2 2 0 1 0 0 .01M20 18a2 2 0 1 0 0 .01M7 6l9.5-1M6 8l4 8m2-1 5.5-8m-5 11h5.5"
        case "linked-list": return "M5 9.5a2.5 2.5 0 1 0 0 .01M19 9.5a2.5 2.5 0 1 0 0 .01M7.5 9.5h9M12 7v5"
        case "menu": return "M4 6h16M4 12h16M4 18h16"
        case "next": return "M5 5v14l10-7-10-7Zm11 0v14m4-14v14"
        case "pause": return "M7 5h4v14H7zM15 5h4v14h-4z"
        case "play": return "M7 4l13 8-13 8V4Z"
        case "previous": return "M19 5v14L9 12l10-7ZM8 5v14M4 5v14"
        case "queue": return "M4 7h13M4 12h13M4 17h13M18 4l3 3-3 3"
        case "restart": return "M4 11a8 8 0 1 1 2 6M4 5v6h6"
        case "search": return "M10.8 4a6.8 6.8 0 1 0 0 13.6 6.8 6.8 0 1 0 0-13.6M16 16l5 5"
        case "settings": return "M4 6h16M4 12h16M4 18h16M9 4a2 2 0 1 0 0 .01M15 10a2 2 0 1 0 0 .01M7 16a2 2 0 1 0 0 .01"
        case "sorting": return "M7 4v16m0 0-4-4m4 4 4-4M17 20V4m0 0-4 4m4-4 4 4"
        case "sparkle": return "M12 3l1.7 6.3L20 11l-6.3 1.7L12 19l-1.7-6.3L4 11l6.3-1.7L12 3ZM19 16l.8 2.2L22 19l-2.2.8L19 22l-.8-2.2L16 19l2.2-.8L19 16Z"
        case "stack": return "M12 3l9 4.5-9 4.5-9-4.5L12 3ZM3 12l9 4.5 9-4.5M3 16.5 12 21l9-4.5"
        case "tree": return "M12 5a2.5 2.5 0 1 0 0 .01M6 19a2.5 2.5 0 1 0 0 .01M18 19a2.5 2.5 0 1 0 0 .01M12 7.5v4m0 0L6 16.5m6-5 6 5"
        default: return "M12 3l9 9-9 9-9-9 9-9Z"
        }
    }

    implicitWidth: iconSize
    implicitHeight: iconSize
    Accessible.ignored: true

    Shape {
        anchors.centerIn: parent
        width: 24
        height: 24
        scale: root.iconSize / 24
        ShapePath {
            strokeColor: root.color
            strokeWidth: 1.8
            fillColor: root.filled ? root.color : "transparent"
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin
            PathSvg { path: root.pathData }
        }
    }
}
