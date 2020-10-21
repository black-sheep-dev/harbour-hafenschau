
#include <QtQuick>

#include <sailfishapp.h>

#include "hafenschauprovider.h"
#include "news/newssortfiltermodel.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setApplicationName(QStringLiteral("Hafenschau"));
    QCoreApplication::setApplicationVersion(APP_VERSION);
    QCoreApplication::setOrganizationName(QStringLiteral("nubecula.org"));
    QCoreApplication::setOrganizationDomain(QStringLiteral("nubecula.org"));

    qmlRegisterType<ContentItem>("org.nubecula.harbour.hafenschau", 1, 0, "ContentItem");
    qmlRegisterType<ContentItemAudio>("org.nubecula.harbour.hafenschau", 1, 0, "ContentItemAudio");
    qmlRegisterType<ContentItemBox>("org.nubecula.harbour.hafenschau", 1, 0, "ContentItemBox");
    qmlRegisterType<ContentItemGallery>("org.nubecula.harbour.hafenschau", 1, 0, "ContentItemGallery");
    qmlRegisterType<ContentItemRelated>("org.nubecula.harbour.hafenschau", 1, 0, "ContentItemRelated");
    qmlRegisterType<ContentItemSocial>("org.nubecula.harbour.hafenschau", 1, 0, "ContentItemSocial");
    qmlRegisterType<ContentItemVideo>("org.nubecula.harbour.hafenschau", 1, 0, "ContentItemVideo");
    qmlRegisterType<GalleryItem>("org.nubecula.harbour.hafenschau", 1, 0, "GalleryItem");
    qmlRegisterType<GalleryModel>("org.nubecula.harbour.hafenschau", 1, 0, "GalleryModel");
    qmlRegisterType<News>("org.nubecula.harbour.hafenschau", 1, 0, "News");
    qmlRegisterType<NewsModel>("org.nubecula.harbour.hafenschau", 1, 0, "NewsModel");
    qmlRegisterType<NewsSortFilterModel>("org.nubecula.harbour.hafenschau", 1, 0, "NewsSortFilterModel");
    qmlRegisterType<RegionsModel>("org.nubecula.harbour.hafenschau", 1, 0, "RegionsModel");
    qmlRegisterType<RelatedItem>("org.nubecula.harbour.hafenschau", 1, 0, "RelatedItem");
    qmlRegisterType<RelatedModel>("org.nubecula.harbour.hafenschau", 1, 0, "RelatedModel");

    qmlRegisterSingletonType<HafenschauProvider>("org.nubecula.harbour.hafenschau",
                                                       1,
                                                       0,
                                                       "HafenschauProvider",
                                                       [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {

                Q_UNUSED(engine)
                Q_UNUSED(scriptEngine)

                HafenschauProvider *provider = new HafenschauProvider;

                return provider;
            });




    return SailfishApp::main(argc, argv);
}
