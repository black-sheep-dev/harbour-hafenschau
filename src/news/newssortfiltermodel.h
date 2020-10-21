#ifndef NEWSSORTFILTERMODEL_H
#define NEWSSORTFILTERMODEL_H

#include <QSortFilterProxyModel>

#include "newsmodel.h"

class NewsSortFilterModel : public QSortFilterProxyModel
{
    Q_OBJECT
public:
    explicit NewsSortFilterModel(QObject *parent = nullptr);

    Q_INVOKABLE int sourceIndex(const QModelIndex &index) const;
};

#endif // NEWSSORTFILTERMODEL_H
