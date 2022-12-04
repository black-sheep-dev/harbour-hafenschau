import QtQuick 2.0
import Sailfish.Silica 1.0

import "../delegates"
import "../models"

Page {
    property alias link: commentsModel.link

    id: page
    allowedOrientations: Orientation.All

    CommentsModel {
        id: commentsModel
        sortOrder: config.commentsSortOrder
    }

    PageBusyIndicator {
        running: commentsModel.busy && listView.count == 0
    }

    SilicaListView {
        PullDownMenu {
            busy: commentsModel.busy
            MenuItem {
                visible: commentsModel.detailsWeb.length > 0
                text: qsTr("Show in browser")
                onClicked: Qt.openUrlExternally(commentsModel.detailsWeb)
            }
            MenuItem {
                text: qsTr("Refresh")
                onClicked: commentsModel.refresh()
            }
            MenuItem {
                text: config.commentsSortOrder === Qt.AscendingOrder ? qsTr("Sort descending") : qsTr("Sort ascending")
                onClicked: {
                    if (config.commentsSortOrder === Qt.AscendingOrder) {
                        config.commentsSortOrder = Qt.DescendingOrder
                    } else {
                        config.commentsSortOrder = Qt.AscendingOrder
                    }
                }
            }
        }

        id: listView
        anchors.fill: parent
        header: PageHeader {
            title: commentsModel.commentsAllowed ? qsTr("Comments") : qsTr("Comments (closed)");
            description: qsTr("%n comment(s)", "", commentsModel.count)
        }

        clip: true
        model: commentsModel.items

        delegate: ListItem {
            contentHeight: contentColumn.height

            Column {
                id: contentColumn
                width: parent.width
                spacing: Theme.paddingSmall

                Label {
                    text: new Date(modelData.Beitragsdatum).toLocaleString()

                    x: Theme.horizontalPageMargin
                    width: parent.width - 2*x
                    wrapMode: Text.WordWrap

                    font.pixelSize: Theme.fontSizeExtraSmall
                    color: Theme.highlightColor
                }
                Label {
                    text: qsTr("From") + ": " + modelData.Benutzer


                    x: Theme.horizontalPageMargin
                    width: parent.width - 2*x
                    wrapMode: Text.WordWrap

                    font.pixelSize: Theme.fontSizeExtraSmall
                    color: Theme.highlightColor
                }
                Label {
                    text: modelData.Titel

                    x: Theme.horizontalPageMargin
                    width: parent.width - 2*x
                    wrapMode: Text.WordWrap

                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.highlightColor
                }
                Label {
                    text: modelData.Kommentar
                    x: Theme.horizontalPageMargin
                    width: parent.width - 2*x
                    wrapMode: Text.WordWrap

                    font.pixelSize: Theme.fontSizeExtraSmall
                }

                Item {
                    width: 1
                    height: 1
                }

                Separator {
                    visible: index < (listView.count - 1)
                    x: Theme.horizontalPageMargin
                    width: parent.width - 2*x
                    color: Theme.primaryColor
                }

                Item {
                    width: 1
                    height: 1
                }
            }
        }

        ViewPlaceholder {
            visible: !commentsModel.busy
            enabled: listView.count === 0
            text: qsTr("No comments available")
        }

        VerticalScrollDecorator {}
    }

    Component.onCompleted: commentsModel.refresh()
}

