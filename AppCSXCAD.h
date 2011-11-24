#ifndef APPCSXCAD_H
#define APPCSXCAD_H

#include <QtGui>
#include "QCSXCAD.h"

#define __APPNAME__ "AppCSXCAD"

class AppCSXCAD : public QCSXCAD
{
    Q_OBJECT

public:
    AppCSXCAD(QWidget *parent = 0);
    virtual ~AppCSXCAD();

    virtual bool ReadFile(QString filename);

public slots:
	void Save();
	virtual void clear();

protected:
	void SaveSettings();
	void LoadSettings();
	QString m_filename;
};

#endif // APPCSXCAD_H
