.pragma library

function getPreferredImageSize1x1(width) {
    if (width > 640) return 840
    if (width > 432) return 640
    if (width > 256) return 432
    if (width > 144) return 256
    return 144
}

function getPreferredImageSize16x9(width) {
    if (width > 1280) return 1920
    if (width > 960) return 1280
    if (width > 640) return 960
    if (width > 512) return 640
    if (width > 384) return 384
    if (width > 256) return 384
    return 256
}

