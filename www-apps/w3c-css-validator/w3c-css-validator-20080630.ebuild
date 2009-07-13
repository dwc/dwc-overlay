# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils java-pkg-2 java-ant-2

MY_PN="css-validator"
S=${WORKDIR}/${MY_PN}

DESCRIPTION="Check CSS for conformance to W3C recommendations and other standards"
HOMEPAGE="http://jigsaw.w3.org/${MY_PN}/"
SRC_URI="http://files.danieltwc.com/${P}.tar.bz2"
LICENSE="W3C"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="doc"
COMMON_DEPENDENCIES="dev-java/servletapi:2.3
	dev-java/jigsaw
	dev-java/xerces:2
	dev-java/tagsoup
	dev-java/velocity
	dev-java/commons-lang:2.1
	dev-java/commons-collections"
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEPENDENCIES}"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPENDENCIES}"

EANT_GENTOO_CLASSPATH="servletapi-2.3,jigsaw,xerces-2,tagsoup,velocity,commons-lang-2.1,commons-collections"
EANT_BUILD_TARGET="jar war"

src_prepare() {
	epatch "${FILESDIR}/${PN}-fix-resource-urls.patch"

	# Link in JAR files for the WEB-INF/lib in the WAR file
	mkdir -p WEB-INF/lib
	java-pkg_jar-from --into WEB-INF/lib ${EANT_GENTOO_CLASSPATH}

	# But remove the servletapi package due to:
	# INFO: validateJarFile(/var/lib/tomcat-6/webapps/w3c-css-validator/WEB-INF/lib/servlet.jar) - jar not loaded. See Servlet Spec 2.3, section 9.7.2. Offending class: javax/servlet/Servlet.class
	rm -f WEB-INF/lib/servlet.jar

	java-ant_rewrite-classpath
}

src_install() {
	java-pkg_newjar ${MY_PN}.jar ${PN}.jar

	mv ${MY_PN}.war ${PN}.war
	java-pkg_dowar ${PN}.war

	use doc && java-pkg_dojavadoc javadoc/
}

pkg_postinst() {
	einfo "To install the Web application, copy"
	einfo "\t/usr/share/${PN}/webapps/${PN}.war"
	einfo "to your servlet container's webapps directory and restart the server."
}
