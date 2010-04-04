# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="A single-player implementation of the card game Race for the Galaxy, with AI opponents"
HOMEPAGE="http://keldon.net/${PN}/"
SRC_URI="http://warpcore.org/${PN}/${P}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
RDEPEND=">=x11-libs/gtk+-2.16"

src_compile() {
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
