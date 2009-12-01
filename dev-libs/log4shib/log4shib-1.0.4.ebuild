# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="log4cpp for Shibboleth"
HOMEPAGE="https://spaces.internet2.edu/display/OpenSAML/log4shib"
SRC_URI="http://shibboleth.internet2.edu/downloads/${PN}/${PV}/${P}.tar.gz"
LICENSE="LGPL-2.1"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="doc"
RDEPEND=""
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_configure() {
	econf \
		$(use_enable doc doxygen) \
		|| die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README THANKS
}
