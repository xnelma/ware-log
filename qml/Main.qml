import Felgo
import QtQuick
import QtQuick.LocalStorage
import QtQuick.Controls
import QtCore
import "data.js" as Data

App {
    property bool darkModeEnabled: settings.darkModeEnabled

    property string tintColor: darkModeEnabled? "#373737" : "#c7c7c7"
    property string buttonColor: darkModeEnabled? "#373737" : "#a3a3a3"
    property string backgroundColor: darkModeEnabled? "black" : "white"
    property string textColor: darkModeEnabled? "white" : "black"
    property string tagButtonColor: darkModeEnabled? "#303030" : "#c3c3c3"
    property string tagButtonCheckedColor: darkModeEnabled? "#505050" : "#737373"

    onInitTheme: {
        Theme.colors.tintColor
            = Qt.binding(function() { return tintColor; });
        Theme.colors.backgroundColor
            = Qt.binding(function() { return backgroundColor; });
        Theme.colors.textColor
            = Qt.binding(function() { return textColor; });
        Theme.appButton.backgroundColor
            = Qt.binding(function() { return buttonColor; });
        Theme.navigationBar.shadowHeight = 0
    }

    Settings {
        id: settings
        property bool darkModeEnabled: false
    }

    NavigationStack {
        AppPage {
            id: root
            title: qsTr("Ware Log")

            rightBarItem: IconButtonBarItem {
                iconType: IconType.bars
                onClicked: menu.open()

                Menu {
                    id: menu
                    y: parent.height

                    MenuItem {
                        text: qsTr("Turn Dark Mode %1")
                            .arg(darkModeEnabled ? qsTr("off") : qsTr("on"))
                        onClicked: settings.darkModeEnabled
                                   = !settings.darkModeEnabled
                    }
                }
            }

            AppListView {
                spacing: 10
                anchors.top: parent.top
                anchors.topMargin: 10

                model: ListModel {
                    id: listModel

                    Component.onCompleted: Data.get(listModel);

                    function deleteItem(title) {
                        for (var i = 0; i < listModel.count; i++)
                            if (listModel.get(i).title === title)
                                listModel.remove(i);
                    }
                }

                delegate: CollectionDelegate {
                    width: root.width
                }
            }

            FloatingActionButton {
                iconType: IconType.plussquareo
                onClicked: modalAddItem.open()
                visible: true
            }

            AppModal {
                id: modalAddItem
                pushBackContent: root.navigationStack
                fullscreen: false
                modalHeight: modalContent.contentHeight
                onClosed: modalContent.reset();

                EditItemView { id: modalContent }
            }
        } // root
    } // NavigationStack
}
