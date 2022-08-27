
#include <QtQuick>

#include <sailfishapp.h>

#include "api/apiinterface.h"
#include "api/apirequest.h"
#include "api/networkaccessmanagerfactory.h"
#include "comments/commentsmodel.h"
#include "comments/commentssortfiltermodel.h"
#include "enums/enums.h"
#include "news/newslistmodel.h"
#include "news/newssortfiltermodel.h"
#include "region/regionsmodel.h"
#include "tools/datawriter.h"

int main(int argc, char *argv[])
{
    // Disable crash guard and prefer egl for webgl.
    setenv("MOZ_DISABLE_CRASH_GUARD", "1", 1);
    setenv("MOZ_WEBGL_PREFER_EGL", "1", 1);

    // Set up QML engine.
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    QScopedPointer<QQuickView> v(SailfishApp::createView());
    QQmlContext *context = v.data()->rootContext();

    NetworkAccessManagerFactory factory;
    v->engine()->setNetworkAccessManagerFactory(&factory);

    // set app data
    app->setApplicationName(QStringLiteral("hafenschau"));
    app->setApplicationVersion(APP_VERSION);
    app->setOrganizationName(QStringLiteral("org.nubecula"));
    app->setOrganizationDomain(QStringLiteral("org.nubecula"));


#ifndef QT_DEBUG
    auto uri = "org.nubecula.harbour.hafenschau";
#else
   #define uri "org.nubecula.harbour.hafenschau"
#endif

    // register enums
    qmlRegisterUncreatableType<DeveloperOption>(uri, 1, 0, "DeveloperOption", "");
    qmlRegisterUncreatableType<NewsType>(uri, 1, 0, "NewsType", "");
    qmlRegisterUncreatableType<Ressort>(uri, 1, 0, "Ressort", "");
    qmlRegisterUncreatableType<VideoQuality>(uri, 1, 0, "VideoQuality", "");

    // register uncreatable types
    auto api = new ApiInterface(factory.create(nullptr));
    context->setContextProperty("api", api);
    qmlRegisterUncreatableType<ApiInterface>(uri, 1, 0, "ApiInterface", "");

    // register types
    qmlRegisterType<ApiRequest>(uri, 1, 0, "ApiRequest");
    qmlRegisterType<CommentsModel>(uri, 1, 0, "CommentsModel");
    qmlRegisterType<CommentsSortFilterModel>(uri, 1, 0, "CommentsSortFilterModel"); 
    qmlRegisterType<DataWriter>(uri, 1, 0, "DataWriter");
    qmlRegisterType<NewsListModel>(uri, 1, 0, "NewsListModel");
    qmlRegisterType<NewsSortFilterModel>(uri, 1, 0, "NewsSortFilterModel");
    qmlRegisterType<RegionsModel>(uri, 1, 0, "RegionsModel");

    v->setSource(SailfishApp::pathTo("qml/harbour-hafenschau.qml"));
    v->show();

    return app->exec();
}
