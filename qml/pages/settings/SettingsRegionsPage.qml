import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

Page {
    id: page

    allowedOrientations: Orientation.All

    SilicaListView {
        PullDownMenu {
            MenuItem {
                text: qsTr("Reset")
                onClicked: listView.model.resetRegions();
            }
        }

        id: listView
        model: HafenschauProvider.regionsModel()

        anchors.fill: parent

        header: PageHeader {
            title: qsTr("Regional News")
        }

        delegate: ListItem {
            id: delegate

            contentHeight: Theme.itemSizeSmall

            Label {
                id: nameLabel
                x: Theme.horizontalPageMargin
                width: parent.width - 2*x - selectedIcon.width
                anchors.verticalCenter: parent.verticalCenter

                font.pixelSize: Theme.fontSizeMedium

                text: name
            }

            Image {
                id: selectedIcon
                anchors.left: nameLabel.right
                anchors.verticalCenter: parent.verticalCenter

                visible: active

                source: "image://theme/icon-m-acknowledge?" + Theme.highlightColor
            }

            onClicked: active = !active
        }
        VerticalScrollDecorator {}
    }

    onStatusChanged: if (status === PageStatus.Deactivating) HafenschauProvider.saveSettings()
}

