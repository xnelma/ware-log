import Felgo
import QtQuick
import QtQuick.LocalStorage
import "data.js" as Data

App {

    NavigationStack {

        AppPage {
            id: root

            title: qsTr("Ware Log")

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
        }
    }
}
