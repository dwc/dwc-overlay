# Copyright Daniel Westermann-Clark <daniel at acceleration dot net>
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit webapp

MY_PN=${PN/w3c-markup-/}
S=${WORKDIR}/${MY_PN}-${PV}

DESCRIPTION="Check documents for conformance to W3C Recommendations and other standards"
HOMEPAGE="http://validator.w3.org/"
SRC_URI="http://validator.w3.org/${MY_PN}.tar.gz
	http://validator.w3.org/sgml-lib.tar.gz"
LICENSE="W3C"

KEYWORDS="amd64 x86"
RESTRICT="nomirror"

IUSE=""
RDEPEND=">=dev-lang/perl-5.6.0
	>=dev-perl/config-general-2.19
	>=dev-perl/HTML-Parser-3.25
	>=dev-perl/HTML-Template-2.6
	>=dev-perl/libwww-perl-5.64
	dev-perl/Net-IP
	dev-perl/Set-IntSpan
	dev-perl/Text-Iconv
	dev-perl/URI
	app-text/opensp"

src_unpack() {
	unpack ${A}
	cd ${S}

	mv htdocs/config/ config/
	mv htdocs/sgml-lib/ sgml-lib/
}

src_install() {
	webapp_src_preinst
	dodir ${MY_HOSTROOTDIR}/${PN} ${MY_CGIBINDIR}/${PN}

	insinto ${MY_HOSTROOTDIR}/${PN}
	doins -r share/templates/ config/ sgml-lib/

	exeinto ${MY_CGIBINDIR}/${PN}
	doexe httpd/cgi-bin/*

	insinto ${MY_HTDOCSDIR}
	doins -r htdocs/*

	webapp_configfile ${MY_HOSTROOTDIR}/${PN}/config/validator.conf
	webapp_postinst_txt en ${FILESDIR}/postinstall-en.txt

	webapp_src_install
}
