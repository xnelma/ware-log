import Felgo
import QtQuick
import QtQuick.Layouts
import "data.js" as Data

Item {
    id: delegate

    width: parent.width
    height: colContent.height + 2
    property color textColor: Theme.colors.textColor

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
        if (tags.length == 0) // But also allow passing a tag list.
            tags = Data.tagList(tagStr);
    }

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
                color: delegate.textColor
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
                color: delegate.textColor
                anchors.centerIn: parent
            }
        }

        Row {
            spacing: 2

            AppText {
                text: delegate.cost + "€"
                font.strikeout: delegate.cost !== delegate.secondaryCost
                color: delegate.textColor
            }

            AppText {
                text: delegate.secondaryCost + "€"
                visible: delegate.cost !== delegate.secondaryCost
                color: delegate.textColor
            }

            AppText {
                text: "/10g"
                opacity: 0.7
                color: delegate.textColor
            }
        }

        AppText {
            text: delegate.ageDescription.arg(delegate.age)
                                         .arg(delegate.ageUnit)
            color: delegate.textColor
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
                        color: delegate.textColor
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
        } // Row

    } // colContent
} // delegate