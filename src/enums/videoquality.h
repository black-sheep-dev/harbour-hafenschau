#ifndef VIDEOQUALITY_H
#define VIDEOQUALITY_H

#include <QObject>

class VideoQuality {
    Q_GADGET
public:
    enum Quality {
        Low,
        Medium,
        High
    };
    Q_ENUM(Quality)
};

#endif // VIDEOQUALITY_H
