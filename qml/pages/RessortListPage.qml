import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    allowedOrientations: Orientation.All

    SilicaListView {
        id: listView

        model: ListModel {
            ListElement {
                title: qsTr("Domestic News");
                description: qsTr("Browse domestic news")
                icon: "image://theme/icon-m-home"
                page: "NewsListPage.qml"
                ressort: "inland"
            }
            ListElement {
                title: qsTr("Foreign News");
                description: qsTr("Browse news from foreign countries")
                icon: "image://theme/icon-m-airplane-mode"
                page: "NewsListPage.qml"
                ressort: "ausland"
            }
            ListElement {
                title: qsTr("Economic News");
                description: qsTr("Browse economic news")
                icon: "image://theme/icon-m-storage"
                page: "NewsListPage.qml"
                ressort: "wirtschaft"
            }

            ListElement {
                title: qsTr("Investigative News");
                description: qsTr("Browse investigative news")
                icon: "image://theme/icon-m-camera"
                page: "NewsListPage.qml"
                ressort: "investigativ"
            }
            ListElement {
                title: qsTr("Regional News");
                description: qsTr("Browse regional news")
                icon: "image://theme/icon-m-location"
                page: "NewsListPage.qml"
                ressort: "regional"
            }
            ListElement {
                title: qsTr("Sport News");
                description: qsTr("Browse sport news")
                icon: "image://theme/icon-m-person"
                page: "NewsListPage.qml"
                ressort: "sport"
            }
            ListElement {
                title: qsTr("Videos");
                description: qsTr("Browse videos")
                icon: "image://theme/icon-m-video"
                page: "NewsListPage.qml"
                ressort: "video"
            }
            ListElement {
                title: qsTr("Search");
                description: qsTr("Search content")
                icon: "image://theme/icon-m-search"
                page: "SearchPage.qml"
                ressort: "search"
            }
        }

        anchors.fill: parent
        header: PageHeader {
            title: qsTr("Ressorts")
        }

        delegate: ListItem {
            id: delegate
            width: parent.width
            contentHeight: {
                if (contentRow.height > Theme.itemSizeLarge)
                    return contentRow.height
                else
                    return Theme.itemSizeLarge
            }

            Row {
                id: contentRow

                x: Theme.horizontalPageMargin
                width: parent.width - 2 * x
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
                        wrapMode: Text.Wrap
                    }
                }
            }

            onClicked: {
                pageStack.push(Qt.resolvedUrl(page), {
                                                 ressort: model.ressort,
                                                 ressortTitle: model.title
                                            })
            }
        }

        VerticalScrollDecorator {}
    }

    onStatusChanged: if (status === PageStatus.Active) pageStack.pushAttached(Qt.resolvedUrl("ChannelsPage.qml"))
}



