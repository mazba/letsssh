# Changelog

## 1.0.0 (2026-11-17)

First release.

- `letsssh add`: add a server, with or without a `.pem` key. Keys are moved to `~/.ssh`, set to permission 600, given a passphrase if missing (with up to 3 tries) and saved in the macOS Keychain.
- `letsssh list`, `info`, `edit`, `remove`, `test`, `version`, `help`.
- `letsssh <name>` to connect, or `letsssh` alone to pick from a list (uses fzf if installed).
- Servers are stored in `~/.ssh/config.d/letsssh.conf` and included from `~/.ssh/config`, so `ssh`, `scp`, `rsync` and VS Code see them too.
- Backups before every change; removed keys go to the Trash.
- `install.sh` for installing from a clone or with `curl | bash`.
