import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

import "../components/"

ListItem {
    contentHeight: contentRow.height + separatorBottom.height

    Row {
        id: contentRow
        x: Theme.horizontalPageMargin
        width: parent.width - 2*x
        spacing: Theme.paddingSmall

        RemoteImage {
            id: thumbnailImage

            width: Theme.itemSizeExtraLarge
            height: Theme.itemSizeExtraLarge * 1.4

            source: model.thumbnail
            placeholderUrl: "/usr/share/harbour-hafenschau/images/dummy_thumbnail.png"


            Image {
                visible: model.newsType === News.Video
                anchors.centerIn: parent
                source: "image://theme/icon-m-play"
            }
        }

        Column {
            id: column
            width: parent.width - thumbnailImage.width - parent.spacing
            spacing: Theme.paddingSmall

            Label {
                text: {
                    if (model.newsType === News.Video)
                        return model.date.toLocaleString()
                    else
                        return model.topline
                }

                width: parent.width
                wrapMode: Text.WordWrap

                font.pixelSize: Theme.fontSizeExtraSmall
            }
            Label {
                text: model.title

                width: parent.width
                wrapMode: Text.WordWrap

                font.pixelSize: Theme.fontSizeSmall
                color: Theme.highlightColor
            }
            Label {
                text: model.firstSentence
                width: parent.width
                wrapMode: Text.WordWrap

                font.pixelSize: Theme.fontSizeExtraSmall
            }
        }
    }

    Separator {
        id: separatorBottom
        visible: index < (listView.count - 1)
        x: Theme.horizontalPageMargin
        width: parent.width - 2*x
        anchors.top: contentRow.bottom
        color: Theme.primaryColor
    }
}
