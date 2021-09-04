import QtQuick 2.0
import Sailfish.Silica 1.0

BackgroundItem {
    property var item

    width: parent.width
    height: columnBox.height

    Column {
        id: columnBox
        x: Theme.horizontalPageMargin
        width: parent.width - 2*x
        spacing: Theme.paddingMedium

        Separator {
            width: parent.width
            color: Theme.highlightBackgroundColor
        }

        Label {
            width: parent.width

            font.pixelSize: Theme.fontSizeMedium
            wrapMode: Text.WordWrap

            color: Theme.highlightColor

            text: item.title
        }

        SilicaListView {
            width: parent.width

            height: Theme.itemSizeSmall * count

            model: item.items


            delegate: ListItem {
                id: delegate

                contentHeight: Theme.itemSizeSmall

                Label {
                    width: parent.width
                    anchors.verticalCenter: parent.verticalCenter
                    wrapMode: Text.WordWrap

                    font.pixelSize: Theme.fontSizeSmall

                    linkColor: Theme.highlightColor

                    text: modelData.url

                    onLinkActivated: {
                        var link = modelData.url.match(/(?:ht|f)tps?:\/\/[-a-zA-Z0-9.]+\.[a-zA-Z]{2,3}(\/[^"<]*)?/g)[0]

                        if (link.substr(0, 31) === "https://www.tagesschau.de/api2/")
                            pageStack.push(Qt.resolvedUrl("../pages/ReaderPage.qml"), {link: link})
                        else
                            Qt.openUrlExternally(link)
                    }
                }
            }
        }
    }
}


