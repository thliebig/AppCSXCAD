#
# spec file for package [spectemplate]
#
# Copyright (c) 2010 SUSE LINUX Products GmbH, Nuernberg, Germany.
#
# All modifications and additions to the file contributed by third parties
# remain the property of their copyright owners, unless otherwise agreed
# upon. The license for this file, and modifications and additions to the
# file, is the same license as for the pristine package itself (unless the
# license for the pristine package is not an Open Source License, in which
# case the license is the MIT License). An "Open Source License" is a
# license that conforms to the Open Source Definition (Version 1.9)
# published by the Open Source Initiative.

# Please submit bugfixes or comments via http://bugs.opensuse.org/
#

# norootforbuild

Name:           AppCSXCAD
Version:        0.1.1
Release:        1
Summary:        View CSXCAD geometries
Group:          Productivity/Scientific/Physics
License:        GPLv3
URL:            http://www.openems.de
Source0:        %{name}-%{version}.tar.bz2
#Patch0:         install.patch
Patch1:         start_script.patch
BuildRoot:      %_tmppath/%name-%version-build

# libfparser4-devel contains a static library => no runtime requirement
BuildRequires:  libqt4-devel gcc-c++ libfparser4-devel tinyxml-devel CSXCAD-devel vtk-devel vtk-qt QCSXCAD-devel


# determine qt4 qmake executable
%if 0%{?fedora}
    %global qmake qmake-qt4
%else
    %global qmake qmake
%endif



%description
View CSXCAD geometries. Based on QCSXCAD.


%prep
%setup -q
#%patch0 -p1
%patch1 -p1

%build
%qmake QMAKE_CFLAGS="%optflags" QMAKE_CXXFLAGS="%optflags" LIB_SUFFIX="$(echo %_lib | cut -b4-)" AppCSXCAD.pro
make %{?_smp_mflags}


%install
make INSTALL_ROOT=%{buildroot} install
find %{buildroot} -name '*.la' -exec rm -f {} ';'


%clean
rm -rf %{buildroot}


%files
%defattr(-,root,root)
/usr/bin/AppCSXCAD*



%changelog
* Sun Jun 17 2012 Sebastian Held <sebastian.held@gmx.de> - 0.1.1-1
- New upstream version
* Mon Jan 09 2012 Sebastian Held <sebastian.held@gmx.de> - 0.1.0-3
- Modified start script
* Wed Dec 28 2011 Sebastian Held <sebastian.held@gmx.de> - 0.1.0-2
- Fedora 16 build support
* Mon Dec 5 2011 Sebastian Held <sebastian.held@gmx.de> - 0.1.0-1
- initial version
