#include "AppCSXCAD.h"

#include <QtGui>
#include <QApplication>

int main(int argc, char *argv[])
{
	//prevent that Qt changes float handling, e.g. expecting a german 1,345e+3 will fail...
	setenv("LC_NUMERIC","C",1);
	QApplication a(argc, argv);
    AppCSXCAD w;
    w.show();
    return a.exec();
}
