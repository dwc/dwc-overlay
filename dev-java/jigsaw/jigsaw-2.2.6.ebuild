# Copyright Daniel Westermann-Clark <daniel at acceleration dot net>
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit eutils java-pkg-2 java-ant-2

S="${WORKDIR}/Jigsaw"

DESCRIPTION="The W3C Java-based Web server"
HOMEPAGE="http://jigsaw.w3.org/"
SRC_URI="http://jigsaw.w3.org/Distrib/${PN}_${PV}.tar.bz2"
LICENSE="W3C"

SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="nomirror"

IUSE="doc"
COMMON_DEPENDENCIES="dev-java/jakarta-oro:2.0
	dev-java/jtidy
	dev-java/sax
	dev-java/servletapi:2.3
	dev-java/xerces:2
	dev-java/xp"
DEPEND=">=virtual/jdk-1.4
	${COMMON_DEPENDENCIES}"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEPENDENCIES}"

EANT_GENTOO_CLASSPATH="jakarta-oro-2.0,jtidy,sax,servletapi-2.3,xerces-2,xp"
EANT_DOC_TARGET="javadocs"

src_unpack() {
	unpack "${A}"
	cd "${S}"

	epatch "${FILESDIR}/${PN}-build-classpath.patch"

	java-ant_rewrite-classpath
	rm -v classes/*.jar || die "jar cleanup failed"
}

src_compile() {
	local EANT_EXTRA_ARGS="-Dgentoo.tools.jar=$(java-config --tools)"
	java-pkg-2_src_compile
}

src_install() {
	java-pkg_dojar classes/jigsaw.jar classes/jigadmin.jar classes/jigedit.jar

	dodoc ANNOUNCE COPYRIGHT README Readme.txt SAX_COPYING.txt SERVLET_COPYING.txt XERCES_COPYING.txt XP_COPYING.txt
	use doc && java-pkg_dojavadoc ant.build/javadocs/
}
