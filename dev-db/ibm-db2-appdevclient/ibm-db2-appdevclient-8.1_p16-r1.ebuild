# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils rpm

DESCRIPTION="IBM DB2 application development client"
HOMEPAGE="http://www.ibm.com/software/data/db2/"
SRC_URI="amd64? ( ftp://ftp.software.ibm.com/ps/products/db2/fixes2/english-us/db2linux26AMD64/client/appdev/FP16_MI00211_ADCL.tar )
	x86? ( ftp://ftp.software.ibm.com/ps/products/db2/fixes2/english-us/db2linux2632/client/appdev/FP16_MI00207_ADCL.tar )"
LICENSE="IBM-ILNWP"

SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="strip"

IUSE=""
DEPEND="sys-apps/sed"
RDEPEND=">=sys-kernel/linux-headers-2.6
	~virtual/libstdc++-3.3
	amd64? ( app-emulation/emul-linux-x86-compat )"

S="${WORKDIR}/adcl/db2/linux26/"

DB2_DIR="opt/IBM/db2/V8.1"
DB2_FENCE_USER="db2fenc1"
DB2_FENCE_GROUP="db2fadm1"
DB2_FENCE_DIR="/home/${DB2_FENCE_USER}"
DB2_INSTANCE_USER="db2inst1"
DB2_INSTANCE_GROUP="db2iadm1"
DB2_INSTANCE_DIR="/home/${DB2_INSTANCE_USER}"
DB2_SQL_DIR="${DB2_INSTANCE_DIR}/sqllib"
DB2_LIB_DIR="${DB2_SQL_DIR}/lib"

src_unpack() {
	unpack ${A}
	cd "${S}"

	rpm_unpack ./*.rpm
}

src_prepare() {
	cd "${S}/${DB2_DIR}/instance"

	for file in db2idbm db2imigr db2istop db2iutil; do
		if [ -f "${file}" ]; then
			einfo "Fixing tail usage in ${file}..."
			sed -i -e 's#tail #tail \-n#g' $file
		fi
	done
}

src_install() {
	# To reduce the installation time, use mv instead of cp
	mv "${S}/opt" "${D}/" || die "Error installing"
	chmod -R go+rX "${D}/${DB2_DIR}"

	einfo "Creating env.d file..."
	dodir /etc/env.d
	echo "DB2_HOME=\"${DB2_SQL_DIR}\"" > "${D}/etc/env.d/91${PN}"
	echo "LDPATH=\"${DB2_LIB_DIR}\"" >> "${D}/etc/env.d/91${PN}"

	einfo "Creating revdep-rebuild file..."
	dodir /etc/revdep-rebuild
	echo "SEARCH_DIRS_MASK=\"${DB2_LIB_DIR}\"" > "${D}/etc/revdep-rebuild/91${PN}"

	keepdir /var/db2
}

pkg_postinst() {
	einfo
	einfo "To create an initial DB2 instance, including users and groups, execute:"
	einfo "emerge --config =${PF}"
	einfo
}

pkg_config() {
	if [ ! -d "${ROOT}/${DB2_INSTANCE_DIR}" ]; then
		local args
		if use amd64; then
			# Use a 64-bit instance for amd64
			args="-w 64"
		fi

		einfo "Adding groups..."
		enewgroup "${DB2_INSTANCE_GROUP}" || die "Error adding ${DB2_INSTANCE_GROUP} group"
		enewgroup "${DB2_FENCE_GROUP}" || die "Error adding ${DB2_FENCE_GROUP} group"

		einfo "Adding users..."
		enewuser "${DB2_INSTANCE_USER}" -1 /bin/bash "${DB2_INSTANCE_DIR}" "${DB2_INSTANCE_GROUP}" \
			|| die "Error adding ${DB2_INSTANCE_USER} user"
		enewuser "${DB2_FENCE_USER}" -1 /bin/bash "${DB2_FENCE_DIR}" "${DB2_FENCE_GROUP}" \
			|| die "Error adding ${DB2_FENCE_USER} user"

		einfo "Creating instance (ignore any warnings about adding to the profile)..."

		"${ROOT}/${DB2_DIR}/instance/db2icrt" ${args} -a server -u "${DB2_FENCE_USER}" "${DB2_INSTANCE_USER}"

		einfo "DB2 instance created."
	else
		einfo "It appears as though you already have a DB2 instance at:"
		einfo "${ROOT}/${DB2_INSTANCE_DIR}"
		einfo "I won't try to overwrite it."
	fi
}

pkg_prerm() {
	local file

	for file in libcteerrna.so.1 libdb2ar.so.1 libdb2dcna.so.1 libdb2isys.so.1 libdb2qgjavaF.so.1 libdb2qgjavaU.so.1 libdb2sqqgtop.so.1 libdb2ssmonapis.so.1; do
		rm -f "${ROOT}/${DB2_DIR}/lib/${file}"
	done

	for file in libdb2o.so.1; do
		rm -f "${ROOT}/${DB2_DIR}/lib64/${file}"
	done
}

pkg_postrm() {
	einfo
	einfo "To remove all traces of DB2 from your system:"
	einfo "rm -r \"${ROOT}/var/db2\""
	einfo "userdel -r ${DB2_INSTANCE_USER}"
	einfo "userdel -r ${DB2_FENCE_USER}"
	einfo "groupdel ${DB2_INSTANCE_GROUP}"
	einfo "groupdel ${DB2_FENCE_GROUP}"
	einfo
}
