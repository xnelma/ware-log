import Felgo
import QtQuick
import QtQuick.LocalStorage
import QtQuick.Controls
import QtCore
import "data.js" as Data

App {
    property bool darkModeEnabled: settings.darkModeEnabled

    onInitTheme: {
        Theme.colors.tintColor = "#c7c7c7"
        Theme.appButton.backgroundColor = "#a3a3a3"
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
