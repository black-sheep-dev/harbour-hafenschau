import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components/"

BackgroundItem {
    property var item
    readonly property string placeholderImage: "/usr/share/harbour-hafenschau/images/webcontent.png"

    visible: titleLabel.text.length > 0
    width: parent.width
    height: columnBox.height

    Column {
        id: columnBox
        x: Theme.horizontalPageMargin
        width: parent.width - 2*x
        spacing: Theme.paddingMedium

        RemoteImage {
            source: {
                if (!item.hasOwnProperty("url")) return placeholderImage

                var split = item.url.split("/")
                if (split[2] !== "app.23degrees.io")
                    return placeholderImage

                return "https://app.23degrees.io/services/image/v1/getPreviewFromSlug/" + split[4] + "/preview.png"
            }

            placeholderUrl: placeholderImage
        }
    }

    onClicked: {
        if (settings.internalWebView) {
            pageStack.animatorPush(Qt.resolvedUrl("../pages/WebViewPage.qml"), {url: item.url })
        } else {
            Qt.openUrlExternally(item.url)
        }
    }
}
