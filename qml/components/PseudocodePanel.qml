import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    property color panelColor: "#17172A"
    color: panelColor
 radius: 14
 border.color: "#29243E"
    implicitHeight: 258
    ColumnLayout {
        anchors.fill: parent
 anchors.margins: 16
 spacing: 10
        RowLayout { Label { text: "{ }"
 color: "#A855F7"
 font.bold: true }
 Label { text: "Pseudocode"
 color: "#F8FAFC"
 font.bold: true
 font.pixelSize: 13 }
 Item { Layout.fillWidth: true }
 Label { text: "C++ logic"
 color: "#94A3B8"
 font.pixelSize: 10 } }
        Repeater {
            model: {
                if (playback.algorithm === "Linear Search") return ["for i ← 0 to n − 1", "    if A[i] = target", "        return i", "return not found"]
                if (playback.algorithm === "Binary Search") return ["low ← 0; high ← n − 1", "while low ≤ high", "    mid ← low + (high − low) / 2", "    if A[mid] = target: return mid", "    if A[mid] < target: low ← mid + 1", "    else: high ← mid − 1"]
                if (playback.algorithm === "Selection Sort") return ["for i ← 0 to n − 1", "    min ← i", "    for j ← i + 1 to n − 1", "        if A[j] < A[min]: min ← j", "    swap A[i], A[min]"]
                if (playback.algorithm === "Insertion Sort") return ["for i ← 1 to n − 1", "    j ← i", "    while j > 0 and A[j − 1] > A[j]", "        swap(A[j − 1], A[j])", "        j ← j − 1"]
                if (playback.algorithm === "Merge Sort") return ["split range into halves", "sort(left half)", "sort(right half)", "while both halves have values", "    write smaller front value", "copy remaining values"]
                if (playback.algorithm === "Quick Sort") return ["pivot ← last value", "for each value before pivot", "    if value ≤ pivot", "        move value to left side", "place pivot between partitions", "sort both partitions"]
                return ["for end ← n − 1 down to 1", "    swapped ← false", "    for i ← 0 to end − 1", "        if A[i] > A[i + 1]", "            swap(A[i], A[i + 1])", "            swapped ← true", "    if not swapped: stop"]
            }
            delegate: Rectangle {
                Layout.fillWidth: true
 height: 21
 radius: 4
                color: playback.pseudocodeLine === index + 1 ? "#30204E" : "transparent"
                Text { anchors.fill: parent
 anchors.leftMargin: 8
 verticalAlignment: Text.AlignVCenter
 text: (index + 1).toString().padStart(2, "0") + "   " + modelData
 color: playback.pseudocodeLine === index + 1 ? "#C4B5FD" : "#94A3B8"
 font.family: "Consolas"
 font.pixelSize: 10 }
            }
        }
    }
}

