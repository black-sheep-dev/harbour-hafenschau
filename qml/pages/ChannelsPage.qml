import QtQuick 2.0
import Sailfish.Silica 1.0

import "../delegates"
import "../models"
import "../."

Page {
    id: page

    allowedOrientations: Orientation.All

    NewsModel {
        id: channelsModel
        url: "https://www.tagesschau.de/api2/channels"
    }

    PageBusyIndicator {
        running: channelsModel.busy && listView.count === 0
    }

    SilicaListView {
        PullDownMenu {
            busy: channelsModel.busy

            MenuItem {
                text: qsTr("Refresh")
                onClicked: channelsModel.refresh()
            }
        }

        id: listView
        anchors.fill: parent

        header: PageHeader {
            title: qsTr("Channels")
        }

        clip: true

        model: channelsModel


        delegate: NewsListItem {
            id: delegate

            onClicked: pageStack.push(Qt.resolvedUrl("VideoPlayerPage.qml"), {
                                          title: title,
                                          streams: streams
                                      })
        }

        ViewPlaceholder {
            enabled: listView.count === 0 && !channelsModel.busy
            text: qsTr("No channels available")
            hintText: qsTr("Please refresh or check internet connection!")
        }

        VerticalScrollDecorator {}
    }

    onStatusChanged: if (status === PageStatus.Active) pageStack.pushAttached(Qt.resolvedUrl("StreamsListPage.qml"))

    Component.onCompleted: channelsModel.fetch()
}

