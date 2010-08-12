# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit webapp

MY_PN=${PN/w3c-markup-/}
S=${WORKDIR}/${MY_PN}-${PV}

DESCRIPTION="Check documents for conformance to W3C Recommendations and other standards"
HOMEPAGE="http://validator.w3.org/"
SRC_URI="http://validator.w3.org/${MY_PN}.tar.gz -> ${P}.tar.gz
	http://validator.w3.org/sgml-lib.tar.gz -> sgml-lib-${PV}.tar.gz"
LICENSE="W3C"

KEYWORDS="~amd64 ~x86"

IUSE=""
RDEPEND=">=dev-lang/perl-5.8.0
	>=virtual/perl-CGI-2.81
	>=dev-perl/config-general-2.32
	virtual/perl-Encode
	dev-perl/Encode-HanExtra
	virtual/perl-File-Spec
	>=dev-perl/HTML-Encoding-0.52
	>=dev-perl/HTML-Parser-3.60
	>=dev-perl/HTML-Template-2.6
	>=dev-perl/JSON-2.00
	>=dev-perl/libwww-perl-5.804
	dev-perl/Net-IP
	>=dev-perl/SGML-Parser-OpenSP-0.991
	dev-perl/URI
	>=dev-perl/XML-LibXML-1.70
	dev-perl/Encode-JIS2K
	dev-perl/HTML-Tidy"

src_prepare() {
	mv htdocs/config/ config/
	mv htdocs/sgml-lib/ sgml-lib/
}

src_install() {
	webapp_src_preinst
	dodir "${MY_HOSTROOTDIR}/${PN}" "${MY_CGIBINDIR}/${PN}"

	insinto "${MY_HOSTROOTDIR}/${PN}"
	doins -r share/templates/ config/ sgml-lib/

	exeinto "${MY_CGIBINDIR}/${PN}"
	doexe httpd/cgi-bin/*

	insinto "${MY_HTDOCSDIR}"
	doins -r htdocs/*

	webapp_configfile "${MY_HOSTROOTDIR}/${PN}"/config/validator.conf
	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt

	webapp_src_install
}
