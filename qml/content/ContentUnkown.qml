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

        Image {
            source: "/usr/share/harbour-hafenschau/images/unkown.png"
            cache: true
            smooth: true

            width: parent.width
            height: sourceSize.height * parent.width / sourceSize.width
        }

        Label {
            width: parent.width

            font.pixelSize: Theme.fontSizeSmall
            wrapMode: Text.WordWrap
            color: Theme.highlightColor

            text: qsTr("Unkown Content")
        }

        Separator {
            width: parent.width
            color: Theme.highlightBackgroundColor
        }
    }

    onClicked: pageStack.animatorPush(Qt.resolvedUrl("../pages/DataReaderPage.qml"), { text: JSON.stringify(item, null, '\t') });
}
