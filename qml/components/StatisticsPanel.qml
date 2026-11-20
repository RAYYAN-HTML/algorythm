import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    required property AppTheme theme
    property color panelColor: theme.panel
    color: panelColor
 radius: 14
 border.color: theme.border
    implicitHeight: 112
    ColumnLayout {
        anchors.fill: parent
 anchors.margins: 15
 spacing: 11
        Label { text: "Live statistics"
 color: theme.text
 font.bold: true
 font.pixelSize: 13 }
        RowLayout {
            Layout.fillWidth: true
            Repeater { model: playback.algorithm.endsWith("Search") ? [["INSPECTED", playback.comparisons, theme.amber], ["COMPARISONS", playback.comparisons, theme.purpleText], ["TARGET", playback.searchTarget, theme.green]] : [["COMPARE", playback.comparisons, theme.amber], ["SWAPS", playback.swaps, theme.purpleText], ["WRITES", playback.writes, theme.purpleText]]
                delegate: ColumnLayout { Layout.fillWidth: true
 spacing: 3
 Label { text: modelData[0]
 color: theme.muted
 font.pixelSize: 9 }
 Label { text: modelData[1]
 color: modelData[2]
 font.pixelSize: 19
 font.bold: true } }
            }
        }
    }
}

