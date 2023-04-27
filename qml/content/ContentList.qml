import QtQuick 2.0
import Sailfish.Silica 1.0

BackgroundItem {
    property var item

    width: parent.width
    height: columnBox.height

    function openLink(link) {
        if (link.length === 0) return
        const l = link.match(/(?:ht|f)tps?:\/\/[-a-zA-Z0-9.]+\.[a-zA-Z]{2,3}(\/[^"<]*)?/g)[0]

        if (l.substr(0, 30) === "https://www.tagesschau.de/api2")
            pageStack.push(Qt.resolvedUrl("../pages/ReaderPage.qml"), {link: l})
        else
            Qt.openUrlExternally(l)
    }

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

        Repeater {
            model: item.items

            BackgroundItem {
                contentHeight: Math.max(contentRow.height + 2*Theme.paddingSmall, Theme.itemSizeSmall)

                Row {
                    id: contentRow
                    width: parent.width
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: Theme.paddingSmall

                    Icon {
                        id: linkIcon
                        anchors.verticalCenter: parent.verticalCenter
                        source: "image://theme/icon-s-attach"
                    }

                    Label {
                        width: parent.width - linkIcon.width - parent.spacing
                        anchors.verticalCenter: parent.verticalCenter
                        wrapMode: Text.WordWrap

                        font.pixelSize: Theme.fontSizeSmall

                        linkColor: Theme.highlightColor

                        text: modelData.url
                    }
                }

                onClicked: openLink(modelData.url)
            }
        }
    }
}


