# Publishing (maintainer notes)

How to put letsssh on GitHub as `mazba/letsssh` for the first time, and how to release later versions.

## First push

The local repository already has an initial commit on `main`.

Check that no keys are tracked:

```bash
git ls-files | grep -E '\.(pem|key)$|(^|/)id_' || echo "no keys tracked"
```

### With the GitHub CLI

```bash
gh auth login                                   # once; choose GitHub.com, HTTPS, browser
gh repo create mazba/letsssh --public --source . --push \
  --description "Manage SSH servers and .pem keys on macOS"
```

### Without the GitHub CLI

1. Create an empty public repository named `letsssh` at https://github.com/new. Don't add a README, license or .gitignore.
2. Push:
   ```bash
   git remote add origin https://github.com/mazba/letsssh.git
   git push -u origin main
   ```

## Check the installer URL

The README's one-line install fetches files from the `main` branch. After pushing, check that both URLs work:

```bash
curl -fsSL https://raw.githubusercontent.com/mazba/letsssh/main/install.sh | head -3
curl -fsSL https://raw.githubusercontent.com/mazba/letsssh/main/letsssh | head -3
```

Then follow [Getting started](getting-started.md) to install from GitHub.

## Releasing a new version

1. Update `VERSION=` near the top of `letsssh`.
2. Add an entry to `CHANGELOG.md`.
3. Commit, tag and push:
   ```bash
   git commit -am "Release 1.1.0"
   git tag v1.1.0
   git push && git push --tags
   ```
4. Optional: `gh release create v1.1.0 --notes-from-tag` or write notes from the changelog.

For the first release, tag the initial commit: `git tag v1.0.0 && git push --tags`.
