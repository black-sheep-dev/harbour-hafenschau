#ifndef COMMENTSSORTFILTERMODEL_H
#define COMMENTSSORTFILTERMODEL_H

#include <QSortFilterProxyModel>

class CommentsSortFilterModel : public QSortFilterProxyModel
{
    Q_OBJECT

    Q_PROPERTY(Qt::SortOrder sortOrder READ sortOrder WRITE setSortOrder NOTIFY sortOrderChanged)

public:
    explicit CommentsSortFilterModel(QObject *parent = nullptr);

    Q_INVOKABLE void setPattern(const QString &pattern);

    // properties
    Qt::SortOrder sortOrder() const;

signals:
    // properties
    void sortOrderChanged(Qt::SortOrder sortOrder);

public slots:
    void sortModel(Qt::SortOrder order = Qt::AscendingOrder);

    // properties
    void setSortOrder(Qt::SortOrder sortOrder);

private:
    QString m_pattern;
    Qt::SortOrder m_sortOrder{Qt::AscendingOrder};

    // QSortFilterProxyModel interface
protected:
    bool filterAcceptsRow(int source_row, const QModelIndex &source_parent) const override;
};

#endif // COMMENTSSORTFILTERMODEL_H
