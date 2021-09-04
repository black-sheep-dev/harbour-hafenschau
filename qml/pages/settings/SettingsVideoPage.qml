import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.KeepAlive 1.2

import org.nubecula.harbour.hafenschau 1.0

Page {
    id: page

    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent

        contentHeight: column.height

        Column {
            id: column

            width: parent.width
            spacing: Theme.paddingMedium

            PageHeader {
                title: qsTr("Video Settings")
            }

            Label {
                x: Theme.horizontalPageMargin
                width: page.width - 2*x

                color: Theme.highlightColor
                wrapMode: Text.Wrap

                text: qsTr("Choose video quality")
            }

            TextSwitch {
                id: adpativeSwitch

                x: Theme.horizontalPageMargin
                width: parent.width - 2*x

                text: qsTr("Adaptive Streaming")
                description: qsTr("Use adaptive streaming when possible")

                onCheckedChanged: settings.videoQualityAdaptive = checked

                Component.onCompleted: checked = settings.videoQualityAdaptive
            }

            ComboBox {
                id: qualityComboBox
                width: parent.width
                label: qsTr("Quality")

                menu: ContextMenu {
                    MenuItem { text: qsTr("Low") }
                    MenuItem { text: qsTr("Medium") }
                    MenuItem { text: qsTr("High") }
                }

                onCurrentIndexChanged: settings.videoQuality = currentIndex
                Component.onCompleted: currentIndex = settings.videoQuality
            }


        }
    }
}
