import QtQuick 2.0
import Sailfish.Silica 1.0

import "../."

Page {
    readonly property string appId: "harbour-hafenschau"

    id: page

    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width:parent.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("About")
            }

            Image {
                id: logo
                source: "/usr/share/icons/hicolor/512x512/apps/" + appId + ".png"
                smooth: true
                height: parent.width / 2
                width: parent.width / 2
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                width: parent.width
                x : Theme.horizontalPageMargin
                font.pixelSize: Theme.fontSizeExtraLarge
                color: Theme.secondaryHighlightColor

                text: qsTr("Hafenschau")
            }

            Label {
                width: parent.width
                x : Theme.horizontalPageMargin
                text: Global.appVersion
            }

            Label {
                width: parent.width - 2 * x
                x : Theme.horizontalPageMargin
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeSmall

                text: qsTr("Hafenschau is an inoffical content viewer for german news portal www.tagesschau.de with native Sailfish OS look & feel.")
            }

            Label {
                width: parent.width - 2 * x
                x : Theme.horizontalPageMargin
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeSmall

                text: qsTr("I am not the producer of the content used in the app! The content and its copyright belongs to tagesschau.de!")
                      + "\n"
                      + qsTr("This project tries to offer a solution to consume the contents of the German public broadcasting under Sailfish OS, since there is no native application.")  
            }

            SectionHeader {
                text: qsTr("Social")
            }

            BackgroundItem {
                width: parent.width
                height: Theme.itemSizeMedium
                contentHeight: Theme.itemSizeMedium
                Row{
                    width:parent.width - 2 * x
                    height: parent.height
                    x:Theme.horizontalPageMargin
                    spacing:Theme.paddingLarge

                    Image {
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.height * 0.8
                        height: width
                        source: "/usr/share/harbour-" + Qt.application.name + "/icons/mastodon.svg"
                    }

                    Label{
                        width: parent.width - parent.height - parent.spacing
                        anchors.verticalCenter: parent.verticalCenter
                        wrapMode: Text.WrapAnywhere
                        font.pixelSize: Theme.fontSizeSmall

                        text: "@" + Qt.application.name + "@social.nubecula.org"
                        color: parent.parent.pressed ? Theme.highlightColor : Theme.primaryColor

                    }
                }
                onClicked: {
                    notification.show(qsTr("Copied to clipboard"))
                    Clipboard.text = "@hafenschau@social.nubecula.org"
                }
            }

            ListItem {
                width: parent.width
                height: Theme.itemSizeMedium
                contentHeight: Theme.itemSizeMedium
                Row{
                    width:parent.width - 2 * x
                    height: parent.height
                    x:Theme.horizontalPageMargin
                    spacing:Theme.paddingLarge

                    Image {
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.height * 0.8
                        height: width
                        source: "/usr/share/harbour-" + Qt.application.name + "/icons/mastodon.svg"
                    }

                    Label{
                        width: parent.width - parent.height - parent.spacing
                        anchors.verticalCenter: parent.verticalCenter
                        wrapMode: Text.WrapAnywhere
                        font.pixelSize: Theme.fontSizeSmall

                        text: "@blacksheep@social.nubecula.org"
                        color: parent.parent.pressed ? Theme.highlightColor : Theme.primaryColor

                    }
                }
                onClicked: {
                    notification.show(qsTr("Copied to clipboard"))
                    Clipboard.text = "@blacksheep@social.nubecula.org"
                }
            }

            SectionHeader {
                text: qsTr("Sources")
            }

            BackgroundItem{
                width: parent.width
                height: Theme.itemSizeMedium
                Row{
                    width:parent.width - 2 * x
                    height: parent.height
                    x:Theme.horizontalPageMargin
                    spacing:Theme.paddingLarge

                    Image {
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.height * 0.8
                        height: width
                        source: "/usr/share/harbour-" + Qt.application.name + "/icons/github.svg"
                    }

                    Label{
                        width: parent.width - parent.height - parent.spacing
                        anchors.verticalCenter: parent.verticalCenter
                        wrapMode: Text.WrapAnywhere
                        font.pixelSize: Theme.fontSizeSmall

                        text: "https://github.com/black-sheep-dev/harbour-" + Qt.application.name
                        color: parent.parent.pressed ? Theme.highlightColor : Theme.primaryColor

                    }
                }
                onClicked: Qt.openUrlExternally("https://github.com/black-sheep-dev/"  + appId)
            }

            SectionHeader{
                text: qsTr("Donations")
            }

            Label {
                x : Theme.horizontalPageMargin
                width: parent.width - 2*x

                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeSmall

                text: qsTr("If you like my work why not buy me a beer?")
            }

            BackgroundItem{
                width: parent.width
                height: Theme.itemSizeMedium

                Row{
                    x: Theme.horizontalPageMargin
                    width: parent.width - 2*x
                    height: parent.height
                    spacing:Theme.paddingLarge

                    Image {
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.height * 0.8
                        height: width
                        fillMode: Image.PreserveAspectFit
                        source: "/usr/share/harbour-" + Qt.application.name + "/icons/paypal.svg"
                    }
                    Label{
                        width: parent.width - parent.height - parent.spacing
                        anchors.verticalCenter: parent.verticalCenter
                        wrapMode: Text.WrapAnywhere
                        font.pixelSize: Theme.fontSizeSmall
                        color: parent.parent.pressed ? Theme.highlightColor : Theme.primaryColor
                        text: qsTr("Donate with PayPal")
                    }
                }
                onClicked: Qt.openUrlExternally("https://www.paypal.com/paypalme/nubecula/1")
            }

            BackgroundItem{
                width: parent.width
                height: Theme.itemSizeMedium

                Row{
                    x: Theme.horizontalPageMargin
                    width: parent.width - 2*x
                    height: parent.height

                    spacing:Theme.paddingLarge

                    Image {
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.height * 0.8
                        height: width
                        fillMode: Image.PreserveAspectFit
                        source: "/usr/share/harbour-" + Qt.application.name + "/icons/liberpay.svg"
                    }
                    Label{
                        width: parent.width - parent.height - parent.spacing
                        anchors.verticalCenter: parent.verticalCenter
                        wrapMode: Text.WrapAnywhere
                        font.pixelSize: Theme.fontSizeSmall
                        color: parent.parent.pressed ? Theme.highlightColor : Theme.primaryColor
                        text: qsTr("Donate with Liberpay")
                    }
                }
                onClicked: Qt.openUrlExternally("https://liberapay.com/black-sheep-dev/donate")
            }

            Item {
                width: 1
                height: Theme.paddingLarge
            }
        }
    }
}
