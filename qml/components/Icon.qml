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
        case "compare": return "M4 7h14m0 0-3-3m3 3-3 3M20 17H6m0 0 3-3m-3 3 3 3"
        case "dashboard": return "M5 5h6v6H5zM13 5h6v4h-6zM13 11h6v8h-6zM5 13h6v6H5z"
        case "graph": return "M6 6l6 5m0 2-6 5m7-7 5-6m-5 7 5 5M6 4a2 2 0 1 0 0 4 2 2 0 0 0 0-4Zm6 5a2 2 0 1 0 0 4 2 2 0 0 0 0-4Zm6-7a2 2 0 1 0 0 4 2 2 0 0 0 0-4Zm0 12a2 2 0 1 0 0 4 2 2 0 0 0 0-4ZM6 16a2 2 0 1 0 0 4 2 2 0 0 0 0-4Z"
        case "linked-list": return "M6 12h12m-2-2 2 2-2 2M6 6a3 3 0 1 0 0 6 3 3 0 0 0 0-6Zm12 6a3 3 0 1 0 0 6 3 3 0 0 0 0-6Z"
        case "menu": return "M4 6h16M4 12h16M4 18h16"
        case "next": return "M5 5v14l10-7-10-7Zm11 0v14m4-14v14"
        case "pause": return "M7 5h4v14H7zM15 5h4v14h-4z"
        case "play": return "M7 4l13 8-13 8V4Z"
        case "previous": return "M19 5v14L9 12l10-7ZM8 5v14M4 5v14"
        case "queue": return "M5 7h14M5 12h14M5 17h14M8 5 5 7l3 2m8 6 3 2-3 2"
        case "restart": return "M20 11a8 8 0 0 0-14-5L4 8m0-5v5h5m-5 5a8 8 0 0 0 14 5l2-2m0 5v-5h-5"
        case "search": return "M10.5 4a6.5 6.5 0 1 0 0 13 6.5 6.5 0 0 0 0-13Zm5 11 4.5 4.5"
        case "settings": return "M12 8.5a3.5 3.5 0 1 0 0 7 3.5 3.5 0 0 0 0-7Zm0-5v2m0 13v2m9-8h-2m-14 0H3m15.36-6.36-1.42 1.42M7.06 16.94l-1.42 1.42m12.72 0-1.42-1.42M7.06 7.06 5.64 5.64"
        case "sorting": return "M6 5v14m0 0-3-3m3 3 3-3M18 19V5m0 0-3 3m3-3 3 3M11 7h3m-3 5h3m-3 5h3"
        case "sparkle": return "M12 3l1.8 6.2L20 11l-6.2 1.8L12 19l-1.8-6.2L4 11l6.2-1.8L12 3Zm7 13 .7 2.3L22 19l-2.3.7L19 22l-.7-2.3L16 19l2.3-.7L19 16Z"
        case "stack": return "M12 4 20 8l-8 4-8-4 8-4Zm-8 8 8 4 8-4m-16 4 8 4 8-4"
        case "tree": return "M12 5v6m0 0L6 17m6-6 6 6M12 3a2 2 0 1 0 0 4 2 2 0 0 0 0-4ZM6 15a2 2 0 1 0 0 4 2 2 0 0 0 0-4Zm12 0a2 2 0 1 0 0 4 2 2 0 0 0 0-4Z"
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
