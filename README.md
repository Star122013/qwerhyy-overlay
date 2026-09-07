# qwerhyy-overlay

Personal Gentoo overlay for software not in ::gentoo.

## Contents

- `gui-apps/noctalia` — the Noctalia Wayland desktop shell
- `gui-apps/monstar` — the Monstar Wayland terminal (9999 live / 1.0.1 pinned)
- `gui-apps/zmx` — the zmx terminal session attach/detach tool (9999 / 0.8.1)

Each `*-9999` package also carries a pinned release ebuild in the same
directory, switched by the atom. Plain `emerge gui-apps/monstar` picks the live
`9999`; use `'=gui-apps/monstar-1.0.1'` (or `'=gui-apps/zmx-0.8.1'`) for the
pinned release.

## Layout

```
metadata/layout.conf   # repo config (masters=gentoo, thin-manifests)
profiles/repo_name     # "qwerhyy-overlay"
profiles/categories    # category whitelist
gui-apps/noctalia      # package ebuilds: <category>/<package>/
```

## Register with portage

Install `app-eselect/eselect-repository`, then add this overlay and sync:

```sh
sudo eselect repository add qwerhyy-overlay git https://github.com/Star122013/qwerhyy-overlay.git
sudo emaint sync -r qwerhyy-overlay
```

For a local (unpublished) checkout you can instead drop a config file at
`/etc/portage/repos.conf/qwerhyy-overlay.conf`:

```ini
[qwerhyy-overlay]
location = /path/to/qwerhyy-overlay
masters = gentoo
auto-sync = no
priority = 50
```

## Adding a package

1. Make sure the category exists in `profiles/categories` (e.g. `gui-apps`).
2. Create `<category>/<package>/` and put the ebuild inside, e.g.
   `gui-apps/noctalia/noctalia-5.0.0_beta9.ebuild`.
3. Run `ebuild gui-apps/noctalia/noctalia-5.0.0_beta9.ebuild manifest` to
   generate the Manifest.

See also: [Gentoo Devmanual – Ebuild Writing](https://devmanual.gentoo.org/ebuild-writing/).