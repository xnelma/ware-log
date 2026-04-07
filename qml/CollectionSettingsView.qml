import Felgo
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QtControls
import QtQuick.Dialogs

AppPage {
    title: qsTr("Collection Settings")

Flickable {
    anchors.fill: parent
    contentHeight: content.height

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

    Row {
        spacing: 10
        height: txtImageColorsLabel.height + 4

        AppText {
            id: txtImageColorsLabel
            text: qsTr("Item image colors:")
            anchors.verticalCenter: parent.verticalCenter
        }

        // Show some background to group the buttons together: the info button
        // does not relate to the color buttons, but the 'random color' button.
        Item {
            width: btnRandomColors.width + btnRandomColorsInfo.width + 20
            // The margin of 20 is the left margin (10) + the margin between the
            // buttons (5) + a smaller right margin (5) to visually "group" the
            // info button to the button it relates to.
            height: parent.height

            // The rectangle color depends on the text color to not have to
            // specify light and dark colors.
            // But to lower the opacity, the rectangle cannot be the parent item;
            // otherwise the buttons would also be transparent.
            Rectangle {
                color: txtImageColorsLabel.color
                opacity: 0.05
                radius: height / 2
                anchors.fill: parent
            }

            IconButton {
                id: btnRandomColors
                iconType: IconType.random
                height: parent.height
                width: height
                anchors.left: parent.left
                anchors.leftMargin: 10
            }

            IconButton {
                id: btnRandomColorsInfo
                iconType: IconType.infocircle
                height: parent.height
                width: height
                anchors.left: btnRandomColors.right
                anchors.leftMargin: 5
                anchors.top: btnRandomColors.top
                onClicked: {
                    dlgInfo.message = qsTr("Get the colors of a random item in "
                        + "the database.");
                    dlgInfo.open();
                }
            }
        } // Item
    } // Row

    ColumnLayout {
        id: colColors

        property string defaultMainColor: defaultColor
        property string defaultTextureColor: defaultColor
        property string defaultBorderColor: defaultColor

        ColorButton {
            id: btnColorMain
            text: qsTr("Default Main Color")
            colorName: colColors.defaultMainColor
            onColorNameChanged: colColors.defaultMainColor
                = Qt.binding(function() { return colorName });
            horizontalMargin: 0
            verticalMargin: 0
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        ColorButton {
            id: btnColorTexture
            text: qsTr("Default Texture Color")
            colorName: colColors.defaultTextureColor
            onColorNameChanged: colColors.defaultTextureColor
                                = Qt.binding(function() { return colorName });
            horizontalMargin: 0
            verticalMargin: 0
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        ColorButton {
            id: btnColorBorder
            text: qsTr("Default Border Color")
            colorName: colColors.defaultBorderColor
            onColorNameChanged: colColors.defaultBorderColor
                                = Qt.binding(function() { return colorName });
            horizontalMargin: 0
            verticalMargin: 0
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    } // colColors
} // Column
} // Flickable

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
