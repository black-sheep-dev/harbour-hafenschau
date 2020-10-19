import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

Item {
    property ContentItem item

    x: Theme.horizontalPageMargin
    width: parent.width - 2*x
    height: labelValue.height

    Label {
        id: labelValue
        width: parent.width

        font.pixelSize: Theme.fontSizeMedium
        wrapMode: Text.WordWrap
        linkColor: Theme.secondaryHighlightColor

        text: item.value

        onLinkActivated: {
            if (HafenschauProvider.isInternalLink(link))
                HafenschauProvider.getInternalLink(link)
            else
                pageStack.push(Qt.resolvedUrl("../dialogs/OpenExternalUrlDialog.qml"), { url: link })

        }

    }
}


