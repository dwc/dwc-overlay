# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

MODULE_AUTHOR=BJOERN
inherit perl-module

DESCRIPTION="Determine the encoding of HTML/XML/XHTML documents"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~x86"
SRC_TEST="do"

IUSE="test"
RDEPEND="dev-perl/HTML-Parser
	dev-perl/libwww-perl"
DEPEND="${RDEPEND}"
