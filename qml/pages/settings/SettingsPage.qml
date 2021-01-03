import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    allowedOrientations: Orientation.All

    SilicaListView {
        id: listView
        model: ListModel {
            ListElement {
                title: qsTr("Regional News");
                description: qsTr("Select regional news")
                icon: "image://theme/icon-m-levels"
                page: "SettingsRegionsPage.qml"
            }
//            ListElement {
//                title: qsTr("Look & Feel");
//                description: qsTr("Change look & feel settings")
//                icon: "image://theme/icon-m-ambience"
//                page: "../AboutPage.qml"
//            }
            ListElement {
                title: qsTr("Developer Settings");
                description: qsTr("Manage developer options")
                icon: "image://theme/icon-m-developer-mode"
                page: "SettingsDeveloperPage.qml"
            }
            ListElement {
                title: qsTr("About");
                description: qsTr("Show about page")
                icon: "image://theme/icon-m-about"
                page: "../AboutPage.qml"
            }
        }

        anchors.fill: parent
        header: PageHeader {
            title: qsTr("Settings")
        }

        delegate: ListItem {
            id: delegate
            width: parent.width
            contentHeight: Theme.itemSizeLarge

            Row {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * x
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter

                Image {
                    id: itemIcon
                    source: icon
                    anchors.verticalCenter: parent.verticalCenter
                }

                Item {
                    width:Theme.paddingMedium
                    height:1
                }

                Column {
                    id: data
                    width: parent.width - itemIcon.width
                    anchors.verticalCenter: itemIcon.verticalCenter
                    spacing: Theme.paddingSmall

                    Label {
                        id: text
                        width: parent.width
                        text: title
                        color: pressed ? Theme.secondaryHighlightColor:Theme.highlightColor
                        font.pixelSize: Theme.fontSizeMedium
                    }
                    Label {
                        text: description
                        color: pressed ? Theme.secondaryColor:Theme.primaryColor
                        font.pixelSize: Theme.fontSizeSmall
                    }
                }
            }

            onClicked: pageStack.push(Qt.resolvedUrl(page))
        }

        VerticalScrollDecorator {}
    }
}


