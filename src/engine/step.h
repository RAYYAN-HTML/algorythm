#pragma once

#include <QString>
#include <QMetaType>
#include <QVector>

struct ExecutionStep {
    QVector<int> values;
    QVector<int> nodeIds;
    int activeA = -1;
    int activeB = -1;
    int pseudocodeLine = 0;
    int comparisons = 0;
    int swaps = 0;
    int writes = 0;
    QString operation;
    QString narration;
    QString why;
    bool complete = false;
};

