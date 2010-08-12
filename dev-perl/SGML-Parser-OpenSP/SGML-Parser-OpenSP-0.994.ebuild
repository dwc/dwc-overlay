# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

MODULE_AUTHOR=BJOERN
inherit perl-module

DESCRIPTION="Parse SGML documents using OpenSP"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~x86"
# XXX: Permissions issues with tempfile
#SRC_TEST="do"

IUSE="test"
RDEPEND="dev-perl/Class-Accessor
	virtual/perl-File-Temp
	app-text/opensp"
DEPEND="${RDEPEND}
	test? ( dev-perl/Test-Exception )"
