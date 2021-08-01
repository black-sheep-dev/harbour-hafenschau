import QtQuick 2.2
import Sailfish.Silica 1.0

Dialog {
    property alias url: urlLabel.text

    Column {
        width: parent.width

        DialogHeader {
            id: header
            title: qsTr("Open external url?")

            acceptText: qsTr("Open")
        }

        Label {
            id: urlLabel
            x: Theme.horizontalPageMargin
            width: parent.width - 2*x
            wrapMode: Text.WrapAnywhere
        }

    }


    onDone: {
        if (result == DialogResult.Accepted) {
            Qt.openUrlExternally(url)
        }
    }
}
