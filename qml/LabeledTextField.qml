import QtQuick
import QtQuick.Layouts
import Felgo

RowLayout {
    id: labeledTextField
    required property string label
    required property string placeholderText
    property string text
    required property string info
    signal infoClicked()
    spacing: 10
    width: parent.width

    AppText {
        id: txtLabel
        text: labeledTextField.label
        Layout.alignment: Qt.AlignVCenter
    }

    AppTextField {
        id: input
        placeholderText: labeledTextField.placeholderText
        text: labeledTextField.text
        Layout.alignment: Qt.AlignVCenter
        Layout.fillWidth: true
    }

    IconButton {
        iconType: IconType.infocircle
        Layout.alignment: Qt.AlignVCenter
        Layout.preferredHeight: txtLabel.height
        Layout.preferredWidth: Layout.preferredHeight
        onClicked: infoClicked()
    }
}
