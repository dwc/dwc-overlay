# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="A higher level interface to XML processing, particularly in light of signing and encryption"
HOMEPAGE="https://spaces.internet2.edu/display/OpenSAML/XMLTooling-C"
SRC_URI="http://shibboleth.internet2.edu/downloads/opensaml/cpp/2.2.1/${P}.tar.gz"
LICENSE="Apache-2.0"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="doc"
RDEPEND="dev-libs/openssl
	net-misc/curl
	dev-libs/log4shib
	dev-libs/xerces-c
	dev-libs/xml-security-c"
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
