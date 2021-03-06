# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit apache-module libtool

DESCRIPTION="Apache module and agent for the open-source authentication system"
HOMEPAGE="http://shibboleth.internet2.edu/"
SRC_URI="http://www.shibboleth.net/downloads/service-provider/${PV}/${PN}-sp-${PV}.tar.gz"
LICENSE="Apache-2.0"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="doc odbc"
RDEPEND=">=dev-libs/xerces-c-3.0[-iconv]
	>=dev-libs/xml-security-c-1.5
	=dev-libs/xmltooling-1.4*
	=dev-libs/opensaml-2.4*
	>=dev-libs/log4shib-1.0.4
	dev-libs/openssl
	odbc? ( dev-db/unixODBC )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

APACHE2_MOD_FILE="${D}/usr/$(get_libdir)/${PN}/mod_shib_22.so"
APACHE2_MOD_CONF="98_mod_shib"
APACHE2_MOD_DEFINE="SHIBBOLETH"

need_apache2_2

src_prepare() {
	elibtoolize --reverse-deps
}

src_configure() {
	# Package uses ${localstatedir} for /var/log and /var/run, so override default of /var/lib
	econf \
		--localstatedir=/var \
		--enable-apache-22 \
		--with-apxs22="${APXS}" \
		$(use_enable doc doxygen) \
		$(use_enable odbc) \
		|| die "econf failed"
}

src_compile() {
	# Override the apache-module src_compile to build shibd et al
	emake || die "emake failed"
}

src_install() {
	# Install shibd et al
	emake NOKEYGEN=1 DESTDIR="${D}" install || die "emake install failed"

	# Remove useless libtool archives (also, make install breaks them by removing libshibsp.la and libshibsp-lite.la)
	find "${D}" -name '*.la' -delete || die "error removing libtool archives"

	# Install the Apache module and related files for Gentoo
	apache-module_src_install

	newinitd "${FILESDIR}"/shibd.initd shibd
	newconfd "${FILESDIR}"/shibd.confd shibd
}

pkg_preinst() {
	# Remove non-standard log directory
	sed -i -e 's:/var/log/httpd:/var/log/apache2:g' "${D}"/etc/shibboleth/*.logger || die "error fixing log directory"
	rmdir "${D}"/var/log/httpd || die "error removing log directory"
}
