# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="A minimal login greeter for greetd that matches the look and feel of Noctalia Shell"
HOMEPAGE="https://github.com/noctalia-dev/noctalia-greeter"

# Upstream release tag (v1.2.1)
MY_PV="1.2.1"
SRC_URI="https://github.com/noctalia-dev/noctalia-greeter/archive/v${MY_PV}.tar.gz"
S="${WORKDIR}/noctalia-greeter-${MY_PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# Upstream's `release` buildtype adds -march/-mtune=native (not portable).
MESON_BUILDTYPE="plain"

DEPEND="
	dev-cpp/nlohmann_json
	dev-cpp/tomlplusplus
	dev-libs/glib:2
	dev-libs/libinput
	dev-libs/stb
	dev-libs/wayland
	gui-libs/wlroots:0.20
	gnome-base/librsvg:2
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libepoxy
	media-libs/libwebp
	media-libs/mesa
	x11-libs/cairo[glib]
	x11-libs/libxkbcommon
	x11-libs/pango
"

RDEPEND="
	${DEPEND}
	app-display/greetd
	sys-apps/dbus
	sys-libs/pam
"

BDEPEND="
	dev-libs/wayland-protocols
	dev-util/wayland-scanner
	virtual/pkgconfig
"
