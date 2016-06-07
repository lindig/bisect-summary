Name:           ocaml-bisect-summary
Version:        0.5
Release:        1%{?dist}
Summary:        Report code coverage from bisect_ppx runtime files
License:        MIT
URL:            https://github.com/lindig/bisect-summary
Source0:        https://github.com/lindig/%{name}/archive/%{version}/%{name}-%{version}.tar.gz
BuildRequires:  oasis
BuildRequires:  ocaml
BuildRequires:  ocaml-findlib
BuildRequires:  ocaml-bisect-ppx-devel

%description

Bisect-summary reads bisect*.out files produced by code that was
instrumented with bisect_ppx for code coverage profiling. Unlike
bisect-ppx-report (the canonical tool), this tool only needs the files
produced at runtime and doesn't require access to the source code and
point files that bisect_ppx produces at compile time.

%prep
%setup -q -n bisect-summary-%{version}

%build
ocaml setup.ml -configure --prefix /usr --destdir %{buildroot}
make

%install
make install

%files
%doc LICENSE
%doc README.md
%{_bindir}/bisect-summary


%changelog
* Tue Jun  7 2016 Christian Lindig <christian.lindig@citrix.com> - 0.5-1
* Fri Jun  3 2016 Christian Lindig <christian.lindig@citrix.com> - 0.4-1
  Initial packaging
