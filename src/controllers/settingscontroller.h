#pragma once

#include <QObject>
#include <QSettings>
#include <QVariant>

class SettingsController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool reducedMotion READ reducedMotion WRITE setReducedMotion NOTIFY reducedMotionChanged)
    Q_PROPERTY(qreal playbackSpeed READ playbackSpeed WRITE setPlaybackSpeed NOTIFY playbackSpeedChanged)
    Q_PROPERTY(bool sidebarCollapsed READ sidebarCollapsed WRITE setSidebarCollapsed NOTIFY sidebarCollapsedChanged)
public:
    explicit SettingsController(QObject *parent = nullptr) : QObject(parent) {}
    bool reducedMotion() const { return m_settings.value("accessibility/reducedMotion", false).toBool(); }
    void setReducedMotion(bool enabled)
    {
        if (reducedMotion() == enabled) return;
        m_settings.setValue("accessibility/reducedMotion", enabled);
        emit reducedMotionChanged();
    }
    qreal playbackSpeed() const { return m_settings.value("playback/speed", 1.0).toReal(); }
    void setPlaybackSpeed(qreal speed)
    {
        const qreal bounded = qBound<qreal>(0.5, speed, 3.0);
        if (qFuzzyCompare(playbackSpeed(), bounded)) return;
        m_settings.setValue("playback/speed", bounded);
        emit playbackSpeedChanged();
    }
    bool sidebarCollapsed() const { return m_settings.value("ui/sidebarCollapsed", false).toBool(); }
    void setSidebarCollapsed(bool collapsed)
    {
        if (sidebarCollapsed() == collapsed) return;
        m_settings.setValue("ui/sidebarCollapsed", collapsed);
        emit sidebarCollapsedChanged();
    }
    Q_INVOKABLE QVariant workspaceState() const { return m_settings.value("ui/sortingWorkspace"); }
    Q_INVOKABLE void saveWorkspaceState(const QVariant &state) { m_settings.setValue("ui/sortingWorkspace", state); }
    Q_INVOKABLE void resetPreferences()
    {
        m_settings.clear();
        emit reducedMotionChanged();
        emit playbackSpeedChanged();
        emit sidebarCollapsedChanged();
    }
signals:
    void reducedMotionChanged();
    void playbackSpeedChanged();
    void sidebarCollapsedChanged();
private:
    QSettings m_settings;
};
