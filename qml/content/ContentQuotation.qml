import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

Item {
    property ContentItem item

    x: Theme.horizontalPageMargin
    width: parent.width - 2*x
    height: columnBox.height

    Column {
        id: columnBox
        width: parent.width
        spacing: Theme.paddingMedium

        Separator {
            id: separatorTop
            width: parent.width
            color: Theme.highlightBackgroundColor
        }
        Row {
            width: parent.width
            spacing: Theme.paddingMedium

            Icon {
                id: quotationIcon
                source: "image://theme/icon-s-message?" + Theme.highlightColor
            }

            Label {
                id: labelValue
                width: parent.width - quotationIcon.width - parent.spacing
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeSmall
                font.italic: true
                wrapMode: Text.WordWrap

                text: item.value

            }
        }
        Separator {
            id: separatorBottom
            width: parent.width
            color: Theme.highlightBackgroundColor
        }
    }
}
