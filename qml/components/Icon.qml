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
        case "compare": return "M4 8h15l-3-3m3 3-3 3M20 16H5l3 3m-3-3 3-3"
        case "dashboard": return "M5 5h6v6H5zM13 5h6v6h-6zM5 13h6v6H5zM13 13h6v6h-6z"
        case "graph": return "M6 6l6 6 6-6M12 12l6 6M6 4a2 2 0 1 0 0 4 2 2 0 0 0 0-4Zm6 6a2 2 0 1 0 0 4 2 2 0 0 0 0-4Zm6-6a2 2 0 1 0 0 4 2 2 0 0 0 0-4Zm0 12a2 2 0 1 0 0 4 2 2 0 0 0 0-4Z"
        case "linked-list": return "M7 12h10m-3-3 3 3-3 3M6 8a2 2 0 1 0 0 4 2 2 0 0 0 0-4Zm12 4a2 2 0 1 0 0 4 2 2 0 0 0 0-4Z"
        case "menu": return "M4 6h16M4 12h16M4 18h16"
        case "next": return "M5 5v14l10-7-10-7Zm11 0v14m4-14v14"
        case "pause": return "M7 5h4v14H7zM15 5h4v14h-4z"
        case "play": return "M7 4l13 8-13 8V4Z"
        case "previous": return "M19 5v14L9 12l10-7ZM8 5v14M4 5v14"
        case "queue": return "M5 7h14M5 12h14M5 17h14"
        case "restart": return "M20 7v5h-5M4 17v-5h5M5 12a7 7 0 0 1 12-5l3 5M19 12a7 7 0 0 1-12 5l-3-5"
        case "search": return "M10.5 4a6.5 6.5 0 1 0 0 13 6.5 6.5 0 0 0 0-13Zm5 11 4.5 4.5"
        case "settings": return "M12 9a3 3 0 1 0 0 6 3 3 0 0 0 0-6Zm0-6v3m0 12v3m9-9h-3M6 12H3m15.4-6.4-2.1 2.1M7.7 16.3l-2.1 2.1m12.8 0-2.1-2.1M7.7 7.7 5.6 5.6"
        case "sorting": return "M6 5v14m0 0-3-3m3 3 3-3M18 19V5m0 0-3 3m3-3 3 3"
        case "sparkle": return "M12 4l2 6 6 2-6 2-2 6-2-6-6-2 6-2 2-6Z"
        case "stack": return "M12 4 20 8l-8 4-8-4 8-4Zm-8 8 8 4 8-4m-16 4 8 4 8-4"
        case "tree": return "M12 5v6m0 0-6 6m6-6 6 6M12 3a2 2 0 1 0 0 4 2 2 0 0 0 0-4ZM6 15a2 2 0 1 0 0 4 2 2 0 0 0 0-4Zm12 0a2 2 0 1 0 0 4 2 2 0 0 0 0-4Z"
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
