# Noctalia Greeter (OpenRC on Gentoo)

[noctalia-greeter](/qwerhyy-overlay) is a greetd login greeter (Wayland +
wlroots, no Qt/GTK). These notes cover wiring it up under OpenRC + elogind.

The ebuild already handles package-side install (binaries, assets, and the
state dir `/var/lib/noctalia-greeter` owned by the `greetd` session user via
`pkg_postinst`).

## What remains after emerge

Only the greeter/init configuration (done once, by hand).

### 1. Pick greetd as the display manager

`/etc/conf.d/display-manager`:

```
DISPLAYMANAGER="greetd"
```

`/etc/init.d/display-manager` already has a `greetd` branch (runs
`/usr/bin/greetd` in the background).

### 2. Point greetd at the noctalia session wrapper

`/etc/greetd/config.toml` — greetd must run the **session wrapper**, not the
greeter binary directly:

```toml
[terminal]
vt = 7

[default_session]
command = "/usr/bin/noctalia-greeter-session"
user = "greetd"
```

- `user = "greetd"` is the accounting user provided by
  `gui-libs/greetd` (`acct-user/greetd`); it is already in the `video` group,
  so no extra `greeter` account is needed.
- The state dir owned by that user is created by the ebuild, so greeter
  tooling resolves the right owner without reading greetd config.
- Optional pinned session: `command = "/usr/bin/noctalia-greeter-session -- --session niri"`.
- What sessions are offered comes from the system `wayland-sessions`
  `.desktop` files; `noctalia-greeter sessions` lists them.

### 3. Restart

```sh
rc-service display-manager restart
```

This kills the currently running DM session first — save your work.

## User avatars

The greeter reads avatars from D-Bus `org.freedesktop.Accounts` (AccountService)
— it has **no** `~/.face` fallback of its own. So profile pictures need
`sys-apps/accountsservice`.

- Package: `sys-apps/accountsservice`.
- Requires the system D-Bus to be running (the daemon is D-Bus auto-activated).
- Give each user an avatar file either at
  `/var/lib/AccountsService/icons/<username>` or in the home dir as `~/.face`,
  then trigger a refresh (e.g. alter the user via an account manager or
  restart the accountsservice / D-Bus session).

## PAM

No `setup_greetd_pam.sh` patch is needed on Gentoo. The package-installed
`/etc/pam.d/greetd` is `session include login`, which reaches
`/etc/pam.d/system-login` and already runs
`-session optional pam_elogind.so`, giving the greeter user an
`XDG_RUNTIME_DIR`. Do not hand-edit another package's PAM file.