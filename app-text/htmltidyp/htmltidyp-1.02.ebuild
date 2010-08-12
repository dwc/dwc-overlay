# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils autotools

S="${WORKDIR}"/tidyp-${PV}

DESCRIPTION="Tidy the layout and correct errors in HTML and XML documents"
HOMEPAGE="http://tidyp.com/"
SRC_URI="http://github.com/downloads/petdance/tidyp/tidyp-${PV}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

IUSE="debug"
DEPEND=""

src_prepare() {
	# Stop tidyp from appending -O2 to our CFLAGS
	epatch "${FILESDIR}"/htmltidyp-1.02-strip-O2-flag.patch || die

	eautoreconf
}

src_configure() {
	econf $(use_enable debug) || die
}

src_install() {
	make DESTDIR="${D}" install || die
}
