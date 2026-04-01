import Felgo
import QtQuick
import QtQuick.Controls as QtControls
// The Dialog component is named the same for both Felgo and QtQuick

Dialog {
    id: numberInputDialog

    required property string label
    required property string placeholderText
    required property string errorMessage
    required property int maxNum

    autoSize: true

    Column {
        spacing: 10
        width: parent.width - 40 // subtract horizontal dialog margins
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 10

        Row {
            spacing: 10
            width: parent.width

            AppText {
                text: numberInputDialog.label
                anchors.verticalCenter: parent.verticalCenter
            }

            AppTextField {
                id: inputNumber
                placeholderText: numberInputDialog.placeholderText
                inputMethodHints: Qt.ImhDigitsOnly
                width: 100
                enabled: numberInputDialog.isOpen
                // Switching light/dark mode otherwise focuses the input.
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        AppText {
            id: txtMaxNumberWarning
            color: "red"
            text: numberInputDialog.errorMessage
            width: parent.width
            visible: false
        }

        QtControls.MenuSeparator {
            width: parent.width
            padding: 0
            bottomPadding: 10
        }
    }

    onAccepted: {
        if (inputNumber.text === "") {
            reset();
            close();
            return;
        }
        var num = Number(inputNumber.text);
        if (num > maxNum) {
            txtMaxNumberWarning.visible = true;
            return;
        }

        console.log("save number " + inputNumber.text);

        reset();
        close();
    }

    onCanceled: {
        reset();
        close();
    }

    function reset() {
        txtMaxNumberWarning.visible = false;
        inputNumber.text = "";
    }
}
