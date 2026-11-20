#pragma once

#include "engine/step.h"
#include <QVector>
#include <QStringList>

class BubbleSort {
public:
    static QVector<ExecutionStep> generate(const QVector<int> &input);
};

class SortingAlgorithms {
public:
    static QStringList names();
    static QVector<ExecutionStep> generate(const QString &name, const QVector<int> &input);
    static QVector<ExecutionStep> search(const QString &name, const QVector<int> &input, int target);
};

