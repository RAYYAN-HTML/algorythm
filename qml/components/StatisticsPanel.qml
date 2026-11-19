import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    property color panelColor: "#151F32"
    color: panelColor
 radius: 14
 border.color: "#26344D"
    implicitHeight: 112
    ColumnLayout {
        anchors.fill: parent
 anchors.margins: 15
 spacing: 11
        Label { text: "Live statistics"
 color: "#F8FAFC"
 font.bold: true
 font.pixelSize: 13 }
        RowLayout {
            Layout.fillWidth: true
            Repeater { model: playback.algorithm.endsWith("Search") ? [["INSPECTED", playback.comparisons, "#FBBF24"], ["COMPARISONS", playback.comparisons, "#22D3EE"], ["TARGET", playback.searchTarget, "#34D399"]] : [["COMPARE", playback.comparisons, "#FBBF24"], ["SWAPS", playback.swaps, "#EC4899"], ["WRITES", playback.writes, "#22D3EE"]]
                delegate: ColumnLayout { Layout.fillWidth: true
 spacing: 3
 Label { text: modelData[0]
 color: "#94A3B8"
 font.pixelSize: 9 }
 Label { text: modelData[1]
 color: modelData[2]
 font.pixelSize: 19
 font.bold: true } }
            }
        }
    }
}

