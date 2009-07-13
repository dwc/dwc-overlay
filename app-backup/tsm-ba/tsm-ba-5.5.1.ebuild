# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils rpm

TSM_BASE_URI="ftp://ftp.software.ibm.com/storage/tivoli-storage-management/maintenance/client/v5r5/Linux/LinuxX86/v551"

DESCRIPTION="Tivoli Storage Manager (TSM) backup/archive client"
HOMEPAGE="http://www.tivoli.com/"
SRC_URI="${TSM_BASE_URI}/5.5.1.0-TIV-TSMBAC-LinuxX86.tar
	linguas_cs? ( ${TSM_BASE_URI}/TIVsm-msg.cs_CZ.i386.rpm )
	linguas_de? ( ${TSM_BASE_URI}/TIVsm-msg.de_DE.i386.rpm )
	linguas_es? ( ${TSM_BASE_URI}/TIVsm-msg.es_ES.i386.rpm )
	linguas_fe? ( ${TSM_BASE_URI}/TIVsm-msg.fr_FR.i386.rpm )
	linguas_it? ( ${TSM_BASE_URI}/TIVsm-msg.it_IT.i386.rpm )
	linguas_ja? ( ${TSM_BASE_URI}/TIVsm-msg.ja_JP.i386.rpm )
	linguas_ko? ( ${TSM_BASE_URI}/TIVsm-msg.ko_KR.i386.rpm )
	linguas_pl? ( ${TSM_BASE_URI}/TIVsm-msg.pl_PL.i386.rpm )
	linguas_pt_BR? ( ${TSM_BASE_URI}/TIVsm-msg.pt_BR.i386.rpm )
	linguas_ru? ( ${TSM_BASE_URI}/TIVsm-msg.ru_RU.i386.rpm )
	linguas_zh_CN? ( ${TSM_BASE_URI}/TIVsm-msg.zh_CN.i386.rpm )
	linguas_zh_TW? ( ${TSM_BASE_URI}/TIVsm-msg.zh_TW.i386.rpm )"
LICENSE="as-is"

SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="strip"  # Breaks libPiIMG.ss and libPiSNAP.so

IUSE="linguas_cs linguas_de linguas_es linguas_fr linguas_it linguas_ja linguas_ko linguas_pl linguas_pt_BR linguas_ru linguas_zh_CN linguas_zh_TW"
RDEPEND="~virtual/libstdc++-3.3
	amd64? ( app-emulation/emul-linux-x86-compat )"

S="${WORKDIR}"

TSM_DIR="/opt/tivoli"
TSM_CLIENT_DIR="${TSM_DIR}/tsm/client"
TSM_BA_DIR="${TSM_CLIENT_DIR}/ba"
TSM_BA_BIN_DIR="${TSM_BA_DIR}/bin"
TSM_ADMIN_DIR="${TSM_CLIENT_DIR}/admin"
TSM_ADMIN_BIN_DIR="${TSM_ADMIN_DIR}/bin"
TSM_API_DIR="${TSM_CLIENT_DIR}/api"
TSM_API_BIN_DIR="${TSM_API_DIR}/bin"
TSM_CONFIG_DIR="/etc/tivoli"
TSM_LOG_DIR="/var/log"

pkg_setup() {
	strip-linguas "cs de es fr it ja ko pl pt_BR ru zh_CN zh_TW"
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	local files="TIVsm-BA.i386.rpm TIVsm-API.i386.rpm"
	if use amd64; then
		files="${files} TIVsm-API64.i386.rpm"
	fi

	local file
	for file in ${files}; do
		einfo "Unpacking ${file}..."
		rpm_unpack "${file}" || die "Error unpacking ${file}"
	done
}

src_install() {
	cp -a "${S}/opt" "${D}/"

	# Allow all users to access TSM tools
	chmod -R go+rX "${D}/${TSM_DIR}"

	dodir "${TSM_CONFIG_DIR}"
	keepdir "${TSM_CONFIG_DIR}"

	insinto "${TSM_CONFIG_DIR}"
	doins "${FILESDIR}/dsm.inclexcl"

	local tsm_sys_file="${TSM_CONFIG_DIR}/dsm.sys"
	cp -a "${S}"/"${TSM_BA_BIN_DIR}"/dsm.sys.smp "${D}/${tsm_sys_file}"
	echo "   PasswordDir ${TSM_CONFIG_DIR}" >> "${D}/${tsm_sys_file}"
	echo "   PasswordAccess generate" >> "${D}/${tsm_sys_file}"
	echo "   NodeName $(hostname -f)" >> "${D}/${tsm_sys_file}"
	echo "   ErrorLogName ${TSM_LOG_DIR}/dsmerror.log" >> "${D}/${tsm_sys_file}"
	echo "   ErrorLogRetention 7" >> "${D}/${tsm_sys_file}"
	echo "   SchedLogName ${TSM_LOG_DIR}/dsmsched.log" >> "${D}/${tsm_sys_file}"
	echo "   SchedLogRetention 5" >> "${D}/${tsm_sys_file}"
	echo "   ManagedServices schedule" >> "${D}/${tsm_sys_file}"
	echo "   InclExcl ${TSM_CONFIG_DIR}/dsm.inclexcl" >> "${D}/${tsm_sys_file}"
	dosym "${tsm_sys_file}" "${TSM_BA_BIN_DIR}"/dsm.sys

	dosym "${TSM_CLIENT_DIR}"/lang/en_US "${TSM_BA_BIN_DIR}"/en_US

	local tsm_opt_file="${TSM_CONFIG_DIR}/dsm.opt"
	cp -a "${S}"/"${TSM_BA_BIN_DIR}"/dsm.opt.smp "${D}/${tsm_opt_file}"
	dosym "${tsm_opt_file}" "${TSM_BA_BIN_DIR}"/dsm.opt

	newconfd "${FILESDIR}"/dsmc.confd dsmc
	newinitd "${FILESDIR}"/dsmc.initd dsmc
	newinitd "${FILESDIR}"/dsmcad.initd dsmcad

	einfo "Creating env.d file..."
	dodir /etc/env.d
	local tsm_env_file="${D}/etc/env.d/92${PN}"
	echo DSM_CONFIG="${tsm_opt_file}" > "${tsm_env_file}"
	echo DSM_DIR="${TSM_BA_BIN_DIR}" >> "${tsm_env_file}"
	echo DSM_LOG="${TSM_LOG_DIR}" >> "${tsm_env_file}"
	echo PATH="${TSM_ADMIN_BIN_DIR}:${TSM_BA_BIN_DIR}" >> "${tsm_env_file}"
	echo ROOTPATH="${TSM_ADMIN_BIN_DIR}:${TSM_BA_BIN_DIR}" >> "${tsm_env_file}"
	echo LDPATH="${TSM_API_BIN_DIR}" >> "${tsm_env_file}"

	einfo "Creating revdep-rebuild file..."
	dodir /etc/revdep-rebuild
	echo "SEARCH_DIRS_MASK=\"${TSM_DIR}\"" > "${D}/etc/revdep-rebuild/92${PN}"

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/dsmc.logrotate dsmc
}

pkg_postinst() {
	einfo
	einfo "An initial configuration file has been installed in:"
	einfo "  ${TSM_CONFIG_DIR}"
	einfo "You must update the configuration before you can use TSM."
	einfo
	einfo "Additionally, a default include-exclude file has been installed."
	einfo "You may want to update this file depending on your system."
	einfo "For more information see:"
	einfo "  http://publib.boulder.ibm.com/infocenter/tivihelp/v1r1/index.jsp?topic=/com.ibm.itsmfdt.doc/ans5000076.htm"
	einfo
}
