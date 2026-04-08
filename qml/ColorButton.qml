import Felgo
import QtQuick
import QtQuick.Dialogs

AppButton {
    property string colorName
    backgroundColor: colorName
    textColor: colorButtonTextColor
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

    ColorDialog {
        id: dialogColor
    }
}