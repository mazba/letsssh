# Troubleshooting

## `Permission denied (publickey)`

The server rejected the login. In order of likelihood:

1. **Wrong user name.** AWS servers use a user based on the operating system: `ec2-user` for Amazon Linux/RHEL, `ubuntu` for Ubuntu, `admin` for Debian. Fix it with:
   ```bash
   letsssh edit my-server --user ec2-user
   ```
2. **Wrong key.** Run `letsssh info my-server` and check that the key is the one AWS gave you for this instance (see **Key pair** on the instance page).
3. **Wrong host.** Check that the IP is the instance's current public IP. It changes when an instance is stopped and started, unless it has an Elastic IP.

For details, run `ssh -v my-server` and look for the lines starting with `Offering public key` and `Authentications that can continue`.

## Warning about post-quantum key exchange

OpenSSH 10.1 and later print a warning when the **server** doesn't support a post-quantum key exchange. Your connection still works and is still encrypted. It goes away once the server's OpenSSH is updated (OpenSSH 9.0 or later). letsssh doesn't cause it and can't fix it on your side.

## An app can't open my key (e.g. MySQL Workbench)

macOS stops apps from reading files in Documents, Desktop and Downloads unless you allow it. Keep keys in `~/.ssh`, which `letsssh add` does for you. Run `letsssh info my-server` to see the key's path.

In a file picker, press **⌘ Shift .** to show the hidden `.ssh` folder.

## `passphrase is too short`

Passphrases must be at least 5 characters. letsssh gives you three tries. If all three fail, the key has already been moved to `~/.ssh`, so run the same command again with the new path:

```bash
letsssh add ~/.ssh/my-server-key.pem
```

## `letsssh: command not found`

The installer added `~/bin` to your `PATH`, but only new Terminal windows see that. Open a new window, or run:

```bash
source ~/.zshrc
```

If that doesn't help, check that this line is in `~/.zshrc`:

```bash
export PATH="$HOME/bin:$PATH"
```

## Terminal keeps asking for the passphrase

The Keychain step may have been skipped. Run:

```bash
ssh-add --apple-use-keychain ~/.ssh/my-server-key.pem
```

## `letsssh test` fails but `letsssh my-server` works

`test` only checks key logins. If the server uses a password, the test can't check it; connecting normally is fine.

## Restoring an earlier config

Before every change, letsssh saves a copy of its servers file in `~/.ssh/config.d/backups/` (the 10 most recent). To go back:

```bash
ls -t ~/.ssh/config.d/backups/
cp ~/.ssh/config.d/backups/<file> ~/.ssh/config.d/letsssh.conf
```

The first time it runs, letsssh also saves a backup of `~/.ssh/config` before adding its `Include` line.

## A removed key

Removed keys go to the Trash, or to `~/.ssh/removed/` if macOS blocks the Trash. To use one again, move it back to `~/.ssh` and run `letsssh add` on it.
