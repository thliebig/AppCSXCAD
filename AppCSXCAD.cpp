#include "AppCSXCAD.h"

AppCSXCAD::AppCSXCAD(QWidget *parent) : QCSXCAD(parent)
{
	QMenuBar* mb = menuBar();
	QMenu *FileMenu = mb->addMenu("File");

	FileMenu->addAction(QIcon(":/images/filenew.png"),tr("New"),this,SLOT(New()),QKeySequence(tr("Ctrl+N")));
	FileMenu->addAction(QIcon(":/images/fileopen.png"),tr("Load"),this,SLOT(ImportGeometry()),QKeySequence(tr("Ctrl+L")));
	FileMenu->addSeparator();
	FileMenu->addAction(QIcon(":/images/filesave.png"),tr("Save"),this,SLOT(Save()),QKeySequence(tr("Ctrl+S")));
	FileMenu->addAction(QIcon(":/images/filesave.png"),tr("Save As"),this,SLOT(ExportGeometry()));
	//FileMenu->addAction(QIcon(":/images/filesaveas.png"),tr("Save As.."),this,SLOT(SaveAs()));
	QMenu *FileExportMenu = FileMenu->addMenu(tr("E&xport"));
	FileExportMenu->addAction(QIcon(":/images/filesave.png"),tr("&Povray"),this,SLOT(ExportGeometry_Povray()));
	FileMenu->addSeparator();
	FileMenu->addAction(QIcon(":/images/exit.png"),tr("Exit"),qApp,SLOT(quit()));

	QMenu *InfoMenu = mb->addMenu("Info");
	InfoMenu->addAction(tr("About"),this,SLOT(aboutQCSXCAD()));

	QStringList argList=qApp->arguments();
	if (argList.size()>=2)
	{
		if (ReadFile(argList.at(1))==false)
			QMessageBox::information(this,"File Error!",tr("Can't open file: %1").arg(argList.at(1)));
		GUIUpdate();
	}
}

AppCSXCAD::~AppCSXCAD()
{

}

bool AppCSXCAD::ReadFile(QString filename)
{
	m_filename=filename;
	return QCSXCAD::ReadFile(filename);
}

void AppCSXCAD::Save()
{
	Write2XML(m_filename);
}

void AppCSXCAD::clear()
{
	m_filename=QString();
	QCSXCAD::clear();
}

