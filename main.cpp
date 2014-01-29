#include "AppCSXCAD.h"

#include <QApplication>

int main(int argc, char *argv[])
{
#if not defined(__WIN32) && not defined(__WIN64)
	//prevent that Qt changes float handling, e.g. expecting a german 1,345e+3 will fail...
	setenv("LC_NUMERIC","C",1);
#endif
	QApplication a(argc, argv);
    AppCSXCAD w;
    w.show();
    return a.exec();
}
