import Felgo
import QtQuick
import QtQuick.Layouts
import "data.js" as Data

SwipeOptionsContainer {
    id: delegate

    height: content.height

    required property string title
    required property string origin
    required property string originColor
    required property string type
    required property int age
    required property string ageUnit
    required property int weightTotal
    required property int weightLeft
    required property string weightUnit
    required property int cost
    required property int secondaryCost
    required property string mainColor
    required property string textureColor
    required property string borderColor
    required property string tagStr
    property list<string> tags

    property string ageDescription: qsTr("collected %1 %2 ago")

    Component.onCompleted: {
        // TODO Somehow the datatype of the string list is lost
        // if I directly append it to the list model.
        // A list<string> would be empty, and a var would get
        // the datatype of QQmlListProperty, but with empty
        // strings. Why?
        tags = Data.tagList(tagStr);
    }

    rightOption: SwipeButton {
        iconType: IconType.remove
        height: parent.height
        onClicked: {
            Data.deleteItem(title);
            listModel.deleteItem(title);
        }
    }

    // FIXME Swiping both sides or scrolling the list view while swiping
    // sometimes deactivates swiping for an item completely.
    // It happens more often if not just one SwipeButton is used, but the Row.
    leftOption: Row {
        SwipeButton {
            iconType: IconType.money
            height: delegate.height
            onClicked: {
                dlgCostConnection.itemTitle = delegate.title;
                dlgCostConnection.enabled = true;
                dlgUpdateCost.cost = delegate.cost
                dlgUpdateCost.secondaryCost = delegate.secondaryCost
                dlgUpdateCost.open()
            }

            Connections {
                id: dlgCostConnection
                target: dlgUpdateCost
                enabled: false

                property string itemTitle

                function onNumberAccepted(num) {
                    if (itemTitle === delegate.title) {
                        Data.updateCost(delegate.title, num);
                        delegate.secondaryCost = num;
                        dlgCostConnection.enabled = false;
                    }
                }
            }
        }

        SwipeButton {
            iconType: IconType.beer
            height: delegate.height
            onClicked: {
                dlgWeightConnection.itemTitle = delegate.title;
                dlgWeightConnection.enabled = true;
                dlgUpdateWeight.weightTotal = delegate.weightTotal
                dlgUpdateWeight.weightLeft = delegate.weightLeft
                dlgUpdateWeight.weightUnit = delegate.weightUnit
                dlgUpdateWeight.open()
            }

            Connections {
                id: dlgWeightConnection
                target: dlgUpdateWeight
                enabled: false

                property string itemTitle

                function onNumberAccepted(num) {
                    if (itemTitle === delegate.title) {
                        Data.updateWeight(delegate.title, num);
                        delegate.weightLeft = num;
                        dlgWeightConnection.enabled = false;
                    }
                }
            }
        }
    }

    Item {
        id: content

        height: colContent.height + 2

        WeightIndicator {
            id: weightIndicator

            height: parent.height
            width: delegate.width / 7

            weightTotal: delegate.weightTotal
            weightLeft: delegate.weightLeft
            weightUnit: delegate.weightUnit

            mainColor: delegate.mainColor
            textureColor: delegate.textureColor
            borderColor: delegate.borderColor

            textureType: WeightIndicator.Texture.Noise
            textureHeight: height * 3 // approx. 380, the height of texture.png
            textureWidth: width * 4 // approx. 220, the width of texture.png
        }

        Column {
            id: colContent

            anchors.left: weightIndicator.right
            anchors.leftMargin: 10

            Row {
                spacing: 10
                AppText {
                    id: txtTitle

                    text: delegate.title
                    font.bold: true
                }

                AppText {
                    id: txtOrigin

                    text: delegate.origin
                    color: delegate.originColor
                }
            }

            Item {
                height: txtType.height + 2
                width: txtType.width + 4

                Rectangle {
                    height: parent.height
                    width: parent.width
                    color: txtType.color
                    opacity: 0.2
                }

                AppText {
                    id: txtType

                    text: delegate.type

                    anchors.centerIn: parent
                }
            }

            Row {
                spacing: 2

                AppText {
                        text: delegate.cost + "€"
                        font.strikeout: delegate.cost !== delegate.secondaryCost
                }

                AppText {
                    text: delegate.secondaryCost + "€"
                    visible: delegate.cost !== delegate.secondaryCost
                }

                AppText {
                    text: "/10g"
                    opacity: 0.7
                }
            }

            AppText {
                text: delegate.ageDescription.arg(delegate.age)
                                             .arg(delegate.ageUnit)
            }

            Row {
                Repeater {
                    model: delegate.tags

                    Item {
                        required property string modelData

                        height: rectPropBg.height
                        width: rectPropBg.width + 3

                        AppText {
                            id: txtProp

                            text: parent.modelData

                            opacity: 0.8
                            anchors.centerIn: rectPropBg
                        }

                        Rectangle {
                            id: rectPropBg

                            color: txtProp.color
                            opacity: 0.1
                            radius: height / 2 - 2

                            height: txtProp.height + 4
                            width: txtProp.width + 10
                        }

                    }
                }
            }

        }
    }
}
