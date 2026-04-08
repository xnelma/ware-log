import Felgo
import QtQuick
import "data.js" as Data

SwipeOptionsContainer {
    id: swipeOptionsContainer

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

    required property string ageDescription
    required property int borderWidth
    required property int textureType
    required property int textureHeight
    required property int textureWidth
    required property bool editable
    required property bool smooth

    Component.onCompleted: {
        // TODO Somehow the datatype of the string list is lost
        // if I directly append it to the list model.
        // A list<string> would be empty, and a var would get
        // the datatype of QQmlListProperty, but with empty
        // strings. Why?
        if (tags.length == 0) // But also allow passing a tag list.
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
            height: swipeOptionsContainer.height
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
            height: swipeOptionsContainer.height
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

    CollectionDelegate {
        id: content

        title: swipeOptionsContainer.title
        origin: swipeOptionsContainer.origin
        originColor: swipeOptionsContainer.originColor
        type: swipeOptionsContainer.type
        age: swipeOptionsContainer.age
        ageUnit: swipeOptionsContainer.ageUnit
        weightTotal: swipeOptionsContainer.weightTotal
        weightLeft: swipeOptionsContainer.weightLeft
        weightUnit: swipeOptionsContainer.weightUnit
        cost: swipeOptionsContainer.cost
        secondaryCost: swipeOptionsContainer.secondaryCost
        mainColor: swipeOptionsContainer.mainColor
        textureColor: swipeOptionsContainer.textureColor
        borderColor: swipeOptionsContainer.borderColor
        tagStr: swipeOptionsContainer.tagStr
        tags: swipeOptionsContainer.tags

        ageDescription: swipeOptionsContainer.ageDescription
        borderWidth: swipeOptionsContainer.borderWidth
        textureType: swipeOptionsContainer.textureType
        textureHeight: swipeOptionsContainer.textureHeight
        textureWidth: swipeOptionsContainer.textureWidth
        editable: swipeOptionsContainer.editable
        smooth: swipeOptionsContainer.smooth
    }
}
