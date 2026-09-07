# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="1.0.1"

inherit xdg

SRC_URI="https://github.com/rockorager/monstar/archive/v${MY_PV}.tar.gz"
S="${WORKDIR}/monstar-${MY_PV}"

DESCRIPTION="A fast CPU-rendered Wayland terminal emulator built on libghostty (like foot)"
HOMEPAGE="https://github.com/rockorager/monstar"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# dbus compiles in a native D-Bus client for notifications, xdg-desktop-portal
# link/file opening, desktop appearance tracking, and systemd-scope cgroup
# isolation. D-Bus itself is never a build/library dependency (the wire
# protocol is spoken directly); disabling it only drops those integrations.
IUSE="dbus"

# Runtime libraries monstar links against (zig linkSystemLibrary).
RDEPEND="
	dev-libs/wayland
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz
	x11-libs/libxkbcommon
"

DEPEND="
	${RDEPEND}
	dev-libs/wayland-protocols
"

# tic (ncurses) is needed at build time to compile dist/monstar.terminfo.
BDEPEND="
	dev-lang/zig-bin:0.16
	dev-libs/wayland
	dev-util/wayland-scanner
	sys-libs/ncurses
	dev-vcs/git
"

# src_compile fetches the zig build dependencies (ghostty, zig-wayland, z2d and
# iterm2 themes) over the network, so connectivity is required to build. The
# dependency commits are pinned in build.zig.zon, so builds are reproducible.
src_compile() {
	zig build \
		-Doptimize=ReleaseFast \
		-Dstrip \
		$(usex dbus "-Ddbus=true" "-Ddbus=false")
}

src_install() {
	DESTDIR="${D}" zig build --prefix /usr install || die "zig install failed"
}

pkg_postinst() {
	xdg_pkg_postinst
	elog "monstar launches with TERM=monstar. On remote hosts lacking the"
	elog "definition, send it with:"
	elog
	elog "  infocmp -x monstar | ssh HOST tic -x -"
	elog
	elog "Configuration lives in ~/.config/monstar/config."
}