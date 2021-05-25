import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

BackgroundItem {
    property ContentItem item

    width: parent.width
    height: headerImage.height + labelTitle.height + separatorBottom.height + 2 * columnBox.spacing

    Column {
        id: columnBox
        x: Theme.horizontalPageMargin
        width: parent.width - 2*x
        spacing: Theme.paddingMedium

        Image {
            id: headerImage
            source: "/usr/share/harbour-hafenschau/images/unkown.png"
            cache: true
            smooth: true

            width: parent.width
            height: sourceSize.height * parent.width / sourceSize.width
        }

        Label {
            id: labelTitle
            width: parent.width

            font.pixelSize: Theme.fontSizeSmall
            wrapMode: Text.WordWrap
            color: Theme.highlightColor

            text: qsTr("Unkown Content")
        }

        Separator {
            id: separatorBottom
            width: parent.width
            color: Theme.highlightBackgroundColor
        }
    }

    onClicked: pageStack.push(Qt.resolvedUrl("../pages/DataReaderPage.qml"), { text: item.value });
}
