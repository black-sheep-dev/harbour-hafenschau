#ifndef DEVELOPEROPTION_H
#define DEVELOPEROPTION_H

#include <QObject>

class DeveloperOption {
    Q_GADGET

public:
    enum Option {
        None                    = 0x00,
        SaveNews                = 0x01,
        ShowUnkownContent       = 0x02
    };
    Q_ENUM(Option)
    Q_DECLARE_FLAGS(Options, Option)
};
Q_DECLARE_OPERATORS_FOR_FLAGS(DeveloperOption::Options)

#endif // DEVELOPEROPTION_H
