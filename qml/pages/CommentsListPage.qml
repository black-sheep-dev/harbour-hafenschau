import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

import "../delegates"

Page {
    property string link
    property CommentsModel commentsModel
    property bool loading

    function refreshComments() {
        loading = true;
        HafenschauProvider.getComments(link)
    }

    id: page

    allowedOrientations: Orientation.All

    SilicaFlickable {
        PullDownMenu {
            busy: loading
            MenuItem {
                text: qsTr("Refresh")
                onClicked: refreshComments()
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
                title: commentsModel.closed ? qsTr("Comments (closed)") : qsTr("Comments");
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
                sourceModel: commentsModel
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

    Connections {
        target: HafenschauProvider
        onCommentsModelAvailable: {
            commentsModel = model
            loading = false
        }
    }

    Component.onCompleted: refreshComments()
}

