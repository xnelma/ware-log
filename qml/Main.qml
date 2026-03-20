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

                delegate: Item {
                    required property string title

                    width: root.width;
                    height: txtTitle.height + 10

                    AppText {
                        id: txtTitle

                        text: title

                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                    }
                }
            }
        }
    }
}
