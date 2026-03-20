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
                }

                delegate: CollectionDelegate {
                    width: root.width
                }
            }
        }
    }
}
