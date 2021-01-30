import QtQuick 2.0
import Sailfish.Silica 1.0

ListItem {
    property string thumbnail
    property string topline
    property string title
    property string firstSentence

    contentHeight: contentRow.height + separatorBottom.height

    Row {
        id: contentRow
        x: Theme.horizontalPageMargin
        width: parent.width - 2*x
        spacing: Theme.paddingSmall

        Image {
            id: thumbnailImage

            width: Theme.itemSizeExtraLarge
            height: Theme.itemSizeExtraLarge * 1.4

            fillMode: Image.PreserveAspectCrop

            source: thumbnail.length > 0 ? thumbnail : "qrc:/images/dummy_image"
            cache: true
            smooth: true

            BusyIndicator {
                size: BusyIndicatorSize.Medium
                anchors.centerIn: thumbnailImage
                running: thumbnailImage.status != Image.Ready
            }
        }

        Column {
            id: column
            width: parent.width - thumbnailImage.width - parent.spacing
            spacing: Theme.paddingSmall

            Label {
                text: topline

                width: parent.width
                wrapMode: Text.WordWrap

                font.pixelSize: Theme.fontSizeExtraSmall
            }
            Label {
                text: title

                width: parent.width
                wrapMode: Text.WordWrap

                font.pixelSize: Theme.fontSizeSmall
                color: Theme.highlightColor
            }
            Label {
                text: firstSentence
                width: parent.width
                wrapMode: Text.WordWrap

                font.pixelSize: Theme.fontSizeExtraSmall
            }
        }
    }

    Separator {
        id: separatorBottom
        visible: index < listView.count
        x: Theme.horizontalPageMargin
        width: parent.width - 2*x
        color: Theme.primaryColor
    }
}
