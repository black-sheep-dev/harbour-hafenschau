import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

SilicaWebView {
    property ContentItem item

    x: Theme.horizontalPageMargin
    width: parent.width - 2*x
    height: width

    url: item.value
}
