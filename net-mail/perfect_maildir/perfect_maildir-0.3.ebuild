# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="perfect_maildir is a simple but 'perfect' mbox to Maildir converter"
HOMEPAGE="http://perfectmaildir.home-dn.net/"
SRC_URI="http://perfectmaildir.home-dn.net/${PN}/${PN}.pl"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
RDEPEND="dev-perl/TimeDate"

src_unpack() {
	mkdir -p "${S}" && cp "${DISTDIR}/${A}" "${S}" || die
	cd "${S}" || die
}

src_install() {
	dobin ${PN}.pl
}
