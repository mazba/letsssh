# letsssh

A small command-line tool for macOS that keeps your SSH servers and keys in one place.

Drop in a `.pem` file from AWS (or anywhere else) and letsssh secures it, saves the server, and lets you connect with one short command.

```bash
letsssh add ~/Downloads/my-server-key.pem
letsssh my-server
```

New here? Follow the [getting started guide](docs/getting-started.md).

## Features

- **Secures `.pem` keys**: moves them into `~/.ssh`, fixes permissions, adds a passphrase if missing, and saves the passphrase in the macOS Keychain.
- **Servers with or without a key**: add servers that use a `.pem`, your default SSH keys, or a password.
- **List, connect, edit, remove, test**: everything from one command.
- **Works with your other tools**: servers are written to a standard SSH config file, so Terminal, VS Code Remote-SSH, `scp`, `rsync` and other apps see them too.
- **Safe by default**: never edits your own SSH config entries, backs up before every change, and moves removed keys to the Trash rather than deleting them.
- **No dependencies**: a single Bash script using tools that ship with macOS. [`fzf`](https://github.com/junegunn/fzf) is optional for a searchable picker.

## Requirements

- macOS 12 (Monterey) or later
- The built-in OpenSSH client

## Install

**With the installer:**

```bash
curl -fsSL https://raw.githubusercontent.com/mazba/letsssh/main/install.sh | bash
```

**Or from a clone:**

```bash
git clone https://github.com/mazba/letsssh.git
cd letsssh
./install.sh
```

The installer copies `letsssh` to `~/bin` and adds that folder to your `PATH` in `~/.zshrc`. To install somewhere else, set `LETSSSH_INSTALL_DIR` before running it.

## Usage

| Command | What it does |
| --- | --- |
| `letsssh add key.pem` | Secure the key and add a server for it |
| `letsssh add` | Add a server without a key (default keys or password) |
| `letsssh list` | List servers, plus keys not linked to any server |
| `letsssh <name>` | Connect to a server |
| `letsssh` | Pick a server from a list and connect |
| `letsssh edit <name>` | Change the name, host, user, port or key |
| `letsssh remove <name>` | Remove a server, optionally moving its key to the Trash |
| `letsssh test <name>` | Check that key login works |
| `letsssh info <name>` | Show details |
| `letsssh version` | Show version |

### Adding a server

With a key, letsssh asks for the server name (defaulting to the file name), host and user:

```bash
letsssh add ~/Downloads/web-server-key.pem
```

Skip the questions by passing options:

```bash
letsssh add ~/Downloads/web-server-key.pem --name web --host example.com --user ec2-user
letsssh add --name pi --host 192.168.1.20 --user pi --port 2222
```

If the key has no passphrase yet, letsssh asks you to set one. It must be at least 5 characters. It is saved in the macOS Keychain, so you won't have to type it again in Terminal.

### Editing a server

Run `letsssh edit web` to be asked for each value (press Enter to keep the current one), or change values directly:

```bash
letsssh edit web --host new.example.com
letsssh edit web --key ~/Downloads/new-key.pem
letsssh edit web --key none        # stop using a key file
```

### Using servers in other apps

Because servers live in your SSH config, any tool that reads it works with the same short name:

```bash
scp backup.sql web:/tmp/
rsync -av ./site/ web:/var/www/
```

In GUI apps (database clients, SFTP apps), point the SSH key setting to the file in `~/.ssh/` and enter the passphrase when asked.

## How it works

- Servers are stored in `~/.ssh/config.d/letsssh.conf`.
- One line, `Include ~/.ssh/config.d/letsssh.conf`, is added to the top of `~/.ssh/config`. A backup of `~/.ssh/config` is saved first.
- Before each change, letsssh saves a backup of its file in `~/.ssh/config.d/backups/` and keeps the 10 most recent.
- Keys are re-encrypted in classic PEM format, which the widest range of SSH apps can read.
- Passphrases are stored only in the macOS Keychain, never by letsssh itself.
- Removing a key moves it to the Trash (or `~/.ssh/removed/` if macOS blocks access to the Trash) and removes it from the Keychain. A key still used by another server is never removed.

## Uninstall

```bash
rm ~/bin/letsssh
```

Your servers stay in `~/.ssh/config.d/letsssh.conf`. To remove them as well, delete that file and the `Include ~/.ssh/config.d/letsssh.conf` line from `~/.ssh/config`. Your keys in `~/.ssh` are not touched.

## Docs

- [Getting started](docs/getting-started.md): first setup, step by step
- [Troubleshooting](docs/troubleshooting.md): common errors and fixes
- [Changelog](CHANGELOG.md)

## License

[MIT](LICENSE)
