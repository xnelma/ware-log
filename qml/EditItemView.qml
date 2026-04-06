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

        CollectionDelegatePreview {
            originColor: rowTitle.originColor
            mainColor: rowColors.mainColor
            textureColor: rowColors.textureColor
            borderColor: rowColors.borderColor
            borderWidth: 0 // TODO get from database
            textureType: WeightIndicator.Texture.Noise // TODO get from database
            textureHeight: 354 // TODO get from database
            textureWidth: 220 // TODO get from database
            smooth: false // TODO get from database
            // remove parent margin and hide borders at sides:
            width: parent.width + 20 + border.width * 2
            x: - 10 - border.width
        }

        Row {
            id: rowTitle
            spacing: 10
            width: parent.width

            // FIXME The binding does not work properly with AppButton: when
            // starting the app in dark mode, the default for the boolean
            // property is false and when the setting is loaded to true, the
            // new value is not propagated.
            // So when the dialog is started the first time in dark mode, the
            // color buttons are black, thus invisible.
            // Closing and reopening the dialog recreates the binding in the
            // reset() method, so afterwards the colors are correct.
            property string originColor: defaultColor

            // Needed for reset().
            // TODO Why does the property binding not propagate the color change
            // without redoing it?
            onOriginColorChanged: btnSetOriginColor.colorName
                = Qt.binding(function () {return originColor})

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

        Row {
            spacing: 10

            LightDarkComboBox {
                id: comboTypes
                model: Data.getAllTypes();
                editable: true

                function ok() {
                    if (comboTypes.editText !== "")
                        return true;
                    if (txtComboHighlight.visible)
                        return false;
                    txtComboHighlight.visible = true;
                    resetHighlight.enabled = true;
                }

                Connections {
                    id: resetHighlight
                    target: comboTypes
                    enabled: false
                    function onEditTextChanged() {
                        txtComboHighlight.visible = false;
                        resetHighlight.enabled = false;
                    }
                }
            }

            AppIcon {
                id: txtComboHighlight
                iconType: IconType.exclamation
                color: "red"
                visible: false
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Row {
            id: rowColors
            spacing: 10

            property string mainColor: defaultColor
            property string textureColor: defaultColor
            property string borderColor: defaultColor

            // Needed for reset().
            // TODO Why does the property binding have to be redone?
            onMainColorChanged: btnMainColor.colorName
                = Qt.binding(function () {return mainColor})
            onTextureColorChanged: btnTextureColor.colorName
                = Qt.binding(function () {return textureColor})
            onBorderColorChanged: btnBorderColor.colorName
                = Qt.binding(function () {return borderColor})

            ColorButton {
                id: btnMainColor
                text: qsTr("Main Color")
                colorName: rowColors.mainColor
                onColorNameChanged: rowColors.mainColor
                    = Qt.binding(function() { return colorName })
                horizontalMargin: 0
                verticalMargin: 0
            }

            ColorButton {
                id: btnTextureColor
                text: qsTr("Texture Color")
                colorName: rowColors.textureColor
                onColorNameChanged: rowColors.textureColor
                    = Qt.binding(function() { return colorName });
                horizontalMargin: 0
                verticalMargin: 0
            }

            // TODO disable border or texture button if not set for collection.
            ColorButton {
                id: btnBorderColor
                text: qsTr("Border Color")
                colorName: rowColors.borderColor
                onColorNameChanged: rowColors.borderColor
                    = Qt.binding(function() { return colorName });
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

            LightDarkComboBox {
                id: comboCostPerWeightUnit
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

            LightDarkComboBox {
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

            LightDarkComboBox {
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
                opacity: 0.8
                textColor: root.textColor
                backgroundColor: Qt.rgba(textColor.r, textColor.g, textColor.b,
                                         checked? 0.3 : 0.1);
                dropShadow: false
                radius: height/2 - 2
                minimumWidth: 10
                horizontalMargin: 0
                verticalMargin: 0
            }

            component TagRepeater : Repeater {
                id: tagRepeater
                function enableMatchingTag(tag) {
                    // Returns false if no matching tag is found.
                    for (var i = 0; i < tagRepeater.model.length; i++)
                        if (tagRepeater.model[i].toLowerCase()
                            === tag.toLowerCase()) {
                            // Check if not checked yet.
                            if (tagRepeater.itemAt(i).checked !== true)
                                tagRepeater.itemAt(i).checked = true;
                            return true;
                        }
                    return false;
                }

                function selectedTags() {
                    const tags = [];
                    for (var i = 0; i < tagRepeater.model.length; i++)
                        if (tagRepeater.itemAt(i).checked)
                            tags.push(tagRepeater.model[i]);
                    return tags;
                }

                function reset() {
                    for (var i = 0; i < tagRepeater.model.length; i++)
                        if (tagRepeater.itemAt(i).checked)
                            tagRepeater.itemAt(i).checked = false;
                }
            }

            TagRepeater {
                id: repeaterTags
                model: Data.getAllTags();
                delegate: TagButton {
                    text: modelData
                }
            } // TagRepeater

            TagRepeater {
                id: repeaterNewTags

                property list<string> newTags;

                model: newTags
                delegate: TagButton {
                    text: modelData
                    checked: true
                }
            } // TagRepeater

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

                    // Only add the new tag to the repeater, if it is not in
                    // the existing tag list yet,
                    // and not in the new tag list either.
                    if (repeaterTags.enableMatchingTag(newTag)
                        || repeaterNewTags.enableMatchingTag(newTag)) {
                        inputNewTag.clear();
                        return;
                    }

                    // The tag would not be added to the database yet. Only
                    // indirectly later, when the item with the tag is inserted.
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
                        var tags = repeaterTags.selectedTags();
                        tags = tags.concat(repeaterNewTags.selectedTags());
                        var item = {
                            title: inputTitle.text,
                            origin: inputOrigin.text,
                            originColor: rowTitle.originColor,
                            type: comboTypes.editText,
                            mainColor: rowColors.mainColor,
                            textureColor: rowColors.textureColor,
                            borderColor: rowColors.borderColor,
                            cost: Number(inputCost.text),
                            secondaryCost: Number(inputCost.text),
                            weightTotal: Number(inputWeight.text),
                            weightLeft: Number(inputWeight.text),
                            weightUnit: comboWeightUnit.editText,
                            age: Number(inputAge.text),
                            ageUnit: comboAgeUnit.editText,
                            tags: tags};

                        Data.insertItem(item);
                        // The list view takes the stringified tags, not an
                        // array for now.
                        item.tagStr = Data.tagStr(tags);
                        listModel.append(item);

                        modalAddItem.close();
                    }
                }

                function fieldsAreFilled() {
                    // go over all fields instead of just highlighting the first
                    // field.
                    var titleOk = inputTitle.ok();
                    var originOk = inputOrigin.ok();
                    var typesOk = comboTypes.ok();
                    var costOk = inputCost.ok();
                    var weightOk = inputWeight.ok();
                    var ageOk = inputAge.ok();
                    return titleOk && originOk
                           && typesOk
                           && costOk && weightOk && ageOk;
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

    function reset() {
        inputTitle.text = "";
        inputOrigin.text = "";
        rowTitle.originColor = Qt.binding(function() { return defaultColor });
        comboTypes.currentIndex = 0;
        comboTypes.model = Data.getAllTypes();
        rowColors.mainColor = Qt.binding(function() { return defaultColor });
        rowColors.textureColor = Qt.binding(function() { return defaultColor });
        rowColors.borderColor = Qt.binding(function() { return defaultColor });
        inputCost.text = "";
        comboCostPerWeightUnit.currentIndex = 0;
        inputWeight.text = "";
        comboWeightUnit.currentIndex = 0;
        inputAge.text = "";
        comboAgeUnit.currentIndex = 0;
        repeaterTags.reset();
        repeaterTags.model = Data.getAllTags();
        repeaterNewTags.reset();
        repeaterNewTags.newTags = [];
    }
} // AppPage
