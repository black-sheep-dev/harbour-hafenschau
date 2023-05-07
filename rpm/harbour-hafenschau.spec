# 
# Do NOT Edit the Auto-generated Part!
# Generated by: spectacle version 0.32
# 

Name:       harbour-hafenschau

# >> macros
# << macros
%define _binary_payload w2.xzdio

Summary:    Hafenschau
Version:    0.9.7
Release:    1
Group:      Qt/Qt
License:    MIT
BuildArch:  noarch
URL:        https://github.com/black-sheep-dev/harbour-hafenschau
Source0:    %{name}-%{version}.tar.bz2
Source100:  harbour-hafenschau.yaml
Requires:   sailfishsilica-qt5 >= 0.10.9
Requires:   libsailfishapp-launcher
BuildRequires:  pkgconfig(sailfishapp) >= 1.0.3
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  pkgconfig(qt5embedwidget)
BuildRequires:  pkgconfig(nemonotifications-qt5)
BuildRequires:  pkgconfig(keepalive)
BuildRequires:  qt5-qttools-linguist
BuildRequires:  desktop-file-utils

%description
Hafenschau is a native content viewer for german news portal www.tagesschau.de

%if "%{?vendor}" == "chum"
PackageName: Hafenschau
Type: desktop-application
Categories:
    - Utility
Custom:
    DescriptionMD: https://github.com/black-sheep-dev/harbour-hafenschau/raw/master/README.md
    Repo: https://github.com/black-sheep-dev/harbour-hafenschau/
Icon: https://raw.githubusercontent.com/black-sheep-dev/harbour-hafenschau/master/icons/172x172/harbour-hafenschau.png
Screenshots:
    - https://github.com/black-sheep-dev/harbour-hafenschau/raw/master/metadata/screenshot1.png
Url:
    Donation: https://www.paypal.com/paypalme/nubecula/1
%endif


%prep
%setup -q -n %{name}-%{version}

# >> setup
# << setup

%build
# >> build pre
# << build pre

%qmake5 

make %{?_smp_mflags}

# >> build post
# << build post

%install
rm -rf %{buildroot}
# >> install pre
# << install pre
%qmake5_install

# >> install post
# << install post

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(-,root,root,-)
%defattr(0644,root,root,-)
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.png
# >> files
# << files
