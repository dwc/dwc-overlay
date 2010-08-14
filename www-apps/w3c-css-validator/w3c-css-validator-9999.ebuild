# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

ECVS_SERVER="dev.w3.org:/sources/public"
ECVS_MODULE="2002/css-validator"
ECVS_PASS="anonymous"
ECVS_LOCALNAME="${PN}"
S="${WORKDIR}"/"${PN}"

inherit cvs java-pkg-2 java-ant-2 webapp

MY_PN="css-validator"

DESCRIPTION="Check CSS for conformance to W3C recommendations and other standards"
HOMEPAGE="http://jigsaw.w3.org/${MY_PN}/"
LICENSE="W3C"

KEYWORDS="~amd64 ~x86"

IUSE="doc"
COMMON_DEPENDENCIES="
	dev-java/servletapi:2.3
	>=dev-java/jigsaw-2.2.6
	>=dev-java/commons-collections-3.2.1
	dev-java/commons-lang:2.5
	>=dev-java/velocity-1.6.4
	>=dev-java/xerces-2.9.1
	>=dev-java/tagsoup-1.2
"
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEPENDENCIES}"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPENDENCIES}"

EANT_GENTOO_CLASSPATH="jigsaw,xerces-2,tagsoup,velocity,commons-lang-2.5,commons-collections"

# Bypass the fetching of dependencies we include above
EANT_EXTRA_ARGS="-Dprepare.run=true"
EANT_BUILD_TARGET="jar war"

src_prepare() {
	# Link in JAR files for the WEB-INF/lib in the WAR file
	mkdir -p lib
	java-pkg_jar-from --into lib "${EANT_GENTOO_CLASSPATH}"

	# But remove the servletapi package due to:
	rm -f lib/servlet.jar

	java-ant_rewrite-classpath
}

src_compile() {
	# Include servlet API only for building to avoid e.g. Tomcat warnings:
	# INFO: validateJarFile(/var/lib/tomcat-6/webapps/w3c-css-validator/WEB-INF/lib/servlet.jar) - jar not loaded. See Servlet Spec 2.3, section 9.7.2. Offending class: javax/servlet/Servlet.class
	local EANT_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH},servletapi-2.3"

	java-pkg-2_src_compile
}

src_install() {
	# Install Java files
	java-pkg_newjar ${MY_PN}.jar ${PN}.jar

	mv ${MY_PN}.war ${PN}.war
	java-pkg_dowar ${PN}.war

	use doc && java-pkg_dojavadoc javadoc/

	# Install Web application files
	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins -r *.html* docs/ html/ images/ scripts/ style/ tabtastic/

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_src_install
}

pkg_postinst() {
	einfo "To install the Web application, copy"
	einfo "\t/usr/share/${PN}/webapps/${PN}.war"
	einfo "to your servlet container's webapps directory and restart the server."

	webapp_pkg_postinst
}
