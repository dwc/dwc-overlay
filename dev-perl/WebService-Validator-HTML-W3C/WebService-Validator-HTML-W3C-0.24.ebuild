# Copyright Daniel Westermann-Clark <daniel at acceleration dot net>
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit perl-module

DESCRIPTION="Access the W3C's online HTML validator"
HOMEPAGE="http://search.cpan.org/dist/${PN}/"
SRC_URI="mirror://cpan/authors/id/S/ST/STRUAN/${P}.tar.gz"
LICENSE="|| ( Artistic GPL-2 )"

SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="nomirror"

IUSE=""
RDEPEND="dev-lang/perl
	dev-perl/Class-Accessor
	dev-perl/libwww-perl
	dev-perl/XML-XPath"
DEPEND="virtual/perl-Module-Build
	${RDEPEND}"
