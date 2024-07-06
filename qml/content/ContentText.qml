import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    property var item

    x: Theme.horizontalPageMargin
    width: parent.width - 2*x
    height: labelValue.height

    Label {
        id: labelValue
        width: parent.width

        font.pixelSize: Theme.fontSizeSmall
        wrapMode: Text.WordWrap
        linkColor: Theme.highlightColor

        text: item.value

        onLinkActivated: {
            if (link.substr(0, 31) === "https://www.tagesschau.de/api2u")
                pageStack.push(Qt.resolvedUrl("../pages/ReaderPage.qml"), {link: link})
            else
                Qt.openUrlExternally(link)
        }
    }
}


