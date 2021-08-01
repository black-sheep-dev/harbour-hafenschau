import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.DBus 2.0
import Nemo.Notifications 1.0

import "pages"

import org.nubecula.harbour.hafenschau 1.0

ApplicationWindow
{
    Notification {
        function show(message, icn) {
            replacesId = 0
            previewSummary = ""
            previewBody = message
            icon = icn || ""
            publish()
        }

        id: notification
        appName: "Hafenschau"
        expireTimeout: 3000
    }

    Connections {
        target: HafenschauProvider
        onError: {
            switch (error) {
            case 0:
                return

            case 1: // QNetworkReply::ConnectionRefusedError
                notification.show(qsTr("Connection refused"))
                break

            case 3: // QNetworkReply::HostNotFoundError
                notification.show(qsTr("Host not found"))
                break

            case 4: // QNetworkReply::TimeoutError
                notification.show(qsTr("Connection timed out"))
                break

            case 6: // QNetworkReply::SslHandshakeFailedError
                notification.show(qsTr("Ssl handshake failed"))
                break

            case 201: // QNetworkReply::ContentAccessDenied
                notification.show(qsTr("Access denied"))
                break

            case 203: // QNetworkReply::ContentNotFoundError
                notification.show(qsTr("Not found"))
                break

            case 401: // QNetworkReply::InternalServerError
                notification.show(qsTr("Internal server error"))
                break

            default:
                notification.show(qsTr("Unkown connection error") + ": " + error)
                break
            }
        }
    }

    initialPage: Component { StartPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations

    Component.onCompleted: HafenschauProvider.initialize()

    DBusAdaptor {
            service: "harbour.hafenschau.service"
            iface: "harbour.hafenschau.service"
            path: "/harbour/hafenschau/service"
            xml: '\
      <interface name="harbour.hafenschau.service">
        <method name="open">
            <arg name="news" type="s" direction="in">
            </arg>
        </method>
      </interface>'

            function open(news) {
                __silica_applicationwindow_instance.activate()
                pageStack.push(Qt.resolvedUrl("pages/ReaderPage.qml"), {
                                    link: news
                               })
            }
        }
}
