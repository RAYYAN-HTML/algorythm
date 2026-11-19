cmake_minimum_required(VERSION 3.21)
project(Algorythm VERSION 1.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 6.2 REQUIRED COMPONENTS Quick QuickControls2)
qt_policy(SET QTP0001 NEW)
qt_policy(SET QTP0004 NEW)

qt_add_executable(Algorythm
    src/main.cpp
    src/algorithms/bubblesort.cpp
    src/engine/playbackcontroller.cpp
    src/controllers/structurecontroller.cpp
    src/controllers/graphcontroller.cpp
)

qt_add_qml_module(Algorythm
    URI Algorythm
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/components/AlgorithmNode.qml
        qml/components/PlaybackControls.qml
        qml/components/PseudocodePanel.qml
        qml/components/NarrationPanel.qml
        qml/components/StatisticsPanel.qml
        qml/components/VariablesPanel.qml
        qml/pages/DashboardPage.qml
        qml/pages/SortingPage.qml
        qml/pages/StructurePage.qml
        qml/pages/ComparisonPage.qml
        qml/pages/GraphPage.qml
)

target_include_directories(Algorythm PRIVATE src)
target_link_libraries(Algorythm PRIVATE Qt6::Quick Qt6::QuickControls2)

include(CTest)
if(BUILD_TESTING)
    add_executable(AlgorythmAlgorithmTests tests/algorithm_tests.cpp src/algorithms/bubblesort.cpp src/engine/playbackcontroller.cpp src/controllers/structurecontroller.cpp src/controllers/graphcontroller.cpp)
    target_include_directories(AlgorythmAlgorithmTests PRIVATE src)
    target_link_libraries(AlgorythmAlgorithmTests PRIVATE Qt6::Core)
    add_test(NAME algorithm_generators COMMAND AlgorythmAlgorithmTests)
endif()

