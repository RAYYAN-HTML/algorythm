#include "playbackcontroller.h"
#include "algorithms/sortingalgorithms.h"

#include <QRegularExpression>

QVariant AlgorithmNodeModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_values.size()) return {};
    if (role == ValueRole) return m_values[index.row()];
    if (role == PositionRole) return m_positions[index.row()];
    return {};
}
QHash<int, QByteArray> AlgorithmNodeModel::roleNames() const { return {{ValueRole, "nodeValue"}, {PositionRole, "nodePosition"}}; }
void AlgorithmNodeModel::resetValues(const QVector<int> &values)
{
    beginResetModel(); m_values = values; m_positions.resize(values.size());
    for (int i = 0; i < values.size(); ++i) m_positions[i] = i;
    endResetModel();
}
void AlgorithmNodeModel::setPositions(const QVector<int> &ids)
{
    if (ids.size() != m_positions.size()) return;
    for (int position = 0; position < ids.size(); ++position)
        if (ids[position] >= 0 && ids[position] < m_positions.size()) m_positions[ids[position]] = position;
    if (!m_positions.isEmpty()) emit dataChanged(index(0), index(m_positions.size()-1), {PositionRole});
}

int PlaybackVariableModel::rowCount(const QModelIndex &parent) const
{
    return parent.isValid() ? 0 : m_entries.size();
}

QVariant PlaybackVariableModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.parent().isValid() || index.row() < 0 || index.row() >= m_entries.size()) return {};
    const Entry &entry = m_entries.at(index.row());
    if (role == VariableNameRole) return entry.name;
    if (role == VariableValueRole) return entry.value;
    return {};
}

QHash<int, QByteArray> PlaybackVariableModel::roleNames() const
{
    return {{VariableNameRole, "variableName"}, {VariableValueRole, "variableValue"}};
}

void PlaybackVariableModel::setVariables(const QVariantMap &variables)
{
    const QStringList names = variables.keys();
    bool keysChanged = names.size() != m_entries.size();
    if (!keysChanged) {
        for (qsizetype i = 0; i < names.size(); ++i) {
            if (names.at(i) != m_entries.at(i).name) {
                keysChanged = true;
                break;
            }
        }
    }

    if (keysChanged) {
        beginResetModel();
        m_entries.clear();
        m_entries.reserve(names.size());
        for (const QString &name : names) m_entries.push_back({name, variables.value(name)});
        endResetModel();
        return;
    }

    int firstChanged = -1;
    int lastChanged = -1;
    for (qsizetype i = 0; i < names.size(); ++i) {
        const QVariant nextValue = variables.value(names.at(i));
        if (m_entries[i].value == nextValue) continue;
        m_entries[i].value = nextValue;
        if (firstChanged < 0) firstChanged = static_cast<int>(i);
        lastChanged = static_cast<int>(i);
    }
    if (firstChanged >= 0)
        emit dataChanged(index(firstChanged, 0), index(lastChanged, 0), {VariableValueRole});
}

PlaybackController::PlaybackController(QObject *parent) : QObject(parent)
{
    m_timer.setInterval(650);
    connect(&m_timer, &QTimer::timeout, this, [this] {
        if (m_index + 1 < m_steps.size()) ++m_index;
        else m_timer.stop();
        m_nodes.setPositions(current().nodeIds);
        publishState();
        if (complete()) m_timer.stop();
    });
    sortInput("8, 3, 6, 1, 9, 4, 2");
}

const ExecutionStep &PlaybackController::current() const
{
    static const ExecutionStep empty;
    return m_steps.isEmpty() ? empty : m_steps[qBound(0, m_index, m_steps.size() - 1)];
}

QVariantList PlaybackController::values() const { QVariantList out; for (int v : current().values) out << v; return out; }
void PlaybackController::publishState()
{
    m_variableEntries.setVariables(current().variables);
    emit stateChanged();
}
QString PlaybackController::operation() const { return current().operation; }
QString PlaybackController::narration() const { return current().narration; }
QString PlaybackController::why() const { return current().why; }
QVariantMap PlaybackController::variables() const { return current().variables; }
int PlaybackController::activeA() const { return current().activeA; }
int PlaybackController::activeB() const { return current().activeB; }
int PlaybackController::pseudocodeLine() const { return current().pseudocodeLine; }
int PlaybackController::comparisons() const { return current().comparisons; }
int PlaybackController::swaps() const { return current().swaps; }
int PlaybackController::writes() const { return current().writes; }
bool PlaybackController::complete() const { return !m_steps.isEmpty() && current().complete; }

void PlaybackController::setSpeed(double speed)
{
    m_speed = qBound(0.5, speed, 3.0);
    m_timer.setInterval(qMax(100, int(650 / m_speed)));
    publishState();
}

bool PlaybackController::sortInput(const QString &text)
{
    const QString trimmed = text.trimmed();
    if (trimmed.isEmpty()) { emit inputError("Enter at least one integer."); return false; }
    const auto parts = trimmed.split(QRegularExpression("[,\\s]+"), Qt::SkipEmptyParts);
    if (parts.size() > 16) { emit inputError("Use 16 or fewer values to keep the nodes readable."); return false; }
    QVector<int> input;
    for (const QString &part : parts) {
        bool ok = false; const int value = part.toInt(&ok);
        if (!ok) { emit inputError("Use whole numbers separated by commas or spaces."); return false; }
        input.push_back(value);
    }
    m_input = input;
    m_nodes.resetValues(input);
    m_timer.stop();
    m_steps = (m_algorithm == "Linear Search" || m_algorithm == "Binary Search")
                  ? SortingAlgorithms::search(m_algorithm, input, m_searchTarget)
                  : SortingAlgorithms::generate(m_algorithm, input);
    m_index = 0;
    m_nodes.setPositions(current().nodeIds);
    publishState();
    return true;
}

void PlaybackController::selectAlgorithm(const QString &name)
{
    if (!SortingAlgorithms::names().contains(name) && name != "Linear Search" && name != "Binary Search") return;
    m_algorithm = name;
    m_steps = (m_algorithm == "Linear Search" || m_algorithm == "Binary Search")
                  ? SortingAlgorithms::search(m_algorithm, m_input, m_searchTarget)
                  : SortingAlgorithms::generate(m_algorithm, m_input);
    m_index = 0;
    m_timer.stop();
    m_nodes.setPositions(current().nodeIds);
    publishState();
}

void PlaybackController::setSearchTarget(int target)
{
    m_searchTarget = target;
    if (m_algorithm == "Linear Search" || m_algorithm == "Binary Search") {
        m_steps = SortingAlgorithms::search(m_algorithm, m_input, m_searchTarget);
        m_index = 0;
        m_timer.stop();
        m_nodes.setPositions(current().nodeIds);
        publishState();
    }
}

void PlaybackController::next() { m_timer.stop(); if (m_index + 1 < m_steps.size()) ++m_index; m_nodes.setPositions(current().nodeIds); publishState(); }
void PlaybackController::previous() { m_timer.stop(); if (m_index > 0) --m_index; m_nodes.setPositions(current().nodeIds); publishState(); }
void PlaybackController::restart() { m_timer.stop(); m_index = 0; m_nodes.setPositions(current().nodeIds); publishState(); }
void PlaybackController::playPause() { if (m_timer.isActive()) m_timer.stop(); else if (!complete()) m_timer.start(); publishState(); }
void PlaybackController::startPlayback() { if (!complete()) m_timer.start(); publishState(); }
void PlaybackController::pausePlayback() { m_timer.stop(); publishState(); }
void PlaybackController::seek(int index) { m_timer.stop(); m_index = qBound(0, index, qMax(0, m_steps.size() - 1)); m_nodes.setPositions(current().nodeIds); publishState(); }

