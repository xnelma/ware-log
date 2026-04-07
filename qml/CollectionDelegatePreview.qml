import QtQuick
import Felgo

Rectangle {
    id: cdpRoot

    property string title: "Title"
    property string origin: "Origin"
    property string originColor: textColor
    property string type: "Type"
    property int age: 2
    property string ageUnit: "months"
    property int weightTotal: 10
    property int weightLeft: 9
    property string weightUnit: "g"
    property int cost: 3
    property int secondaryCost: 3
    property string mainColor: defaultColor
    property string textureColor: defaultColor
    property string borderColor: defaultColor
    property list<string> tags: ["Tag 1", "Tag 2", "Tag 3"]

    property string ageDescription: qsTr("collected %1 %2 ago")
    property int borderWidth: 0
    property int textureType: WeightIndicator.None
    property int textureHeight: height
    property int textureWidth: width
    property bool editable: false
    property bool smooth: false

    color: switchDarkStyle.checked? "black" : "white"
    property color textColor: switchDarkStyle.checked? "white" : "black"
    width: parent.width
    height: delegate.height + 20 + 4 // + margin + border width
    border.color: switchDarkStyle.checked ? "#2f2f2f" : "#cfcfcf"
    border.width: 2

    CollectionDelegate {
        id: delegate
        textColor: cdpRoot.textColor
        title: cdpRoot.title
        origin: cdpRoot.origin
        originColor: cdpRoot.originColor
        type: cdpRoot.type
        age: cdpRoot.age
        ageUnit: cdpRoot.ageUnit
        weightTotal: cdpRoot.weightTotal
        weightLeft: cdpRoot.weightLeft
        weightUnit: cdpRoot.weightUnit
        cost: cdpRoot.cost
        secondaryCost: cdpRoot.secondaryCost
        mainColor: cdpRoot.mainColor
        textureColor: cdpRoot.textureColor
        borderColor: cdpRoot.borderColor
        tagStr: ""
        tags: cdpRoot.tags

        ageDescription: cdpRoot.ageDescription
        borderWidth: cdpRoot.borderWidth
        textureType: cdpRoot.textureType
        textureHeight: cdpRoot.textureHeight
        textureWidth: cdpRoot.textureWidth
        editable: cdpRoot.editable
        smooth: cdpRoot.smooth

        width: parent.width - cdpRoot.border.width * 2
        anchors.centerIn: parent
    }

    AppText {
        id: txtPreview
        text: qsTr("Preview")
        color: cdpRoot.textColor
        opacity: 0.3
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 10
    }

    AppText {
        text: qsTr("Dark style:")
        color: cdpRoot.textColor
        anchors.right: switchDarkStyle.left
        anchors.rightMargin: 10
        anchors.verticalCenter: switchDarkStyle.verticalCenter
    }

    AppSwitch {
        id: switchDarkStyle
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.top: txtPreview.bottom
        anchors.topMargin: 10
        checked: darkModeEnabled
    }
} // Rectangle