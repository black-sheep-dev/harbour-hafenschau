import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

import "../delegates"

Page {
    property bool closed: false
    property int count: 0
    property alias link: checkCommentsRequest.query
    property string detailsWeb

    id: page
    allowedOrientations: Orientation.All

    function refreshComments() {
        if (commentsRequest.query.length > 0) {
            api.request(commentsRequest)
        } else {
            api.request(checkCommentsRequest)
        }
    }

    ApiRequest {
        id: commentsRequest

        onFinished: commentsModel.setComments(result.Items)
    }

    ApiRequest {
        id: checkCommentsRequest

        onFinished: {
            closed = result.commentsAllowed
            count = result.count
            commentsRequest.query = result.details
            detailsWeb = result.detailsWeb
            refreshComments()
        }
    }

    PageBusyIndicator {
        running: (commentsRequest.loading || checkCommentsRequest.loading) && listView.count == 0
    }

    SilicaFlickable {
        PullDownMenu {
            busy: commentsRequest.loading || checkCommentsRequest.loading
            MenuItem {
                visible: detailsWeb.length > 0
                text: qsTr("Show in browser")
                onClicked: Qt.openUrlExternally(detailsWeb)
            }
            MenuItem {
                text: qsTr("Refresh")
                onClicked: refreshComments()
            }
            MenuItem {
                text: settings.commentsSortOrder === Qt.AscendingOrder ? qsTr("Sort descending") : qsTr("Sort ascending")
                onClicked: {
                    if (settings.commentsSortOrder === Qt.AscendingOrder) {
                        settings.commentsSortOrder = Qt.DescendingOrder
                        filterModel.sortModel(Qt.DescendingOrder)
                    } else {
                        settings.commentsSortOrder = Qt.AscendingOrder
                        filterModel.sortModel(Qt.AscendingOrder)
                    }
                }
            }

            MenuItem {
                text: listView.showSearch ? qsTr("Hide search") : qsTr("Search")
                onClicked: {
                    listView.showSearch = !listView.showSearch

                    if (!listView.showSearch) {
                        searchField.focus = false
                        searchField.text = ""
                    }
                }
            }
        }

        anchors.fill: parent

        Column {
            id: header
            width: parent.width

            PageHeader {
                title: closed ? qsTr("Comments (closed)") : qsTr("Comments");
                description: qsTr("%n comment(s)", "", count)
            }

            SearchField {
                id: searchField
                width: parent.width
                height: listView.showSearch ? implicitHeight : 0
                opacity: listView.showSearch ? 1 : 0
                onTextChanged: {
                    filterModel.setPattern(text)
                }

                EnterKey.onClicked: searchField.focus = false

                Connections {
                    target: listView
                    onShowSearchChanged: {
                        searchField.forceActiveFocus()
                    }
                }

                Behavior on height {
                    NumberAnimation { duration: 300 }
                }
                Behavior on opacity {
                    NumberAnimation { duration: 300 }
                }
            }
        }

        SilicaListView {
            property bool showSearch: false

            id: listView

            width: parent.width
            anchors.top: header.bottom
            anchors.bottom: parent.bottom

            clip: true

            model: CommentsSortFilterModel {
                id: filterModel
                sortOrder: settings.commentsSortOrder
                sourceModel: CommentsModel { id: commentsModel }
            }

            delegate: ListItem {
                contentHeight: contentColumn.height

                Column {
                    id: contentColumn
                    width: parent.width
                    spacing: Theme.paddingSmall

                    Label {
                        text: model.timestamp.toLocaleString()

                        x: Theme.horizontalPageMargin
                        width: parent.width - 2*x
                        wrapMode: Text.WordWrap

                        font.pixelSize: Theme.fontSizeExtraSmall
                        color: Theme.highlightColor
                    }
                    Label {
                        text: qsTr("From") + ": " + model.author


                        x: Theme.horizontalPageMargin
                        width: parent.width - 2*x
                        wrapMode: Text.WordWrap

                        font.pixelSize: Theme.fontSizeExtraSmall
                        color: Theme.highlightColor
                    }
                    Label {
                        text: model.title

                        x: Theme.horizontalPageMargin
                        width: parent.width - 2*x
                        wrapMode: Text.WordWrap

                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.highlightColor
                    }
                    Label {
                        text: model.text
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
                enabled: listView.count === 0
                text: qsTr("No comments available")
            }

            VerticalScrollDecorator {}
        }
    }

    Component.onCompleted: refreshComments()
}

