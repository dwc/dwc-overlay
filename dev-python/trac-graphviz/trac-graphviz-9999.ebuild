# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

# Checkout from Subversion because trac-hacks.org does not provide a versioned SRC_URI
MY_PN="graphvizplugin"
TRAC_VERSION="0.11"
ESVN_REPO_URI="http://trac-hacks.org/svn/${MY_PN}/${TRAC_VERSION}/"

inherit distutils subversion

DESCRIPTION="Draw graphs in Trac using Graphviz"
HOMEPAGE="http://trac-hacks.org/wiki/GraphvizPlugin"
LICENSE="as-is"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
RDEPEND=">=www-apps/trac-${TRAC_VERSION}
	media-gfx/graphviz"
DEPEND="${RDEPEND}"

S="${WORKDIR}"
