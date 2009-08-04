#include "AppCSXCAD.h"

#include <QtGui>
#include <QApplication>

int main(int argc, char *argv[])
{
	QApplication a(argc, argv);
    AppCSXCAD w;
    w.show();
    return a.exec();
}
