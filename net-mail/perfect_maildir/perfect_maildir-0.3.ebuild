# Copyright Daniel Westermann-Clark <daniel at acceleration dot net>
# Distributed under the terms of the GNU General Public License v2
# $Header$

DESCRIPTION="perfect_maildir is a simple but 'perfect' mbox to Maildir converter"
HOMEPAGE="http://perfectmaildir.home-dn.net/"
SRC_URI="http://perfectmaildir.home-dn.net/${PN}/${PN}.pl"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="nomirror"

IUSE=""
RDEPEND="dev-lang/perl
	dev-perl/TimeDate"

src_unpack() {
	mkdir -p ${S} && cp ${DISTDIR}/${A} ${S} || die
	cd ${S} || die
}

src_install() {
	dobin ${PN}.pl
}
