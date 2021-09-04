#ifndef NEWSTYPE_H
#define NEWSTYPE_H

#include <QObject>

class NewsType {
    Q_GADGET

public:
    enum Type {
        Undefined,
        Story,              // story
        Video,              // video
        WebView             // webview
    };
    Q_ENUM(Type)
};

#endif // NEWSTYPE_H
