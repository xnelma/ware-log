import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs
import Felgo
import "data.js" as Data

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
            property string originColor: "#000"

            property int inputWidth:
                (parent.width - btnSetOriginColor.width - 10) / 2;

            CheckedTextField {
                id: inputTitle
                placeholderText: qsTr("Item title")
                width: rowTitle.inputWidth
                anchors.verticalCenter: parent.verticalCenter
            }

            CheckedTextField {
                id: inputOrigin
                placeholderText: qsTr("Origin")
                color: rowTitle.originColor
                placeholderColor: rowTitle.originColor
                width: rowTitle.inputWidth
                anchors.verticalCenter: parent.verticalCenter
            }

            ColorButton {
                id: btnSetOriginColor
                text: "Color"
                colorName: rowTitle.originColor
                onColorNameChanged: rowTitle.originColor = colorName
                minimumWidth: 10
                anchors.verticalCenter: parent.verticalCenter
            }
        } // rowTitle

        ComboBox {
            model: Data.getAllTypes();
            editable: true
        }

        Row {
            id: rowColors
            spacing: 10

            property string primaryColor: "#000"
            property string secondaryColor: "#000"

            ColorButton {
                text: "Color 1"
                colorName: rowColors.primaryColor
                onColorNameChanged: rowColors.primaryColor = colorName
                horizontalMargin: 0
                verticalMargin: 0
            }

            ColorButton {
                text: "Color 2"
                colorName: rowColors.secondaryColor
                onColorNameChanged: rowColors.secondaryColor = colorName
                horizontalMargin: 0
                verticalMargin: 0
            }
        } // rowColors

        property int numFieldWidth: 100

        Row {
            spacing: 10

            CheckedTextField {
                id: inputCost
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

            CheckedTextField {
                id: inputWeight
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

            CheckedTextField {
                id: inputAge
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
            spacing: 5

            component TagButton : AppButton {
                // font.capitalization: Font.MixedCase does not do anything.
                // Only when setting it on the theme.
                iconRight: checked? IconType.checksquareo : IconType.squareo
                checkable: true
                backgroundColor: checked? "#737373" : "#c3c3c3"
                dropShadow: false
                radius: height/2 - 2
                minimumWidth: 10
                horizontalMargin: 0
                verticalMargin: 0
            }

            Repeater {
                model: Data.getAllTags();
                delegate: TagButton {
                    text: modelData
                }
            } // Repeater

            Repeater {
                id: repeaterNewTags

                property list<string> newTags;

                model: newTags
                delegate: TagButton {
                    text: modelData
                    checked: true
                }
            } // Repeater

            AppTextField {
                id: inputNewTag
                placeholderText: qsTr("New tag")
            }

            AppButton {
                text: "+"
                onClicked: {
                    var newTag = inputNewTag.text;
                    if (newTag === "")
                        return;
                    // The tag would only be added to the database, if the item
                    // is added to it with the tag set.
                    repeaterNewTags.newTags.push(newTag);
                    inputNewTag.clear();
                }
                radius: height / 2
                minimumWidth: 0
                horizontalMargin: 0
                verticalMargin: 0
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
                    if (fieldsAreFilled()) {
                        modalAddItem.close();
                        console.log("Add item");
                    }
                }

                function fieldsAreFilled() {
                    // go over all fields instead of just highlighting the first
                    // field.
                    var titleOk = inputTitle.ok();
                    var originOk = inputOrigin.ok();
                    var costOk = inputCost.ok();
                    var weightOk = inputWeight.ok();
                    var ageOk = inputAge.ok();
                    // TODO also check for an empty type input.
                    return titleOk && originOk && costOk && weightOk && ageOk;
                }
            }
        } // Row
    } // col

    component CheckedTextField : AppTextField {
        id: inputChecked
        property color prevPlaceholderColor

        function ok() {
            if (inputChecked.text !== "")
                return true;
            if (resetPlaceholderColor.enabled)
                // Only highlight once.
                // Otherwise the highlight color would override
                // prevPlaceholderColor.
                return false;
            inputChecked.prevPlaceholderColor = inputChecked.placeholderColor;
            inputChecked.placeholderColor = "red";
            resetPlaceholderColor.enabled = true;
            return false;
        }

        Connections {
            id: resetPlaceholderColor
            target: inputChecked
            enabled: false
            function onFocusChanged() {
                inputChecked.placeholderColor = inputChecked.prevPlaceholderColor
                resetPlaceholderColor.enabled = false;
            }
        }
    }

    component ColorButton : AppButton {
        property string colorName
        backgroundColor: colorName
        onClicked: {
            dialogColor.selectedColor = colorName;
            connectDialogColor.enabled = true;
            dialogColor.open();
        }

        Connections {
            id: connectDialogColor
            target: dialogColor
            enabled: false
            function onAccepted() {
                colorName = dialogColor.selectedColor;
                connectDialogColor.enabled = false;
            }
        }
    }

    ColorDialog {
        id: dialogColor
    }
} // AppPage
