#pragma once

#include "engine/step.h"
#include <QObject>
#include <QTimer>
#include <QVariantList>
#include <QAbstractListModel>

class AlgorithmNodeModel : public QAbstractListModel {
    Q_OBJECT
public:
    enum Role { ValueRole = Qt::UserRole + 1, PositionRole };
    explicit AlgorithmNodeModel(QObject *parent = nullptr) : QAbstractListModel(parent) {}
    int rowCount(const QModelIndex &parent = QModelIndex()) const override { return parent.isValid() ? 0 : m_values.size(); }
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
    void resetValues(const QVector<int> &values);
    void setPositions(const QVector<int> &ids);
private:
    QVector<int> m_values, m_positions;
};

class PlaybackController : public QObject {
    Q_OBJECT
    Q_PROPERTY(QVariantList values READ values NOTIFY stateChanged)
    Q_PROPERTY(QAbstractListModel* nodes READ nodes CONSTANT)
    Q_PROPERTY(int animationDuration READ animationDuration NOTIFY stateChanged)
    Q_PROPERTY(QString operation READ operation NOTIFY stateChanged)
    Q_PROPERTY(QString narration READ narration NOTIFY stateChanged)
    Q_PROPERTY(QString why READ why NOTIFY stateChanged)
    Q_PROPERTY(int activeA READ activeA NOTIFY stateChanged)
    Q_PROPERTY(int activeB READ activeB NOTIFY stateChanged)
    Q_PROPERTY(int pseudocodeLine READ pseudocodeLine NOTIFY stateChanged)
    Q_PROPERTY(int comparisons READ comparisons NOTIFY stateChanged)
    Q_PROPERTY(int swaps READ swaps NOTIFY stateChanged)
    Q_PROPERTY(int writes READ writes NOTIFY stateChanged)
    Q_PROPERTY(int stepIndex READ stepIndex NOTIFY stateChanged)
    Q_PROPERTY(int stepCount READ stepCount NOTIFY stateChanged)
    Q_PROPERTY(bool playing READ playing NOTIFY stateChanged)
    Q_PROPERTY(bool complete READ complete NOTIFY stateChanged)
    Q_PROPERTY(double speed READ speed WRITE setSpeed NOTIFY stateChanged)
    Q_PROPERTY(QString algorithm READ algorithm NOTIFY stateChanged)
    Q_PROPERTY(int searchTarget READ searchTarget NOTIFY stateChanged)
public:
    explicit PlaybackController(QObject *parent = nullptr);
    QVariantList values() const;
    QAbstractListModel *nodes() { return &m_nodes; }
    int animationDuration() const { return qMax(90, int(380 / m_speed)); }
    QString operation() const;
    QString narration() const;
    QString why() const;
    int activeA() const;
    int activeB() const;
    int pseudocodeLine() const;
    int comparisons() const;
    int swaps() const;
    int writes() const;
    int stepIndex() const { return m_index; }
    int stepCount() const { return m_steps.size(); }
    bool playing() const { return m_timer.isActive(); }
    bool complete() const;
    double speed() const { return m_speed; }
    QString algorithm() const { return m_algorithm; }
    int searchTarget() const { return m_searchTarget; }
    void setSpeed(double speed);

    Q_INVOKABLE void sortInput(const QString &text);
    Q_INVOKABLE void selectAlgorithm(const QString &name);
    Q_INVOKABLE void setSearchTarget(int target);
    Q_INVOKABLE void next();
    Q_INVOKABLE void previous();
    Q_INVOKABLE void restart();
    Q_INVOKABLE void playPause();
    Q_INVOKABLE void seek(int index);

signals:
    void stateChanged();
    void inputError(const QString &message);

private:
    QVector<ExecutionStep> m_steps;
    QVector<int> m_input;
    int m_index = 0;
    double m_speed = 1.0;
    QString m_algorithm = "Bubble Sort";
    int m_searchTarget = 6;
    QTimer m_timer;
    AlgorithmNodeModel m_nodes;
    const ExecutionStep &current() const;
};

