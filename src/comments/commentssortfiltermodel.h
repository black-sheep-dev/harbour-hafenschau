#ifndef COMMENTSSORTFILTERMODEL_H
#define COMMENTSSORTFILTERMODEL_H

#include <QSortFilterProxyModel>

class CommentsSortFilterModel : public QSortFilterProxyModel
{
    Q_OBJECT

public:
    explicit CommentsSortFilterModel(QObject *parent = nullptr);

    Q_INVOKABLE void setPattern(const QString &pattern);
    Q_INVOKABLE void sortModel(Qt::SortOrder order = Qt::AscendingOrder);

private:
    QString m_pattern;

    // QSortFilterProxyModel interface
protected:
    bool filterAcceptsRow(int source_row, const QModelIndex &source_parent) const override;
};

#endif // COMMENTSSORTFILTERMODEL_H
