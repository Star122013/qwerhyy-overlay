# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="0.8.1"

inherit xdg

SRC_URI="https://github.com/neurosnap/zmx/archive/v${MY_PV}.tar.gz"
S="${WORKDIR}/zmx-${MY_PV}"

DESCRIPTION="Session attach/detach for the terminal (a modern tmux alternative)"
HOMEPAGE="https://github.com/neurosnap/zmx https://zmx.sh"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# zmx compiles in libghostty-vt (a Zig dependency fetched at build time) and
# links only libc, so there are no system runtime libraries to depend on.
RDEPEND=""

BDEPEND="
	dev-lang/zig-bin:0.16
	dev-vcs/git
"

# src_compile fetches the zig build dependency (ghostty, providing libghostty-vt)
# over the network, so connectivity is required to build. The dependency commit
# is pinned in build.zig.zon, so builds are reproducible.
src_compile() {
	zig build -Doptimize=ReleaseSafe
}

src_install() {
	DESTDIR="${D}" zig build -Doptimize=ReleaseSafe --prefix /usr install || die "zig install failed"
}

pkg_postinst() {
	xdg_pkg_postinst
	elog "zmx keeps no persistent configuration; sessions live under"
	elog "\\${ZMX_DIR:-\\${XDG_RUNTIME_DIR:-/tmp}/zmx}. Shell completions are"
	elog "generated at runtime with:"
	elog
	elog "  zmx completions bash  (or zsh / fish / nu)"
	elog
	elog "See https://zmx.sh for the full usage guide."
}