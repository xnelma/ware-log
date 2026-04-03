import Felgo
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

Rectangle {
    id: wiRoot

    required property int weightTotal
    required property int weightLeft
    required property string weightUnit

    required property string mainColor
    property string textureColor: mainColor
    property string borderColor: mainColor

    enum Texture { None, Noise }

    property int borderWidth: 0
    property int textureType: WeightIndicator.None
    property int textureHeight: height
    property int textureWidth: width
    property bool editable: false
    property bool smooth: false

    color: mainColor

    Rectangle {
        id: rectTextureColor
        color: textureColor
        visible: false
        height: parent.height
        width: parent.width
    }

    MultiEffect {
        source: rectTextureColor
        anchors.fill: rectTextureColor

        property bool enabled: textureType == WeightIndicator.Noise
            && textureColor !== mainColor
        visible: enabled
        maskEnabled: enabled
        maskSource: mask
        maskThresholdMax: 0.7
        maskThresholdMin: 0.3
        maskSpreadAtMax: 0.7
        maskSpreadAtMin: 0.7
    }

    // Needs to be outside MultiEffect to enable layers, so to use it as texture
    Image {
        id: mask
        source: "../assets/texture.png"
        visible: false
        height: parent.height
        width: parent.width
        fillMode: Image.Image.PreserveAspectCrop
        // render offscreen
        // - reduce aliasing
        // - enable changing the texture size
        layer.enabled: true
        layer.live: wiRoot.editable
        layer.smooth: wiRoot.smooth
        layer.textureSize: Qt.size(textureWidth, textureHeight)
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
