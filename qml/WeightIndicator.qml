import Felgo
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

Rectangle {
    required property int weightTotal
    required property int weightLeft
    required property string weightUnit

    required property string primaryColor
    required property string secondaryColor

    color: primaryColor

    Rectangle {
        id: rectSecondaryColor
        color: secondaryColor

        height: parent.height
        width: parent.width
        visible: false
    }

    MultiEffect {
        source: rectSecondaryColor
        anchors.fill: rectSecondaryColor

        maskEnabled: true
        maskSource: Image {
            source: "../assets/texture.png"
            fillMode: Image.PreserveAspectCrop
        }
        maskThresholdMax: 0.7
        maskThresholdMin: 0.3
        maskSpreadAtMax: 0.7
        maskSpreadAtMin: 0.7
    }

    Rectangle {
        id: rectWeightLeft
        color: "black"
        opacity: 0.4
        height: parent.height * ((weightTotal - weightLeft) / weightTotal)
        width: parent.width
        anchors.bottom: parent.bottom
    }

    AppText {
        id: txtWeightLeft
        text: weightLeft + weightUnit
        color: "white"
        elide: Text.ElideRight
        width: parent.width // for elide
        maximumLineCount: 1 // for elide
        horizontalAlignment: Text.AlignHCenter
        anchors.top: parent.top
        anchors.topMargin: 2
    }

    AppText {
        id: txtWeightTotal
        text: "/" + weightTotal + weightUnit
        color: "white"
        opacity: 0.6
        elide: Text.ElideRight
        width: parent.width // for elide
        maximumLineCount: 1 // for elide
        horizontalAlignment: Text.AlignHCenter
        anchors.top: txtWeightLeft.bottom
        anchors.topMargin: 2
    }
}
