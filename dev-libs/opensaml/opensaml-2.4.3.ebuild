# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="C++ libraries for interacting with Security Assertion Markup Language (SAML)"
HOMEPAGE="https://wiki.shibboleth.net/confluence/display/OpenSAML/Home"
SRC_URI="http://www.shibboleth.net/downloads/c++-${PN}/${PV}/${P}.tar.gz"
LICENSE="Apache-2.0"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="doc"
RDEPEND="sys-libs/zlib
	dev-libs/log4shib
	dev-libs/openssl
	net-misc/curl
	dev-libs/xerces-c
	dev-libs/xml-security-c
	dev-libs/xmltooling"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_configure() {
	econf \
		$(use_enable doc doxygen) \
		|| die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
