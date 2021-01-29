
#include <QtQuick>

#include <sailfishapp.h>

#include "hafenschauprovider.h"
#include "news/newssortfiltermodel.h"

//some constants to parameterize.
const qint64 LOG_FILE_LIMIT = 3000000;
const QString LOG_PATH = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
const QString LOG_FILENAME = "/hafenschau.log";

void redirectDebugMessages(QtMsgType type, const QMessageLogContext & context, const QString & str)
{
    Q_UNUSED(context)

    //thread safety
    QMutex mutex;
    mutex.lock();
    QString txt;

    //prepend timestamp to every message
    QString datetime = QDateTime::currentDateTime().toString("yyyy.MM.dd hh:mm:ss");
    //prepend a log level label to every message
    switch (type) {
    case QtDebugMsg:
        txt = QString("[Debug*] ");
        break;
    case QtWarningMsg:
        txt = QString("[Warning] ");
    break;
    case QtInfoMsg:
        txt = QString("[Info] ");
    break;
    case QtCriticalMsg:
        txt = QString("[Critical] ");
    break;
    case QtFatalMsg:
        txt = QString("[Fatal] ");
    }

    QString filePath = LOG_PATH + LOG_FILENAME;
    QFile outFile(filePath);

    //if file reached the limit, rotate to filename.1
    if(outFile.size() > LOG_FILE_LIMIT){
        //roll the log file.
        QFile::remove(filePath + ".1");
        QFile::rename(filePath, filePath + ".1");
        QFile::resize(filePath, 0);
    }

    //write message
    outFile.open(QIODevice::WriteOnly | QIODevice::Append);
    QTextStream ts(&outFile);
    ts << datetime << txt << str << endl;

    //close fd
    outFile.close();
    mutex.unlock();
}

int main(int argc, char *argv[])
{
#ifdef QT_DEBUG
    qInstallMessageHandler(redirectDebugMessages);
#endif

    QCoreApplication::setApplicationName(QStringLiteral("Hafenschau"));
    QCoreApplication::setApplicationVersion(APP_VERSION);
    QCoreApplication::setOrganizationName(QStringLiteral("nubecula.org"));
    QCoreApplication::setOrganizationDomain(QStringLiteral("nubecula.org"));

    qmlRegisterType<ContentItem>("org.nubecula.harbour.hafenschau", 1, 0, "ContentItem");
    qmlRegisterType<ContentItemAudio>("org.nubecula.harbour.hafenschau", 1, 0, "ContentItemAudio");
    qmlRegisterType<ContentItemBox>("org.nubecula.harbour.hafenschau", 1, 0, "ContentItemBox");
    qmlRegisterType<ContentItemGallery>("org.nubecula.harbour.hafenschau", 1, 0, "ContentItemGallery");
    qmlRegisterType<ContentItemList>("org.nubecula.harbour.hafenschau", 1, 0, "ContentItemList");
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

                auto *provider = new HafenschauProvider();

                return provider;
            });




    return SailfishApp::main(argc, argv);
}
