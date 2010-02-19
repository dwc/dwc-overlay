# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

MODULE_AUTHOR=IBMTORDB2
inherit perl-module

DESCRIPTION="DB2 Driver for DBI"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~x86"
SRC_TEST="do"

IUSE=""
RDEPEND="dev-perl/DBI
	dev-db/ibm-db2-appdevclient"
DEPEND="${RDEPEND}"

pkg_setup() {
	perl-module_pkg_setup

	if [[ -z "${DB2_HOME}" || ! -d "${DB2_HOME}" ]]; then
		eerror "The DB2_HOME environment variable does not appear to be"
		eerror "set to an existing directory.  Please check that the DB2"
		eerror "application development client is installed and configured"
		eerror "(i.e., that you have at least one DB2 instance) and then"
		eerror "set DB2_HOME."
		die "Need DB2_HOME variable"
	fi
}
