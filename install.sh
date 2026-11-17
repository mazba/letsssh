#!/usr/bin/env bash
# Installs letsssh to ~/bin (or $LETSSSH_INSTALL_DIR) and adds it to your PATH.
# Works from a cloned repo or via: curl -fsSL <raw install.sh URL> | bash
set -euo pipefail

REPO="mazba/letsssh"
BRANCH="main"
DEST_DIR="${LETSSSH_INSTALL_DIR:-$HOME/bin}"
DEST="$DEST_DIR/letsssh"

[ "$(uname)" = "Darwin" ] || { echo "letsssh is made for macOS."; exit 1; }

mkdir -p "$DEST_DIR"

SRC_DIR=""
if [ -n "${BASH_SOURCE[0]:-}" ] && [ -f "${BASH_SOURCE[0]}" ]; then
  SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

if [ -n "$SRC_DIR" ] && [ -f "$SRC_DIR/letsssh" ]; then
  cp "$SRC_DIR/letsssh" "$DEST"
else
  curl -fsSL "https://raw.githubusercontent.com/$REPO/$BRANCH/letsssh" -o "$DEST"
fi

chmod +x "$DEST"

case ":$PATH:" in
  *":$DEST_DIR:"*) ;;
  *)
    LINE="export PATH=\"$DEST_DIR:\$PATH\""
    touch "$HOME/.zshrc"
    grep -qxF "$LINE" "$HOME/.zshrc" || echo "$LINE" >> "$HOME/.zshrc"
    echo "Added $DEST_DIR to your PATH in ~/.zshrc. Open a new terminal, or run: source ~/.zshrc"
    ;;
esac

echo "✓ Installed letsssh to $DEST"
echo "Get started: letsssh help"
