pragma Singleton
import QtQuick 2.0

Item {
    function request (url, callback) {
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = (function(myxhr) {
            return function() {
                if (myxhr.readyState !== 4) return

                if (myxhr.status === 308) {
                    const location = myxhr.getResponseHeader("Location")
                    request.call(myxhr, location, callback)
                    return
                }

                var data

                try {
                    data = JSON.parse(myxhr.responseText)
                } catch (e) {
                    data = myxhr.responseText
                }

                callback(data, myxhr.status)
            }
        })(xhr)

        xhr.open("GET", url)
        xhr.send()
    }
}
