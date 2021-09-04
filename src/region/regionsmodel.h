#ifndef REGIONSMODEL_H
#define REGIONSMODEL_H

#include <QAbstractListModel>

class RegionsModel : public QAbstractListModel
{
    Q_OBJECT

    Q_PROPERTY(QList<int> activeRegions READ activeRegions WRITE setActiveRegions NOTIFY activeRegionsChanged)

public:
    enum RegionRoles {
        NameRole            = Qt::UserRole + 1,
        ActiveRole
    };
    Q_ENUM(RegionRoles)

    explicit RegionsModel(QObject *parent = nullptr);

    QList<int> activeRegions() const;
    Q_INVOKABLE void resetRegions();
    void setActiveRegions(const QList<int> &regions);

signals:
    void activeRegionsChanged(const QList<int> &regions);

private:
    QList<int> m_activeRegions;
    QStringList m_names;

    // QAbstractItemModel interface
public:
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;
    QHash<int, QByteArray> roleNames() const override;
};

#endif // REGIONSMODEL_H
