qt_add_executable(WareLog main.cpp)

target_link_libraries(WareLog PRIVATE
    Qt6::Quick
)

qt_add_qml_module(WareLog
    URI WarelogApp
    VERSION 0.1
    QML_FILES
        Main.qml
    SOURCES
)
