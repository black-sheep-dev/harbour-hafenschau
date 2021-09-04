import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    property var item

    x: Theme.horizontalPageMargin
    width: parent.width - 2*x
    height: columnBox.height

    Column {
        id: columnBox
        width: parent.width
        spacing: Theme.paddingMedium

        Separator {
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
                width: parent.width - quotationIcon.width - parent.spacing
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeSmall
                font.italic: true
                wrapMode: Text.WordWrap

                text: item.text


            }
        }
        Separator {
            width: parent.width
            color: Theme.highlightBackgroundColor
        }
    }
}
