# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

MODULE_AUTHOR=STRUAN
inherit perl-module

DESCRIPTION="Access the W3C's online HTML validator"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~x86"
#SRC_TEST="do"

IUSE=""
RDEPEND="dev-perl/Class-Accessor
	dev-perl/libwww-perl
	dev-perl/XML-XPath"
DEPEND="virtual/perl-Module-Build
	${RDEPEND}"
