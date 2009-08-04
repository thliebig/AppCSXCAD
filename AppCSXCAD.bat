echo off
set PATH=D:\Programme\Qt\2009.01\qt\bin
set PATH=%PATH%;D:\Programme\Qt\2009.01\bin;D:\Programme\Qt\2009.01\mingw\bin
set PATH=%PATH%;%SystemRoot%\System32
set PATH=%PATH%;D:\devel\CSXCAD\release;D:\devel\QCSXCAD\release
set PATH=%PATH%;D:\devel\tinyxml\release
set PATH=%PATH%;D:\devel\fparser\release
set PATH=%PATH%;D:\opt\VTK\bin
echo on
echo %PATH%

.\release\AppCSXCAD.exe