# Getting started

This guide takes you from nothing installed to logged in to your server. It takes about five minutes.

You need a Mac, the server's address (an IP or host name), and usually a `.pem` key file, for example the one AWS gave you when you created the server.

## 1. Install letsssh

Open Terminal and run:

```bash
curl -fsSL https://raw.githubusercontent.com/mazba/letsssh/main/install.sh | bash
```

Or, if you have cloned the repository:

```bash
cd letsssh
./install.sh
```

This puts `letsssh` in `~/bin` and adds that folder to your `PATH` in `~/.zshrc`.

**Open a new Terminal window**, then check that it works:

```bash
letsssh version
```

If you see `command not found`, see [Troubleshooting](troubleshooting.md#letsssh-command-not-found).

## 2. Add your server

Run `letsssh add` with your key file. It can be anywhere, such as Downloads or Documents:

```bash
letsssh add ~/Downloads/my-server-key.pem --user ec2-user
```

letsssh then:

1. **Moves the key to `~/.ssh`** and makes it readable only by you. Spaces in the file name become `_`. If the key is already in `~/.ssh`, it stays where it is.
2. **Asks for anything you didn't pass:**
   - **Name**: the short name you'll type to connect. Press Enter to accept the suggestion based on the file name.
   - **Host**: the server's IP or host name, such as `3.110.25.10` or `ec2-3-110-25-10.compute.amazonaws.com`. In AWS, it's the *Public IPv4 address* on the instance page.
   - **User**, if you didn't give it with `--user`.
   - The port isn't asked for; it's `22` unless you pass `--port 2222`.
3. **Asks you to set a passphrase** if the key doesn't have one. Type it twice; it must be at least 5 characters. If it's refused, you get two more tries.
4. **Saves the passphrase in your macOS Keychain**, so Terminal won't ask for it again.

### Which user name?

It depends on the operating system the server runs. For AWS:

| Server image | User |
| --- | --- |
| Amazon Linux, RHEL, CentOS, Fedora | `ec2-user` |
| Ubuntu | `ubuntu` |
| Debian | `admin` |

Using the wrong one is the most common cause of `Permission denied (publickey)`. If you're not sure, open the instance in the AWS console and click **Connect → SSH client**; the example command shows the right user.

You can change it later with `letsssh edit <name> --user ubuntu`.

### A server without a key file

If the server uses your normal SSH key or a password, leave out the file:

```bash
letsssh add --name pi --host 192.168.1.20 --user pi
```

## 3. Test the login

```bash
letsssh test my-server
```

You should see `✓ 'my-server' is reachable and login works.` If not, see [Troubleshooting](troubleshooting.md).

## 4. Connect

```bash
letsssh my-server
```

Or run `letsssh` on its own to pick from a list. For a searchable list, install [fzf](https://github.com/junegunn/fzf): `brew install fzf`.

The same short name works with other tools too: `ssh my-server`, `scp file.txt my-server:/tmp/`, and VS Code Remote-SSH.

## 5. Use the key in MySQL Workbench (or other apps)

Apps that don't read your SSH config need the key file and passphrase directly. In MySQL Workbench:

1. Create a connection with **Connection Method: Standard TCP/IP over SSH**.
2. **SSH Hostname**: your server's address, e.g. `3.110.25.10:22`.
3. **SSH Username**: the same user as above, e.g. `ec2-user`.
4. **SSH Key File**: the key in `~/.ssh`. Run `letsssh info my-server` to see the exact path. In the file picker, press **⌘ Shift .** to show hidden folders like `.ssh`.
5. Enter the passphrase when Workbench asks.
6. Set **MySQL Hostname** to `127.0.0.1` and fill in your database user.

## Everyday commands

```bash
letsssh list                 # all servers
letsssh info my-server       # details, including the key path
letsssh edit my-server       # change host, user, port, key or name
letsssh remove my-server     # remove it (asks before touching the key)
```

## Undo

To uninstall, see the [Uninstall section of the README](../README.md#uninstall). Your keys in `~/.ssh` are never deleted by uninstalling.
