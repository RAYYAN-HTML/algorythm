#include "bubblesort.h"
#include <QtGlobal>
#include <functional>
#include <QStringList>

static QString describeValues(const QVector<int> &values)
{
    QStringList items;
    for (int value : values) items << QString::number(value);
    return items.join(", ");
}

QStringList SortingAlgorithms::names()
{
    return {"Bubble Sort", "Selection Sort", "Insertion Sort", "Merge Sort", "Quick Sort"};
}

QVector<ExecutionStep> SortingAlgorithms::generate(const QString &name, const QVector<int> &input)
{
    if (name == "Linear Search" || name == "Binary Search") return search(name, input, 6);
    if (name == "Bubble Sort") return BubbleSort::generate(input);
    QVector<ExecutionStep> steps;
    QVector<int> a = input;
    QVector<int> ids; for (int i = 0; i < input.size(); ++i) ids << i;
    int comparisons = 0, swaps = 0, writes = 0;
    auto record = [&](int x, int y, int line, const QString &op, const QString &narration, const QString &why, QVariantMap variables) {
        ExecutionStep s; s.values = a; s.nodeIds = ids; s.activeA = x; s.activeB = y; s.pseudocodeLine = line;
        s.comparisons = comparisons; s.swaps = swaps; s.writes = writes;
        variables.insert("comparisons", comparisons); variables.insert("swaps", swaps); variables.insert("writes", writes);
        variables.insert("array", describeValues(a));
        s.variables = variables; s.operation = op; s.narration = narration; s.why = why; steps.push_back(s);
    };
    record(-1, -1, 0, "Ready to sort", QString("%1 is ready to sort %2 values.").arg(name).arg(a.size()), "The algorithm trace records every meaningful operation so playback and rewind show the exact earlier state.", {{"n", a.size()}});
    if (name == "Selection Sort") {
        for (int i = 0; i < a.size(); ++i) {
            int min = i;
            for (int j = i + 1; j < a.size(); ++j) {
                ++comparisons;
                record(min, j, 2, "Find minimum", QString("Comparing candidate minimum %1 with %2.").arg(a[min]).arg(a[j]), "Selection Sort scans the remaining suffix to find its smallest value.", {{"i", i}, {"j", j}, {"minIndex", min}});
                if (a[j] < a[min]) min = j;
            }
            if (min != i) { int x=a[i], y=a[min]; qSwap(a[i],a[min]); qSwap(ids[i],ids[min]); ++swaps; writes+=2; record(i,min,4,"Place minimum",QString("Move the minimum %1 into position %2.").arg(y).arg(i),"Each pass places one minimum value at the beginning of the unsorted suffix.", {{"i", i}, {"minIndex", min}}); }
        }
    } else if (name == "Insertion Sort") {
        for (int i=1;i<a.size();++i) {
            int j=i;
            while(j>0) {
                const int key=a[j];
                ++comparisons;
                record(j-1,j,2,"Compare key",QString("Compare key %1 with its preceding value %2.").arg(key).arg(a[j-1]),"Insertion Sort grows a sorted prefix by moving the next value left until it reaches its correct position.", {{"i", i}, {"j", j}, {"key", key}});
                if(a[j-1]<=a[j]) break;
                qSwap(a[j-1],a[j]); qSwap(ids[j-1],ids[j]); ++swaps; writes+=2;
                record(j-1,j,3,"Swap key left",QString("Move %1 one position left past %2.").arg(a[j-1]).arg(a[j]),"The out-of-order adjacent pair swaps. This keeps each node visible and preserves the order of equal values.", {{"i", i}, {"j", j-1}, {"key", a[j-1]}});
                --j;
            }
        }
    } else {
        // Quick Sort uses the last element as pivot and Lomuto partitioning.
        std::function<void(int,int)> quick = [&](int low,int high) { if(low>=high) return; int pivot=a[high], i=low;
            for(int j=low;j<high;++j) { ++comparisons; record(j,high,2,"Compare with pivot",QString("Compare %1 with pivot %2.").arg(a[j]).arg(pivot),"Lomuto partition moves values no greater than the pivot into the left partition.", {{"low", low}, {"high", high}, {"i", i}, {"j", j}, {"pivot", pivot}});
                if(a[j]<=pivot) { if(i!=j) { qSwap(a[i],a[j]); qSwap(ids[i],ids[j]); ++swaps; writes+=2; record(i,j,3,"Partition swap",QString("Move %1 into the left partition.").arg(a[i]),"This swap maintains the partition invariant: values to the left are no greater than the pivot.", {{"low", low}, {"high", high}, {"i", i}, {"j", j}, {"pivot", pivot}}); } ++i; }
            }
            if(i!=high) { qSwap(a[i],a[high]); qSwap(ids[i],ids[high]); ++swaps; writes+=2; } record(i,high,4,"Place pivot",QString("Pivot %1 is now in its final position.").arg(pivot),"After partitioning, no value crosses the pivot's final position.", {{"low", low}, {"high", high}, {"pivotIndex", i}, {"pivot", pivot}}); quick(low,i-1); quick(i+1,high);
        };
        if(name=="Quick Sort") quick(0,a.size()-1);
        else {
            // Merge Sort recursively divides ranges, then records a stable, identity-preserving merge.
            std::function<void(int,int)> merge = [&](int lo,int hi) {
                if(hi-lo<2)return;
                const int mid=(lo+hi)/2;
                merge(lo,mid); merge(mid,hi);
                QVector<int> left,leftIds,right,rightIds,merged,mergedIds;
                for(int p=lo;p<mid;++p){left<<a[p];leftIds<<ids[p];}
                for(int p=mid;p<hi;++p){right<<a[p];rightIds<<ids[p];}
                int l=0,r=0,k=lo;
                auto projectMergeState = [&] {
                    int p=lo;
                    for(int t=0;t<merged.size();++t){a[p]=merged[t];ids[p++]=mergedIds[t];}
                    for(int t=l;t<left.size();++t){a[p]=left[t];ids[p++]=leftIds[t];}
                    for(int t=r;t<right.size();++t){a[p]=right[t];ids[p++]=rightIds[t];}
                };
                while(l<left.size()&&r<right.size()){
                    const int leftPosition=k;
                    const int rightPosition=k+(left.size()-l);
                    ++comparisons;
                    record(leftPosition,rightPosition,4,"Merge compare",QString("Choose between %1 and %2.").arg(left[l]).arg(right[r]),"Merge Sort combines two sorted halves by repeatedly taking the smaller front value.", {{"lo", lo}, {"mid", mid}, {"hi", hi}, {"leftIndex", l}, {"rightIndex", r}, {"writeIndex", k}});
                    if(left[l]<=right[r]){merged<<left[l];mergedIds<<leftIds[l];++l;}
                    else{merged<<right[r];mergedIds<<rightIds[r];++r;}
                    ++writes; ++k; projectMergeState();
                    record(k-1,-1,5,"Write merged value",QString("Write %1 into the merged range.").arg(a[k-1]),"The next smallest node moves into the output prefix while every remaining node stays visible.", {{"lo", lo}, {"mid", mid}, {"hi", hi}, {"leftIndex", l}, {"rightIndex", r}, {"writeIndex", k-1}});
                }
                while(l<left.size()){
                    merged<<left[l];mergedIds<<leftIds[l];++l;++writes;++k;projectMergeState();
                    record(k-1,-1,6,"Copy remainder",QString("Copy %1 into the merged range.").arg(a[k-1]),"The remaining left-half values are already sorted, so they extend the merged output in order.", {{"lo", lo}, {"mid", mid}, {"hi", hi}, {"leftIndex", l}, {"rightIndex", r}, {"writeIndex", k-1}});
                }
                while(r<right.size()){
                    merged<<right[r];mergedIds<<rightIds[r];++r;++writes;++k;projectMergeState();
                    record(k-1,-1,6,"Copy remainder",QString("Copy %1 into the merged range.").arg(a[k-1]),"The remaining right-half values are already sorted, so they extend the merged output in order.", {{"lo", lo}, {"mid", mid}, {"hi", hi}, {"leftIndex", l}, {"rightIndex", r}, {"writeIndex", k-1}});
                }
            }; merge(0,a.size());
        }
    }
    ExecutionStep done; done.values=a; done.nodeIds=ids; done.comparisons=comparisons; done.swaps=swaps; done.writes=writes; done.variables={{"n", a.size()}, {"comparisons", comparisons}, {"swaps", swaps}, {"writes", writes}, {"array", describeValues(a)}}; done.pseudocodeLine=5; done.operation="Sort complete"; done.narration=QString("Sorted. %1 used %2 comparisons, %3 swaps, and %4 writes.").arg(name).arg(comparisons).arg(swaps).arg(writes); done.why="The algorithm's invariant is satisfied: the sequence is in ascending order."; done.complete=true; steps.push_back(done);
    return steps;
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
        s.variables = {{"target", target}, {"low", low}, {"high", high}, {"index", active}, {"comparisons", comparisons}, {"array", describeValues(values)}};
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
        ExecutionStep done; done.values=values; done.nodeIds=ids; done.comparisons=comparisons; done.activeA=found; done.pseudocodeLine=3; done.operation=found>=0?"Target found":"Target not found"; done.narration=found>=0?QString("Found %1 at index %2 after %3 comparison(s).").arg(target).arg(found).arg(comparisons):QString("Target %1 is not in the sequence.").arg(target); done.why=QString("Linear Search can stop at the first matching value. It has O(n) worst-case time and O(1) extra space."); done.variables={{"target",target},{"index",found},{"comparisons",comparisons},{"array",describeValues(values)}}; done.complete=true; steps.push_back(done);
    } else {
        const bool sorted = std::is_sorted(values.begin(), values.end());
        if (!sorted) { QVector<QPair<int,int>> pairs; for (int i=0;i<values.size();++i) pairs.push_back({values[i],ids[i]}); std::stable_sort(pairs.begin(),pairs.end(),[](const auto &a,const auto &b){return a.first<b.first;}); for (int i=0;i<pairs.size();++i) { values[i]=pairs[i].first; ids[i]=pairs[i].second; } frame(-1,0,values.size()-1,0,"Prepare sorted input",QString("Binary Search requires sorted values, so the input is sorted first: %1.").arg([&]{QStringList p;for(int v:values)p<<QString::number(v);return p.join(", ");}())); }
        int low=0, high=values.size()-1, found=-1;
        while(low<=high){int mid=low+(high-low)/2;++comparisons;frame(mid,low,high,1,"Inspect midpoint",QString("Middle value %1 is compared with target %2.").arg(values[mid]).arg(target));if(values[mid]==target){found=mid;break;}if(values[mid]<target)low=mid+1;else high=mid-1;}
        ExecutionStep done;done.values=values;done.nodeIds=ids;done.comparisons=comparisons;done.activeA=found;done.pseudocodeLine=4;done.operation=found>=0?"Target found":"Target not found";done.narration=found>=0?QString("Found %1 at index %2 after %3 comparison(s).").arg(target).arg(found).arg(comparisons):QString("Target %1 is not in the sorted sequence.").arg(target);done.why=QString("Each comparison removes half of the remaining search range, giving O(log n) time and O(1) extra space.");done.variables={{"target",target},{"index",found},{"low",low},{"high",high},{"comparisons",comparisons},{"array",describeValues(values)}};done.complete=true;steps.push_back(done);
    }
    return steps;
}

QVector<ExecutionStep> BubbleSort::generate(const QVector<int> &input)
{
    QVector<ExecutionStep> steps;
    QVector<int> values = input;
    int comparisons = 0;
    int swaps = 0;
    int writes = 0;

    ExecutionStep initial;
    initial.values = values;
    initial.nodeIds.resize(values.size()); for (int i=0;i<values.size();++i) initial.nodeIds[i]=i;
    initial.operation = "Ready to sort";
    initial.narration = QString("Bubble Sort is ready to process %1 element%2.")
                            .arg(values.size()).arg(values.size() == 1 ? "" : "s");
    initial.why = "Bubble Sort compares neighboring values. An out-of-order pair is swapped, moving the larger value toward the end.";
    initial.variables = {{"n", values.size()}, {"comparisons", 0}, {"swaps", 0}, {"writes", 0}, {"array", describeValues(values)}};
    steps.push_back(initial);

    for (int end = values.size() - 1; end > 0; --end) {
        bool changed = false;
        for (int i = 0; i < end; ++i) {
            ++comparisons;
            ExecutionStep compare;
            compare.values = values; compare.nodeIds = initial.nodeIds;
            compare.activeA = i;
            compare.activeB = i + 1;
            compare.pseudocodeLine = 4;
            compare.comparisons = comparisons;
            compare.swaps = swaps;
            compare.writes = writes;
            compare.variables = {{"i", i}, {"end", end}, {"comparisons", comparisons}, {"swaps", swaps}, {"writes", writes}, {"array", describeValues(values)}};
            compare.operation = "Compare neighbors";
            compare.narration = QString("Comparing %1 and %2.").arg(values[i]).arg(values[i + 1]);
            compare.why = "Bubble Sort checks adjacent pairs from left to right. The larger value in each out-of-order pair moves one position toward the end.";
            steps.push_back(compare);

            if (values[i] > values[i + 1]) {
                const int left = values[i];
                const int right = values[i + 1];
                qSwap(values[i], values[i + 1]);
                qSwap(initial.nodeIds[i], initial.nodeIds[i + 1]);
                ++swaps;
                writes += 2;
                changed = true;

                ExecutionStep swap;
                swap.values = values; swap.nodeIds = initial.nodeIds;
                swap.activeA = i;
                swap.activeB = i + 1;
                swap.pseudocodeLine = 5;
                swap.comparisons = comparisons;
                swap.swaps = swaps;
                swap.writes = writes;
                swap.variables = {{"i", i}, {"end", end}, {"left", values[i]}, {"right", values[i + 1]}, {"comparisons", comparisons}, {"swaps", swaps}, {"writes", writes}, {"array", describeValues(values)}};
                swap.operation = "Swap pair";
                swap.narration = QString("%1 is greater than %2, so the pair swaps. %1 moves one place to the right.").arg(left).arg(right);
                swap.why = QString("The pair is out of ascending order. Exchanging %1 and %2 places the larger value farther toward its final position.").arg(left).arg(right);
                steps.push_back(swap);
            }
        }
        if (!changed)
            break;
    }

    ExecutionStep done;
    done.values = values; done.nodeIds = initial.nodeIds;
    done.comparisons = comparisons;
    done.swaps = swaps;
    done.writes = writes;
    done.variables = {{"n", values.size()}, {"comparisons", comparisons}, {"swaps", swaps}, {"writes", writes}, {"array", describeValues(values)}};
    done.pseudocodeLine = 4;
    done.operation = "Sort complete";
    done.narration = QString("Sorted. Bubble Sort used %1 comparisons and %2 swaps.").arg(comparisons).arg(swaps);
    done.why = "A pass with no swaps means every adjacent pair is already in order, so the full sequence is sorted.";
    done.complete = true;
    steps.push_back(done);
    return steps;
}

