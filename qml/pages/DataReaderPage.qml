import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    property alias text: textArea.text

    id: page
    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: contentColumn.height

        Column {
            id: contentColumn
            width: parent.width
            spacing: Theme.paddingMedium

            PageHeader {
                title: qsTr("Raw data viewer")
            }

            TextArea {
                id: textArea
                width: parent.width

                readOnly: true
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeExtraSmall
            }
        }
    }
}

