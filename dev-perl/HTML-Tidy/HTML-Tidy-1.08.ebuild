# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

MODULE_AUTHOR=PETDANCE
inherit perl-module

DESCRIPTION="(X)HTML validation in a Perl object"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~x86"
SRC_TEST="do"

IUSE="test"
RDEPEND="app-text/htmltidy
	dev-perl/libwww-perl"
DEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple )"
