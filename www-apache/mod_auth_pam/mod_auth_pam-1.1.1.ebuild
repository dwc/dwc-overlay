# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit apache-module eutils

MY_PN="libapache2-${PN//_/-}"
MY_P="${MY_PN}-${PV}"
S="${WORKDIR}/${PN}"

DESCRIPTION="Apache module for authenticating against the Pluggable Authentication Module (PAM)"
HOMEPAGE="http://packages.debian.org/source/${MY_PN}"

DEBIAN_PV="8"
MY_P="${MY_PN}_${PV}"
DEBIAN_URI="mirror://debian/pool/main/${MY_PN:0:4}/${MY_PN}"
DEBIAN_PATCH="${MY_P}-${DEBIAN_PV}.diff.gz"
DEBIAN_SRC="${MY_P}.orig.tar.gz"
SRC_URI="${DEBIAN_URI}/${DEBIAN_SRC} ${DEBIAN_URI}/${DEBIAN_PATCH}"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/pam"
RDEPEND="${DEPEND}"

APXS2_ARGS="-lpam -c ${PN}.c"
APACHE2_MOD_CONF="10_${PN}"
APACHE2_MOD_DEFINE="AUTH_PAM"
APACHE2_EXECFILES="${S}/.libs/mod_auth_sys_group.so"

DOCFILES="README INSTALL doc/*.html"

need_apache2_2

src_unpack() {
	unpack "${DEBIAN_SRC}"
}

src_prepare() {
	local patch

	EPATCH_OPTS="-p1" epatch "${DISTDIR}"/"${DEBIAN_PATCH}"

	for patch in "${S}"/debian/patches/*.diff; do
		epatch "${patch}"
	done
}

src_compile() {
	apache-module_src_compile

	${APXS} -lpam -c mod_auth_sys_group.c
}

src_install() {
	apache-module_src_install
}
