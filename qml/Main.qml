import Felgo
import QtQuick
import QtQuick.LocalStorage
import QtQuick.Controls
import QtCore
import "data.js" as Data

App {
    id: root

    property bool darkModeEnabled: settings.darkModeEnabled

    property string tintColor: darkModeEnabled? "#373737" : "#c7c7c7"
    property string buttonColor: darkModeEnabled? "#373737" : "#a3a3a3"
    property string backgroundColor: darkModeEnabled? "black" : "white"
    property string textColor: darkModeEnabled? "white" : "black"
    property string colorButtonTextColor: darkModeEnabled? "black" : "white"
    property string defaultColor: darkModeEnabled? "white" : "black"

    property string lightColor: darkModeEnabled? "#222222" : "#dddddd"
    property string lighterColor: darkModeEnabled? "#191919" : "#f6f6f6"
    property string mediumColor: darkModeEnabled? "#444444" : "#bdbdbd"

    onInitTheme: {
        Theme.colors.tintColor
            = Qt.binding(function() { return tintColor; });
        Theme.colors.backgroundColor
            = Qt.binding(function() { return backgroundColor; });
        Theme.colors.textColor
            = Qt.binding(function() { return textColor; });
        Theme.appButton.backgroundColor
            = Qt.binding(function() { return buttonColor; });
        Theme.navigationBar.shadowHeight = 0
    }

    Settings {
        id: settings
        property bool darkModeEnabled: false
    }

    NavigationStack {
        AppPage {
            id: pageMain
            title: qsTr("Ware Log")

            rightBarItem: IconButtonBarItem {
                iconType: IconType.bars
                onClicked: menu.open()

                Menu {
                    id: menu
                    y: parent.height

                    MenuItem {
                        text: qsTr("Turn Dark Mode %1")
                            .arg(darkModeEnabled ? qsTr("off") : qsTr("on"))
                        onClicked: settings.darkModeEnabled
                                   = !settings.darkModeEnabled
                    }

                    MenuItem {
                        text: qsTr("Collection Settings")
                        onClicked: pageMain.navigationStack
                            .push(compCollectionSettings)
                    }
                }
            }

            AppButton {
                text: qsTr("Collection Settings")
                visible: listModel.count === 0
                width: parent.width - 20
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 10
                onClicked: pageMain.navigationStack.push(compCollectionSettings)
            }

            AppListView {
                id: listView
                spacing: 10
                visible: listModel.count > 0
                anchors.top: parent.top
                anchors.topMargin: 10

                model: ListModel {
                    id: listModel

                    Component.onCompleted: Data.get(listModel);

                    function deleteItem(title) {
                        for (var i = 0; i < listModel.count; i++)
                            if (listModel.get(i).title === title)
                                listModel.remove(i);
                    }
                }

                property string ageDescription: Data.formatDomainAgeContext(
                        Data.getDomainAgeContextPrefix(),
                        Data.getDomainAgeContextSuffix())
                property var textureBorderWidth: Data.getDomainBorderWidth()
                property var textureType: Data.getDomainTextureType()
                property var textureHeight: Data.getDomainTextureHeight()
                property var textureWidth: Data.getDomainTextureWidth()
                property bool textureSmooth: Data.getDomainTextureSmooth()

                delegate: SwipableCollectionDelegate {
                    width: pageMain.width

                    ageDescription: listView.ageDescription
                    borderWidth: listView.textureBorderWidth
                    textureType: listView.textureType
                    textureHeight: listView.textureHeight
                    textureWidth: listView.textureWidth
                    editable: false
                    smooth: listView.textureSmooth
                }
            }

            FloatingActionButton {
                iconType: IconType.plussquareo
                onClicked: modalAddItem.open()
                visible: true
            }

            AppModal {
                id: modalAddItem
                pushBackContent: pageMain.navigationStack
                fullscreen: false
                modalHeight: modalContent.contentHeight
                onClosed: modalContent.reset();

                EditItemView { id: modalContent }
            }

            NumberInputDialog {
                id: dlgUpdateWeight

                property int weightTotal
                property int weightLeft
                property string weightUnit

                title: qsTr("Update weight")
                label: qsTr("Weight left (%1): ").arg(dlgUpdateWeight.weightUnit)
                placeholderText: dlgUpdateWeight.weightLeft
                errorMessage: qsTr("The amount left should be smaller than the "
                                   + "available weight (%1%2)")
                                .arg(dlgUpdateWeight.weightTotal)
                                .arg(dlgUpdateWeight.weightUnit)
                maxNum: weightTotal
            }

            NumberInputDialog {
                id: dlgUpdateCost

                property int cost
                property int secondaryCost

                title: qsTr("Update cost")
                label: qsTr("New cost (€): ")
                placeholderText: dlgUpdateCost.secondaryCost
                errorMessage: qsTr("The new price should be smaller than the "
                                   + "full price (%1€)")
                                .arg(dlgUpdateCost.cost)
                maxNum: cost
            }

            Component {
                id: compCollectionSettings

                CollectionSettingsView {
                }
            }

        } // pageMain
    } // NavigationStack
}
