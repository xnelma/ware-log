import Felgo
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QtControls
import QtQuick.Dialogs

AppPage {
    title: qsTr("Collection Settings")

Column {
    id: content
    anchors.fill: parent
    anchors.margins: 10
    spacing: 10

    AppText {
        text: qsTr("Domain settings:")
        opacity: 0.3
    }

    LabeledTextField {
        label: qsTr("Name:")
        placeholderText: qsTr("Enter Name") // TODO get from database
        info: qsTr("The name of your collection. E.g. My Sand Collection")
        onInfoClicked: {
            dlgInfo.message = info;
            dlgInfo.open();
        }
    }

    LabeledTextField {
        label: qsTr("Domain:")
        placeholderText: qsTr("Enter Domain") // TODO get from database
        info: qsTr("The domain of your collection. E.g. Sand, Lemonade, ...")
        onInfoClicked: {
            dlgInfo.message = info;
            dlgInfo.open();
        }
    }

    QtControls.MenuSeparator {
        width: parent.width
        padding: 0
    }

    AppText {
        text: qsTr("Default values:")
        opacity: 0.3
    }
} // Column

Dialog {
    id: dlgInfo
    property string message
    title: qsTr("Info")
    negativeAction: false
    onAccepted: close()
    autoSize: true

    AppText {
        text: dlgInfo.message
        width: parent.width - 40
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 10
    }
}

} // AppPage
