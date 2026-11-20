#include "sortingalgorithms.h"
#include <algorithm>
#include <QStringList>

static QString describeSearchValues(const QVector<int> &values)
{
    QStringList items;
    for (int value : values) items << QString::number(value);
    return items.join(", ");
}

QVector<ExecutionStep> SortingAlgorithms::search(const QString &name, const QVector<int> &input, int target)
{
    QVector<ExecutionStep> steps;
    QVector<int> values = input;
    QVector<int> ids; for (int i=0;i<input.size();++i) ids << i;
    int comparisons = 0;
    auto frame = [&](int active, int low, int high, int line, const QString &op, const QString &narration) {
        ExecutionStep s; s.values = values; s.nodeIds = ids; s.activeA = active; s.activeB = (name == "Binary Search") ? high : -1;
        s.comparisons = comparisons; s.pseudocodeLine = line; s.operation = op; s.narration = narration;
        s.variables = {{"target", target}, {"low", low}, {"high", high}, {"index", active}, {"comparisons", comparisons}, {"array", describeSearchValues(values)}};
        if (name == "Binary Search") s.variables.insert("mid", active);
        s.why = name == "Linear Search" ? QString("Linear Search checks each value from left to right and stops when it finds the target or reaches the end.")
                                               : QString("Binary Search keeps a sorted range and discards the half that cannot contain the target.");
        if (name == "Binary Search") s.narration += QString(" Current bounds: low %1, high %2.").arg(low).arg(high);
        steps.push_back(s);
    };
    if (name == "Linear Search") {
        frame(-1,0,values.size()-1,0,"Ready to search",QString("Linear Search will look for %1.").arg(target));
        int found = -1;
        for (int i=0;i<values.size();++i) { ++comparisons; frame(i,0,values.size()-1,1,"Inspect value",QString("Check %1 against target %2.").arg(values[i]).arg(target)); if(values[i]==target){found=i;break;} }
        ExecutionStep done; done.values=values; done.nodeIds=ids; done.comparisons=comparisons; done.activeA=found; done.pseudocodeLine=3; done.operation=found>=0?"Target found":"Target not found"; done.narration=found>=0?QString("Found %1 at index %2 after %3 comparison(s).").arg(target).arg(found).arg(comparisons):QString("Target %1 is not in the sequence.").arg(target); done.why=QString("Linear Search can stop at the first matching value. It has O(n) worst-case time and O(1) extra space."); done.variables={{"target",target},{"index",found},{"comparisons",comparisons},{"array",describeSearchValues(values)}}; done.complete=true; steps.push_back(done);
    } else {
        const bool sorted = std::is_sorted(values.begin(), values.end());
        if (!sorted) { QVector<QPair<int,int>> pairs; for (int i=0;i<values.size();++i) pairs.push_back({values[i],ids[i]}); std::stable_sort(pairs.begin(),pairs.end(),[](const auto &a,const auto &b){return a.first<b.first;}); for (int i=0;i<pairs.size();++i) { values[i]=pairs[i].first; ids[i]=pairs[i].second; } frame(-1,0,values.size()-1,0,"Prepare sorted input",QString("Binary Search requires sorted values, so the input is sorted first: %1.").arg([&]{QStringList p;for(int v:values)p<<QString::number(v);return p.join(", ");}())); }
        int low=0, high=values.size()-1, found=-1;
        while(low<=high){int mid=low+(high-low)/2;++comparisons;frame(mid,low,high,1,"Inspect midpoint",QString("Middle value %1 is compared with target %2.").arg(values[mid]).arg(target));if(values[mid]==target){found=mid;break;}if(values[mid]<target)low=mid+1;else high=mid-1;}
        ExecutionStep done;done.values=values;done.nodeIds=ids;done.comparisons=comparisons;done.activeA=found;done.pseudocodeLine=4;done.operation=found>=0?"Target found":"Target not found";done.narration=found>=0?QString("Found %1 at index %2 after %3 comparison(s).").arg(target).arg(found).arg(comparisons):QString("Target %1 is not in the sorted sequence.").arg(target);done.why=QString("Each comparison removes half of the remaining search range, giving O(log n) time and O(1) extra space.");done.variables={{"target",target},{"index",found},{"low",low},{"high",high},{"comparisons",comparisons},{"array",describeSearchValues(values)}};done.complete=true;steps.push_back(done);
    }
    return steps;
}
