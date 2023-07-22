pragma Singleton
import QtQuick 2.0

Item {
    function getPreferredImageSize1x1(width, variants) {
        const keys = Object.keys(variants)

        var size = 0
        for (var k=0; k < keys.length; k++) {
            if (keys[k].indexOf("1x1-") < 0) continue
            size = Math.max(size, keys[k].substr(4))
            if (width < size) break
        }

        return variants["1x1-" + size]
    }

    function getPreferredImageSize16x9(width, variants) {
        const keys = Object.keys(variants)

        var size = 0
        for (var k=0; k < keys.length; k++) {
            if (keys[k].indexOf("16x9-") < 0) continue
            size = Math.max(size, keys[k].substr(5))
            if (width < size) break
        }

        return variants["16x9-" + size]
    }
}
