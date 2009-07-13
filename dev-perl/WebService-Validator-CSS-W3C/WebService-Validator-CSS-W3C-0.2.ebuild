# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

MODULE_AUTHOR=OLIVIERT
inherit perl-module

SRC_URI="mirror://cpan/authors/id/O/OL/OLIVIERT/WebService/${P}.tar.gz"

DESCRIPTION="Interface to the W3C CSS Validator"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~x86"
#SRC_TEST="do"

IUSE=""
RDEPEND=">=dev-perl/SOAP-Lite-0.65
	dev-perl/libwww-perl
	dev-perl/URI
	dev-perl/Class-Accessor"
DEPEND="${RDEPEND}"
