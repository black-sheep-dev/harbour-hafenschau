#ifndef RESSORT_H
#define RESSORT_H

#include <QObject>

class Ressort {
    Q_GADGET
public:
    enum Type {
        Undefined,
        Ausland,
        Inland,
        Investigativ,
        Regional,
        Search,
        Sport,
        Video,
        Wirtschaft
    };
    Q_ENUM(Type)
};

#endif // RESSORT_H
