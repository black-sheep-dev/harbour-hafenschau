import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

BackgroundItem {
    property ContentItemList item

    width: parent.width
    height: columnBox.height

    Column {
        id: columnBox
        x: Theme.horizontalPageMargin
        width: parent.width - 2*x
        spacing: Theme.paddingMedium

        Separator {
            id: separatorTop
            width: parent.width
            color: Theme.highlightBackgroundColor
        }

        Label {
            id: labelHeader
            width: parent.width

            font.pixelSize: Theme.fontSizeMedium
            wrapMode: Text.WordWrap

            color: Theme.highlightColor

            text: item.title
        }

        SilicaListView {
            id: listView
            width: parent.width

            height: Theme.itemSizeSmall * listView.count

            model: item.items


            delegate: ListItem {
                id: delegate

                contentHeight: Theme.itemSizeSmall

                Label {
                    id: listItemLabel
                    width: parent.width
                    anchors.verticalCenter: parent.verticalCenter
                    wrapMode: Text.WordWrap

                    font.pixelSize: Theme.fontSizeSmall

                    linkColor: Theme.highlightColor

                    text: modelData

                    onLinkActivated: {
                        if (HafenschauProvider.isInternalLink(link))
                            HafenschauProvider.getInternalLink(link)
                        else
                            pageStack.push(Qt.resolvedUrl("../dialogs/OpenExternalUrlDialog.qml"), { url: link })

                    }
                }
            }
        }
    }
}


