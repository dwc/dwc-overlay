# Copyright Daniel Westermann-Clark <daniel at acceleration dot net>
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit eutils rpm

TSM_BASE_URI="ftp://ftp.software.ibm.com/storage/tivoli-storage-management/maintenance/client/v5r5/Linux/LinuxX86/v551"

DESCRIPTION="Tivoli Storage Manager (TSM) backup/archive client"
HOMEPAGE="http://www.tivoli.com/"
SRC_URI="${TSM_BASE_URI}/5.5.1.0-TIV-TSMBAC-LinuxX86.tar"
LICENSE="as-is"

SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="nomirror nostrip" # Breaks libPiIMG.ss and libPiSNAP.so

IUSE=""
RDEPEND="~virtual/libstdc++-3.3
	amd64? ( app-emulation/emul-linux-x86-compat )"

S="${WORKDIR}"

LANGS="cs_CZ de_DE es_ES fr_FR it_IT ja_JP ko_KR pl_PL pt_BR ru_RU zh_CN zh_TW"
for x in ${LANGS}; do
	IUSE="${IUSE} linguas_${x}"
	SRC_URI="${SRC_URI} linguas_${x}? ( ${TSM_BASE_URI}/TIVsm-msg.${x}.i386.rpm )"
done

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
	strip-linguas ${LANGS}
}

src_unpack() {
	unpack "${A}"
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
