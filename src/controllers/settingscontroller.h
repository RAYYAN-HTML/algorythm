#pragma once

#include <QObject>
#include <QSettings>
#include <QVariant>
#include <QVariantList>
#include <QVariantMap>

class SettingsController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool reducedMotion READ reducedMotion WRITE setReducedMotion NOTIFY reducedMotionChanged)
    Q_PROPERTY(qreal playbackSpeed READ playbackSpeed WRITE setPlaybackSpeed NOTIFY playbackSpeedChanged)
    Q_PROPERTY(bool sidebarCollapsed READ sidebarCollapsed WRITE setSidebarCollapsed NOTIFY sidebarCollapsedChanged)
    Q_PROPERTY(QVariantList recentActivities READ recentActivities NOTIFY recentActivitiesChanged)
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
    QVariantList recentActivities() const { return m_settings.value("history/recentActivities").toList(); }
    Q_INVOKABLE void recordRecentActivity(const QVariantMap &activity)
    {
        const QString section = activity.value("section").toString().trimmed();
        const QString algorithm = activity.value("algorithm").toString().trimmed();
        if (section.isEmpty() || section.size() > 64 || algorithm.size() > 64) return;
        QVariantMap normalized{{"section", section}, {"algorithm", algorithm}};
        const QString input = activity.value("input").toString().trimmed();
        if (!input.isEmpty()) normalized.insert("input", input.left(512));
        if (activity.contains("target")) normalized.insert("target", activity.value("target").toInt());
        if (activity.contains("graph")) {
            const QVariantMap graph = activity.value("graph").toMap();
            const int nodeCount = graph.value("nodeCount").toInt();
            const QVariantList edges = graph.value("edges").toList();
            if (section == "Graphs" && nodeCount >= 2 && nodeCount <= 12 && edges.size() <= 66)
                normalized.insert("graph", graph);
        }

        QVariantList history = recentActivities();
        history.removeAll(normalized);
        history.prepend(normalized);
        while (history.size() > 10) history.removeLast();
        if (history == recentActivities()) return;
        m_settings.setValue("history/recentActivities", history);
        emit recentActivitiesChanged();
    }
    Q_INVOKABLE void resetPreferences()
    {
        m_settings.clear();
        emit reducedMotionChanged();
        emit playbackSpeedChanged();
        emit sidebarCollapsedChanged();
        emit recentActivitiesChanged();
    }
signals:
    void reducedMotionChanged();
    void playbackSpeedChanged();
    void sidebarCollapsedChanged();
    void recentActivitiesChanged();
private:
    QSettings m_settings;
};
