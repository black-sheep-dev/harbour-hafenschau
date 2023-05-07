pragma Singleton
import QtQuick 2.0

Item {
    function getPreferredImageSize1x1(width, variants) {
        const keys = Object.keys(variants)

        var size = 640
        if (width <= 144 && keys.indexOf("16x9-144") >= 0) size = 144
        if (width <= 256 && keys.indexOf("16x9-256") >= 0) size = 256
        if (width <= 432 && keys.indexOf("16x9-432") >= 0) size = 432
        if (width <= 640 && keys.indexOf("16x9-640") >= 0) size = 640

        return variants["1x1-" + size]
    }

    function getPreferredImageSize16x9(width, variants) {
        const keys = Object.keys(variants)

        var size = 1280
        if (width <= 256 && keys.indexOf("16x9-256") >= 0) size = 256
        if (width <= 384 && keys.indexOf("16x9-384") >= 0) size = 384
        if (width <= 512 && keys.indexOf("16x9-512") >= 0) size = 512
        if (width <= 640 && keys.indexOf("16x9-640") >= 0) size = 640
        if (width <= 960 && keys.indexOf("16x9-960") >= 0) size = 960
        if (width <= 1280 && keys.indexOf("16x9-1920") >= 0) size = 1280

        return variants["16x9-" + size]
    }
}
