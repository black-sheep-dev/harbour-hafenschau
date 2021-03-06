import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.DBus 2.0

Page {
    id: page

    allowedOrientations: Orientation.All

    DBusInterface {
        id: sailHubInterface

        service: "harbour.sailhub.service"
        iface: "harbour.sailhub.service"
        path: "/harbour/sailhub/service"
    }

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
                source: "/usr/share/icons/hicolor/512x512/apps/" + Qt.application.name + ".png"
                smooth: true
                height: parent.width / 2
                width: parent.width / 2
                anchors.horizontalCenter: parent.horizontalCenter
                opacity: 0.7
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
                text: Qt.application.version
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

            SectionHeader{
                text: qsTr("Sources")
            }

            BackgroundItem{
                width: parent.width
                height: Theme.itemSizeMedium
                Row{
                    width:parent.width - 2 * x
                    height: parent.height
                    x:Theme.horizontalPageMargin
                    spacing:Theme.paddingMedium

                    Image {
                        width: parent.height
                        height: width
                        source: "qrc:///icons/git"
                    }

                    Label{
                        width: parent.width - parent.height - parent.spacing
                        anchors.verticalCenter: parent.verticalCenter
                        wrapMode: Text.WrapAnywhere
                        font.pixelSize: Theme.fontSizeSmall

                        text: "https://github.com/black-sheep-dev/" + Qt.application.name
                        color: parent.parent.pressed ? Theme.highlightColor : Theme.primaryColor

                    }
                }
                onClicked: Qt.openUrlExternally("https://github.com/black-sheep-dev/"  + Qt.application.name)
            }

            ButtonLayout {
                visible: sailHubInterface.Available
                width: parent.width

                Button {
                    text: qsTr("Give star")
                    onClicked: sailHubInterface.call("addStar", ["black-sheep-dev", Qt.application.name])
                }
            }

            Item {
                width: 1
                height: Theme.paddingLarge
            }

//            SectionHeader{
//                text: qsTr("Donations")
//            }

//            BackgroundItem{
//                width: parent.width
//                height: Theme.itemSizeMedium
//                Row{
//                    width:parent.width - 2 * x
//                    height: parent.height
//                    x:Theme.horizontalPageMargin
//                    spacing:Theme.paddingMedium
//                    Image {
//                        width: parent.height
//                        height: width
//                        source: "qrc:///icons/paypal"
//                    }
//                    Label{
//                        width: parent.width - parent.height - parent.spacing
//                        anchors.verticalCenter: parent.verticalCenter
//                        wrapMode: Text.WrapAnywhere
//                        font.pixelSize: Theme.fontSizeSmall
//                        color: parent.parent.pressed ? Theme.highlightColor : Theme.primaryColor
//                        text: qsTr("If you like my work you can buy me a beer.")
//                    }
//                }
//                onClicked: Qt.openUrlExternally("https://www.paypal.com/paypalme/nubecula/1")
//            }
        }
    }
}
