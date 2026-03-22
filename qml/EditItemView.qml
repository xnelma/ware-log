import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Felgo

AppPage {
    title: qsTr("Add New Item")

    property int contentHeight: col.height
                                + 40 // add bottom margin

    Column {
        id: col
        spacing: 10
        width: parent.width
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10

        AppText {
            text: "navigated to EditItemView"
        }

        MenuSeparator {
            width: parent.width
            padding: 0
        }

        Row {
            spacing: 10
            anchors.right: parent.right

            AppButton {
                text: qsTr("Cancel")
                horizontalMargin: 0
                verticalMargin: 0
                onClicked: {
                    modalAddItem.close()
                }
            }

            AppButton {
                text: qsTr("Add item")
                horizontalMargin: 0
                verticalMargin: 0
                onClicked: {
                    modalAddItem.close();
                    console.log("Add item");
                }
            }
        } // Row
    }
}
