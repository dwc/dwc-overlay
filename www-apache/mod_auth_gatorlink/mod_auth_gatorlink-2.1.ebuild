# Copyright Daniel Westermann-Clark <daniel at acceleration dot net>
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit apache-module

DESCRIPTION="An Apache 2.x authentication module backed against GatorLink"
HOMEPAGE="http://login.gatorlink.ufl.edu/support/web.html"
SRC_URI="http://login.gatorlink.ufl.edu/support/${P}.tar.gz"
LICENSE="LGPL-2.1"

SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="nomirror"

IUSE=""

# Call this before the definitions below to get APACHE_VERSION
need_apache2

APXS2_ARGS="-c ${PN}.c gl_auth.c gl_server.c"
APACHE2_MOD_CONF="99_${PN}"
APACHE2_MOD_DEFINE="GATORLINK"

DOCFILES="README CHANGES"
