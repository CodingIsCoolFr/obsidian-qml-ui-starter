cmake_minimum_required(VERSION 3.24)

project(ObsidianQmlUiStarter VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

find_package(Qt6 6.5 REQUIRED COMPONENTS Core Gui Qml Quick QuickControls2)
qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(obsidian-ui-starter
    src/main.cpp
)

qt_add_qml_module(obsidian-ui-starter
    URI ObsidianStarter
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/Theme.qml
        qml/ThemeStudio.qml
        qml/components/UiButton.qml
        qml/components/UiCard.qml
        qml/components/UiNavButton.qml
        qml/components/UiSlider.qml
        qml/components/UiSwitch.qml
        qml/components/StatusBadge.qml
)

target_link_libraries(obsidian-ui-starter PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::QuickControls2
)

if(WIN32)
    set_target_properties(obsidian-ui-starter PROPERTIES WIN32_EXECUTABLE TRUE)
endif()

install(TARGETS obsidian-ui-starter
    BUNDLE DESTINATION .
    RUNTIME DESTINATION bin
)
