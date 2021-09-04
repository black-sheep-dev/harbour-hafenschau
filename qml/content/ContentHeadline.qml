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

        font.pixelSize: Theme.fontSizeLarge
        font.bold: true
        wrapMode: Text.WordWrap
        color: Theme.highlightColor

        text: item.value.replace( /(<([^>]+)>)/ig, '')
    }
}


