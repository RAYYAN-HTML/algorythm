import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Popup {
    id: root
    property AppTheme theme
    property QtObject appSettings
    property bool reducedMotion: false
    property bool sidebarCollapsed: false
    property int windowWidth: 1000
    property int windowHeight: 700

    signal reducedMotionToggled(bool enabled)
    signal sidebarCollapsedToggled(bool enabled)
    signal defaultsRestored()

    parent: Overlay.overlay
    width: Math.min(320, windowWidth - 24)
    padding: 18
    x: Math.max(12, Math.min(sidebarCollapsed || windowWidth < 980 ? 76 : 228, windowWidth - width - 12))
    y: Math.max(12, windowHeight - height - 90)

    background: Rectangle { radius: 12; color: root.theme.panel; border.color: root.theme.border }
    contentItem: ColumnLayout {
        spacing: 12
        Label { text: "Settings"; color: root.theme.text; font.bold: true; font.pixelSize: 18 }
        Label { text: "PLAYBACK"; color: root.theme.purple; font.pixelSize: 10; font.bold: true; font.letterSpacing: 1.1 }
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Playback speed"; color: root.theme.text; font.pixelSize: 12 }
            Item { Layout.fillWidth: true }
            Label { text: root.appSettings.playbackSpeed.toFixed(1) + "×"; color: root.theme.purple; font.bold: true }
        }
        Slider {
            Layout.fillWidth: true
            from: 0.5; to: 3.0; stepSize: 0.5
            value: root.appSettings.playbackSpeed
            onMoved: root.appSettings.playbackSpeed = value
        }
        Rectangle { Layout.fillWidth: true; height: 1; color: root.theme.border }
        Label { text: "ACCESSIBILITY & LAYOUT"; color: root.theme.purple; font.pixelSize: 10; font.bold: true; font.letterSpacing: 1.1 }
        Switch { text: "Reduced motion"; checked: root.reducedMotion; onToggled: root.reducedMotionToggled(checked) }
        Switch { text: "Compact sidebar"; checked: root.sidebarCollapsed; onToggled: root.sidebarCollapsedToggled(checked) }
        Label { text: "Preferences and workspace layout are saved on this device."; color: root.theme.muted; font.pixelSize: 10; wrapMode: Text.WordWrap; Layout.fillWidth: true }
        Button {
            text: "Restore default settings"
            Layout.fillWidth: true
            onClicked: { root.appSettings.resetPreferences(); root.defaultsRestored(); root.close() }
            background: Rectangle { radius: 8; color: parent.hovered ? "#22314A" : "#0D0D1A"; border.color: root.theme.border }
            contentItem: Text { text: parent.text; color: root.theme.text; font.pixelSize: 11; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
        }
    }
}
