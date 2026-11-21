cmake_minimum_required(VERSION 3.21)
project(Algorythm VERSION 1.3.0 LANGUAGES CXX)

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
    src/algorithms/sortingalgorithms.cpp
    src/algorithms/searchalgorithms.cpp
    src/engine/playbackcontroller.cpp
    src/controllers/structurecontroller.cpp
    src/controllers/graphcontroller.cpp
    src/controllers/settingscontroller.h
)

qt_add_qml_module(Algorythm
    URI Algorythm
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/components/AppTheme.qml
        qml/components/AlgorithmNode.qml
        qml/components/PlaybackControls.qml
        qml/components/PseudocodePanel.qml
        qml/components/NarrationPanel.qml
        qml/components/StatisticsPanel.qml
        qml/components/VariablesPanel.qml
        qml/components/Icon.qml
        qml/components/AppLogo.qml
        qml/components/AlgorithmInputBar.qml
        qml/components/ComplexityPanel.qml
        qml/components/PredictionChallenge.qml
        qml/components/GraphPredictionChallenge.qml
        qml/components/ComparisonPlaybackControls.qml
        qml/components/LabCard.qml
        qml/components/SettingsPopup.qml
        qml/components/NavigationSidebar.qml
        qml/components/StatCard.qml
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
    find_package(Qt6 6.2 REQUIRED COMPONENTS Test)
    add_executable(AlgorythmAlgorithmTests tests/algorithm_tests.cpp src/algorithms/sortingalgorithms.cpp src/algorithms/searchalgorithms.cpp src/engine/playbackcontroller.cpp src/controllers/structurecontroller.cpp src/controllers/graphcontroller.cpp src/controllers/settingscontroller.h)
    target_include_directories(AlgorythmAlgorithmTests PRIVATE src)
    target_link_libraries(AlgorythmAlgorithmTests PRIVATE Qt6::Core Qt6::Test)
    add_test(NAME algorithm_generators COMMAND AlgorythmAlgorithmTests)
    set_tests_properties(algorithm_generators PROPERTIES TIMEOUT 30)
    find_program(QMLTESTRUNNER_EXECUTABLE NAMES qmltestrunner qmltestrunner.exe REQUIRED)
    add_test(NAME qml_component_tests
        COMMAND ${QMLTESTRUNNER_EXECUTABLE} -input ${CMAKE_CURRENT_SOURCE_DIR}/tests -platform offscreen)
    set_tests_properties(qml_component_tests PROPERTIES
        TIMEOUT 60
        ENVIRONMENT "QT_QUICK_CONTROLS_STYLE=Basic"
    )
endif()

