/*
*	Copyright (C) 2012-2015 Thorsten Liebig (Thorsten.Liebig@gmx.de)
*
*	This program is free software: you can redistribute it and/or modify
*	it under the terms of the GNU General Public License as published by
*	the Free Software Foundation, either version 3 of the License, or
*	(at your option) any later version.
*
*	This program is distributed in the hope that it will be useful,
*	but WITHOUT ANY WARRANTY; without even the implied warranty of
*	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*	GNU General Public License for more details.
*
*	You should have received a copy of the GNU General Public License
*	along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include "AppCSXCAD.h"

#include "vtkCommand.h"
#if VTK_MAJOR_VERSION>=8
  #include <QVTKOpenGLWidget.h>
  #include <QSurfaceFormat>
#endif
#include <QApplication>

int main(int argc, char *argv[])
{
#if VTK_MAJOR_VERSION>=8
    QSurfaceFormat::setDefaultFormat(QVTKOpenGLWidget::defaultFormat());
#endif
#if not defined(__WIN32) && not defined(__WIN64)
	//prevent that Qt changes float handling, e.g. expecting a german 1,345e+3 will fail...
	setenv("LC_NUMERIC","C",1);
#endif
	QApplication a(argc, argv);
	AppCSXCAD w;
	w.show();
	return a.exec();
}
