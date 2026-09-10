#include <QApplication>
#include <QIcon>
#include <QString>

#include "ui/MainWindow.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QApplication::setApplicationName("BetterTTY");
    QApplication::setApplicationDisplayName("BetterTTY");
    QApplication::setApplicationVersion(QStringLiteral(BETTERTTY_VERSION_STRING));
    QApplication::setOrganizationName("DD-LAB");
    QApplication::setOrganizationDomain("dd-lab.hr");
    QApplication::setWindowIcon(QIcon(QStringLiteral(":/icons/bettertty.png")));

    MainWindow window;
    window.show();

    return app.exec();
}
