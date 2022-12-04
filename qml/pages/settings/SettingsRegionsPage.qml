import QtQuick 2.0
import Sailfish.Silica 1.0

import "../../."

Page {
    id: page

    property var activeRegions: []

    allowedOrientations: Orientation.All

    SilicaListView {
        PullDownMenu {
            MenuItem {
                text: qsTr("Reset")
                onClicked: remorse.execute(qsTr("Reset region settings"), function() {
                    activeRegions = []
                })
            }
        }

        RemorsePopup { id: remorse }

        id: listView
        model: ListModel {
            id: regionsModel

            ListElement {
                name: "Baden-Württemberg"
                value: 1
            }
            ListElement {
                name: "Bayern"
                value: 2
            }
            ListElement {
                name: "Berlin"
                value: 3
            }
            ListElement {
                name: "Brandenburg"
                value: 4
            }
            ListElement {
                name: "Bremen"
                value: 5
            }
            ListElement {
                name: "Hamburg"
                value: 6
            }
            ListElement {
                name: "Hessen"
                value: 7
            }
            ListElement {
                name: "Mecklenburg-Vorpommern"
                value: 8
            }
            ListElement {
                name: "Niedersachsen"
                value: 9
            }
            ListElement {
                name: "Nordrhein-Westfalen"
                value: 10
            }
            ListElement {
                name: "Rheinland-Pfalz"
                value: 11
            }
            ListElement {
                name: "Saarland"
                value: 12
            }
            ListElement {
                name: "Sachsen"
                value: 13
            }
            ListElement {
                name: "Sachsen-Anhalt"
                value: 14
            }
            ListElement {
                name: "Schleswig-Holstein"
                value: 15
            }
            ListElement {
                name: "Thüringen"
                value: 16
            }

        }

        anchors.fill: parent

        header: PageHeader {
            title: qsTr("Regional News")
        }

        delegate: ListItem {
            id: delegate

            contentHeight: Theme.itemSizeSmall

            Label {
                id: nameLabel
                x: Theme.horizontalPageMargin
                width: parent.width - 2*x - selectedIcon.width
                anchors.verticalCenter: parent.verticalCenter

                font.pixelSize: Theme.fontSizeMedium

                text: name
            }

            Image {
                id: selectedIcon
                anchors.left: nameLabel.right
                anchors.verticalCenter: parent.verticalCenter

                visible: activeRegions.indexOf(value) >= 0

                source: "image://theme/icon-m-acknowledge?" + Theme.highlightColor
            }

            onClicked: {
                var regions = activeRegions
                const idx = activeRegions.indexOf(value)
                if (idx >= 0) {
                    regions.splice(idx, 1)
                } else {
                    regions.push(value)
                }
                activeRegions = regions
            }
        }
        VerticalScrollDecorator {}
    }

    onStatusChanged: if (status === PageStatus.Deactivating) config.activeRegions = JSON.stringify(activeRegions)

    Component.onCompleted: activeRegions = JSON.parse(config.activeRegions)
}

