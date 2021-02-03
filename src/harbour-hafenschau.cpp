
#include <QtQuick>

#include <sailfishapp.h>

#include "hafenschauprovider.h"
#include "comments/commentssortfiltermodel.h"
#include "news/newssortfiltermodel.h"

//some constants to parameterize.
const qint64 LOG_FILE_LIMIT = 3000000;
const QString LOG_PATH = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
static const QString LOG_FILENAME = QStringLiteral("/hafenschau.log");

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

    qDebug() << txt;

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
    //qInstallMessageHandler(redirectDebugMessages);
#endif

    QCoreApplication::setApplicationName(QStringLiteral("Hafenschau"));
    QCoreApplication::setApplicationVersion(APP_VERSION);
    QCoreApplication::setOrganizationName(QStringLiteral("nubecula.org"));
    QCoreApplication::setOrganizationDomain(QStringLiteral("nubecula.org"));

#ifndef QT_DEBUG
    auto uri = "org.nubecula.harbour.hafenschau";
#else
#   define uri "org.nubecula.harbour.hafenschau"
#endif

    qmlRegisterType<CommentsModel>(uri, 1, 0, "CommentsModel");
    qmlRegisterType<CommentsSortFilterModel>(uri, 1, 0, "CommentsSortFilterModel");
    qmlRegisterType<ContentItem>(uri, 1, 0, "ContentItem");
    qmlRegisterType<ContentItemAudio>(uri, 1, 0, "ContentItemAudio");
    qmlRegisterType<ContentItemBox>(uri, 1, 0, "ContentItemBox");
    qmlRegisterType<ContentItemGallery>(uri, 1, 0, "ContentItemGallery");
    qmlRegisterType<ContentItemList>(uri, 1, 0, "ContentItemList");
    qmlRegisterType<ContentItemRelated>(uri, 1, 0, "ContentItemRelated");
    qmlRegisterType<ContentItemSocial>(uri, 1, 0, "ContentItemSocial");
    qmlRegisterType<ContentItemVideo>(uri, 1, 0, "ContentItemVideo");
    qmlRegisterType<GalleryItem>(uri, 1, 0, "GalleryItem");
    qmlRegisterType<GalleryModel>(uri, 1, 0, "GalleryModel");
    qmlRegisterType<News>(uri, 1, 0, "News");
    qmlRegisterType<NewsModel>(uri, 1, 0, "NewsModel");
    qmlRegisterType<NewsSortFilterModel>(uri, 1, 0, "NewsSortFilterModel");
    qmlRegisterType<RegionsModel>(uri, 1, 0, "RegionsModel");
    qmlRegisterType<RelatedItem>(uri, 1, 0, "RelatedItem");
    qmlRegisterType<RelatedModel>(uri, 1, 0, "RelatedModel");

    qmlRegisterSingletonType<HafenschauProvider>(uri,
                                                       1,
                                                       0,
                                                       "HafenschauProvider",
                                                       [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {

                Q_UNUSED(engine)
                Q_UNUSED(scriptEngine)

                auto provider = new HafenschauProvider();

                return provider;
            });




    return SailfishApp::main(argc, argv);
}
