# myoverlay

Personal Gentoo overlay for software not in ::gentoo.

## Layout

```
metadata/layout.conf   # repo config (masters=gentoo, thin-manifests)
profiles/repo_name     # "myoverlay"
profiles/categories    # category whitelist
eclass/                # custom eclasses
app-foo/               # placeholder category, rename/add as needed
```

## Register with portage

Create `/etc/portage/repos.conf/myoverlay.conf`:

```ini
[myoverlay]
location = /home/qwerhyy/Projects/myoverlay
masters = gentoo
auto-sync = false
priority = 50
```

Then `emaint sync -r myoverlay` (or just `emerge --sync`).

When adding a new ebuild in a category not yet listed, add the category to
`profiles/categories` first.
