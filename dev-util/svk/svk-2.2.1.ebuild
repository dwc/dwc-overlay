# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2

inherit eutils perl-module bash-completion

MY_PV="v${PV}"
MY_P="${PN/svk/SVK}-${MY_PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="A decentralized version control system"
SRC_URI="mirror://cpan/authors/id/C/CL/CLKAO/${MY_P}.tar.gz"
HOMEPAGE="http://svk.bestpractical.com/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE="nls pager patch log4p crypt test bash-completion"
RESTRICT="mirror"

RDEPEND=">=dev-lang/perl-5.8.7
	>=dev-util/subversion-1.3.0[perl]
	>=virtual/perl-version-0.68
	dev-perl/Algorithm-Annotate
	>=dev-perl/Algorithm-Diff-1.1901
	>=dev-perl/YAML-Syck-0.60
	>=dev-perl/Data-Hierarchy-0.30
	>=dev-perl/PerlIO-via-dynamic-0.11
	>=dev-perl/PerlIO-via-symlink-0.02
	dev-perl/IO-Digest
	>=dev-perl/SVN-Simple-0.27
	dev-perl/URI
	>=dev-perl/PerlIO-eol-0.13
	>=dev-perl/Class-Autouse-1.15
	dev-perl/App-CLI
	dev-perl/List-MoreUtils
	dev-perl/Class-Accessor
	dev-perl/Class-Data-Inheritable
	>=dev-perl/Path-Class-0.16
	dev-perl/UNIVERSAL-require
	dev-perl/TermReadKey
	virtual/perl-Time-HiRes
	>=virtual/perl-File-Temp-0.17
	>=virtual/perl-Getopt-Long-2.35
	virtual/perl-Pod-Escapes
	virtual/perl-Pod-Simple
	>=virtual/perl-File-Spec-3.19
	dev-perl/Time-Progress
	dev-perl/TimeDate
	>=dev-perl/SVN-Mirror-0.71
	nls? (
		>=dev-perl/locale-maketext-lexicon-0.62
		>=virtual/perl-Locale-Maketext-Simple-0.16
	)
	pager? ( dev-perl/IO-Pager )
	log4p? ( dev-perl/Log-Log4Perl )
	patch? (
		virtual/perl-Compress-Zlib
		dev-perl/FreezeThaw
	)
	crypt? ( app-crypt/gnupg )"
DEPEND="${RDEPEND}
	test? ( >=virtual/perl-Test-Simple-0.42 )"

src_install() {
	perl-module_src_install

	if use bash-completion; then
		dobin contrib/svk-completion.pl
		echo "complete -C ${DESTTREE}/bin/svk-completion.pl -o default svk" \
			> svk-completion
		dobashcompletion svk-completion
	fi
}
