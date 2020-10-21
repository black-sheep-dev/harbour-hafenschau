#include "regionsmodel.h"

RegionsModel::RegionsModel(QObject *parent) :
    QAbstractListModel(parent)
{
    m_names << QStringLiteral("Baden-Württemberg")
            << QStringLiteral("Bayern")
            << QStringLiteral("Berlin")
            << QStringLiteral("Brandenburg")
            << QStringLiteral("Bremen")
            << QStringLiteral("Hamburg")
            << QStringLiteral("Hessen")
            << QStringLiteral("Mecklenburg-Vorpommern")
            << QStringLiteral("Niedersachsen")
            << QStringLiteral("Nordrhein-Westfalen")
            << QStringLiteral("Rheinland-Pfalz")
            << QStringLiteral("Saarland")
            << QStringLiteral("Sachsen")
            << QStringLiteral("Sachsen-Anhalt")
            << QStringLiteral("Schleswig-Holstein")
            << QStringLiteral("Thüringen");
}

QList<int> RegionsModel::activeRegions() const
{
    return m_activeRegions;
}

void RegionsModel::resetRegions()
{
    beginResetModel();
    m_activeRegions.clear();
    endResetModel();

    emit activeRegionsChanged(m_activeRegions);
}

void RegionsModel::setActiveRegions(const QList<int> &regions)
{
    beginResetModel();
    m_activeRegions = regions;
    endResetModel();
}

int RegionsModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)

    return m_names.count();
}

QVariant RegionsModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    switch (role) {
    case NameRole:
        return m_names.at(index.row());

    case ActiveRole:
        return m_activeRegions.contains(index.row() + 1);

    default:
        return QVariant();
    }
}

bool RegionsModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (!index.isValid())
        return false;

    const int idx = index.row() + 1;

    switch (role) {
    case ActiveRole:
        if (value.toBool()) {
            if (!m_activeRegions.contains(idx))
                m_activeRegions.append(idx);
        } else {
            m_activeRegions.removeAll(idx);
        }
        emit dataChanged(index, index);
        emit activeRegionsChanged(m_activeRegions);
        break;

    default:
        break;
    }

    return true;
}

QHash<int, QByteArray> RegionsModel::roleNames() const
{
    QHash<int, QByteArray> roles;

    roles[NameRole]     = "name";
    roles[ActiveRole]   = "active";

    return roles;
}
