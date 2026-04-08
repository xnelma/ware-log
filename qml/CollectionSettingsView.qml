import Felgo
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QtControls
import QtQuick.Dialogs
import "data.js" as Data

AppPage {
    title: qsTr("Collection Settings")

Flickable {
    anchors.fill: parent
    contentHeight: content.height

Column {
    id: content
    anchors.fill: parent
    anchors.margins: 10
    anchors.topMargin: 0
    spacing: 10

    CollectionDelegatePreview {
        mainColor: colColors.defaultMainColor
        textureColor: colColors.defaultTextureColor
        borderColor: colColors.defaultBorderColor
        ageDescription: rowAgeContext.ageContext
        borderWidth: sliderBorderWidth.value
        textureType: comboTexture.currentIndex
        textureWidth: sliderWidth.value
        textureHeight: sliderHeight.value
        editable: true
        smooth: switchSmooth.checked
        // remove parent margin and hide borders at sides:
        width: parent.width + 20 + border.width * 2
        x: - 10 - border.width
    }

    AppText {
        text: qsTr("Domain settings:")
        opacity: 0.3
    }

    LabeledTextField {
        label: qsTr("Name:")
        placeholderText: qsTr("Enter Name")
        text: Data.getDomainName()
        onTextChanged: Data.setDomainName(text)
        info: qsTr("The name of your collection. E.g. My Sand Collection")
        onInfoClicked: {
            dlgInfo.message = info;
            dlgInfo.open();
        }
    }

    LabeledTextField {
        label: qsTr("Domain:")
        placeholderText: qsTr("Enter Domain")
        text: Data.getDomainType()
        onTextChanged: Data.setDomainType(text)
        info: qsTr("The domain of your collection. E.g. Sand, Lemonade, ...")
        onInfoClicked: {
            dlgInfo.message = info;
            dlgInfo.open();
        }
    }

    Row {
        spacing: 10

        AppText {
            id: txtAgeContextLabel
            text: qsTr("Age context:")
            anchors.verticalCenter: parent.verticalCenter
        }

        IconButton {
            iconType: IconType.infocircle
            Layout.alignment: Qt.AlignVCenter
            height: txtAgeContextLabel.height
            width: height
            onClicked: {
                dlgInfo.message = qsTr("The context of 'age' in your domain, "
                    + "e.g. \"collected <n> <dmwy> ago\" (collected 2 months "
                    + "ago)")
                dlgInfo.open();
            }
        }
    }

    Row {
        id: rowAgeContext
        spacing: 10
        width: parent.width

        property string ageContext: Data.formatDomainAgeContext(
            inputAgeContext1.text, inputAgeContext2.text)

        AppTextField {
            id: inputAgeContext1
            placeholderText: qsTr("Input context")
            text: Data.getDomainAgeContextPrefix()
            onTextChanged: Data.setDomainAgeContextPrefix(text)
        }

        AppText {
            id: txtAgeContextSample
            text: qsTr("2 months")
            opacity: 0.7
            anchors.verticalCenter: parent.verticalCenter
        }

        AppTextField {
            id: inputAgeContext2
            placeholderText: qsTr("Input context")
            text: Data.getDomainAgeContextSuffix()
            onTextChanged: Data.setDomainAgeContextSuffix(text);
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - inputAgeContext1.width - 10
                                - txtAgeContextSample.width - 10
        }
    }

    AppText {
        text: qsTr("Item image style:")
    }

    RowLayout {
        spacing: 10
        width: parent.width

        AppText {
            text: qsTr("Border width: ")
            opacity: 0.5
            Layout.alignment: Qt.AlignVCenter
        }

        AppSlider {
            id: sliderBorderWidth
            from: 0
            to: 10
            value: Data.getDomainBorderWidth()
            // This handler is called very often; not just on releasing the
            // slider but with every movement. There are no performance issues
            // though, so leave it for now.
            onValueChanged: Data.setDomainBorderWidth(value)
            padding: 0
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true
        }
    }

    RowLayout {
        uniformCellSizes: true // Make the combobox span half the full width
        height: comboTexture.height
        width: parent.width

        LightDarkComboBox {
            id: comboTexture
            model: ["No Texture", "Noise"]
            currentIndex: Data.getDomainTextureType()
            onCurrentIndexChanged: Data.setDomainTextureType(currentIndex)
            Layout.fillWidth: true
        }

        // Center in cell:
        Row {
            spacing: 10
            Layout.alignment: Qt.AlignCenter

            AppText {
                text: qsTr("Smooth:")
                opacity: 0.5
            }

            AppSwitch {
                id: switchSmooth
                checked: Data.getDomainTextureSmooth()
                onCheckedChanged: Data.setDomainTextureSmooth(checked)
            }
        }
    }

    AppText {
        text: qsTr("Scale texture:")
        opacity: 0.5
    }

    GridLayout {
        columns: 2
        rows: 2
        columnSpacing: 10
        rowSpacing: 10
        width: parent.width

        AppText {
            text: qsTr("v:") // vertical
            Layout.row: 0
            Layout.column: 0
        }

        AppSlider {
            id: sliderHeight
            from: 1
            to: 400
            value: Data.getDomainTextureHeight()
            onValueChanged: Data.setDomainTextureHeight(value)
            padding: 0
            Layout.row: 0
            Layout.column: 1
            Layout.fillWidth: true
        }

        AppText {
            text: qsTr("h:") // horizontal
            Layout.row: 1
            Layout.column: 0
        }

        AppSlider {
            id: sliderWidth
            from: 1
            to: 400
            value: Data.getDomainTextureWidth();
            onValueChanged: Data.setDomainTextureWidth(value);
            padding: 0
            Layout.row: 1
            Layout.column: 1
            Layout.fillWidth: true
        }
    } // GridLayout

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
                onClicked: {
                    var colors = Data.getRandomColors();
                    colColors.defaultMainColor = colors[0];
                    colColors.defaultTextureColor = colors[1];
                    colColors.defaultBorderColor = colors[2];
                }
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

        property string defaultMainColor: {
            var c = Data.getDomainMainColor();
            return c === "" ? defaultColor : c;
        }
        property string defaultTextureColor: {
            var c = Data.getDomainTextureColor();
            return c === "" ? defaultColor : c;
        }
        property string defaultBorderColor: {
            var c = Data.getDomainBorderColor();
            return c === "" ? defaultColor : c;
        }

        ColorButton {
            id: btnColorMain
            text: qsTr("Default Main Color")
            colorName: colColors.defaultMainColor
            onColorNameChanged: {
                colColors.defaultMainColor
                    = Qt.binding(function() { return colorName });
                Data.setDomainMainColor(colorName);
            }
            horizontalMargin: 0
            verticalMargin: 0
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        ColorButton {
            id: btnColorTexture
            text: qsTr("Default Texture Color")
            colorName: colColors.defaultTextureColor
            onColorNameChanged: {
                colColors.defaultTextureColor
                    = Qt.binding(function() { return colorName });
                Data.setDomainTextureColor(colorName);
            }
            horizontalMargin: 0
            verticalMargin: 0
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        ColorButton {
            id: btnColorBorder
            text: qsTr("Default Border Color")
            colorName: colColors.defaultBorderColor
            onColorNameChanged: {
                colColors.defaultBorderColor
                    = Qt.binding(function() { return colorName });
                Data.setDomainBorderColor(colorName);
            }
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
