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

        Row {
            id: rowTitle
            spacing: 10
            width: parent.width
            property string placeholderOriginColor: "#457" // Dark softer blue

            property int inputWidth:
                (parent.width - btnSetOriginColor.width - 10) / 2;

            AppTextField {
                placeholderText: qsTr("Item title")
                width: rowTitle.inputWidth
                anchors.verticalCenter: parent.verticalCenter
            }

            AppTextField {
                placeholderText: qsTr("Origin")
                color: rowTitle.placeholderOriginColor
                placeholderColor: rowTitle.placeholderOriginColor
                width: rowTitle.inputWidth
                anchors.verticalCenter: parent.verticalCenter

            }

            AppButton {
                id: btnSetOriginColor
                text: "Color"
                backgroundColor: rowTitle.placeholderOriginColor
                minimumWidth: 10
                anchors.verticalCenter: parent.verticalCenter
            }
        } // rowTitle

        ComboBox {
            model: ["Type 1", "Type 2"]
            editable: true
        }

        Row {
            id: rowColors
            spacing: 10

            property string placeholderPrimaryColor: "#e3aae3" // light pink
            property string placeholderSecondaryColor: "#a353a3" // darker pink

            AppButton {
                text: "Color 1"
                backgroundColor: rowColors.placeholderPrimaryColor
                horizontalMargin: 0
                verticalMargin: 0
            }

            AppButton {
                text: "Color 2"
                backgroundColor: rowColors.placeholderSecondaryColor
                horizontalMargin: 0
                verticalMargin: 0
            }
        } // rowColors

        property int numFieldWidth: 100

        Row {
            spacing: 10

            AppTextField {
                placeholderText: qsTr("Cost")
                inputMethodHints: Qt.ImhDigitsOnly
                width: col.numFieldWidth
                anchors.verticalCenter: parent.verticalCenter
            }

            AppText {
                text: "€ / "
                anchors.verticalCenter: parent.verticalCenter
            }

            ComboBox {
                model: ["10g", "100g", "1kg", "10ml", "100ml", "1l"]
                anchors.verticalCenter: parent.verticalCenter
            }
        } // Row

        Row {
            spacing: 10

            AppTextField {
                placeholderText: qsTr("Weight")
                inputMethodHints: Qt.ImhDigitsOnly
                width: col.numFieldWidth
                anchors.verticalCenter: parent.verticalCenter
            }

            ComboBox {
                id: comboWeightUnit
                model: ["g", "kg", "l", "ml"]
                anchors.verticalCenter: parent.verticalCenter
            }
        } // Row

        Row {
            spacing: 10

            AppTextField {
                placeholderText: qsTr("Age")
                inputMethodHints: Qt.ImhDigitsOnly
                width: col.numFieldWidth
                anchors.verticalCenter: parent.verticalCenter
            }

            ComboBox {
                id: comboAgeUnit
                model: ["months", "years"]
                anchors.verticalCenter: parent.verticalCenter
            }
        } // Row

        Flow {
            width: parent.width
            spacing: 10

            Repeater {
                anchors.horizontalCenter: parent.horizontalCenter
                model: ["Tag 1", "Tag 2", "Tag 3"]
                delegate: AppButton {
                    text: modelData
                    checkable: true
                    backgroundColor: checked? "#737373" : "#c3c3c3"
                    dropShadow: false
                    radius: height/2 - 5
                    minimumWidth: 10
                    horizontalMargin: 0
                    verticalMargin: 0
                }
            } // Repeater

            AppTextField {
                placeholderText: qsTr("+ New tag")
            }
        } // Flow

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
