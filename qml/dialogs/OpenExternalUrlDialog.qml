import QtQuick 2.2
import Sailfish.Silica 1.0

Dialog {
    property string url

    Column {
        width: parent.width

        DialogHeader {
            id: header
            title: qsTr("Open external url?")

            acceptText: qsTr("Open")
        }

        Label {
            x: Theme.horizontalPageMargin
            width: parent.width - 2*x
            wrapMode: Text.WrapAnywhere

            text: url
        }

    }


    onDone: {
        if (result == DialogResult.Accepted) {
            Qt.openUrlExternally(url)
        }
    }
}
