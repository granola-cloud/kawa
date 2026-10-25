![logo](resource/png/logo.png)

# Kawa [![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](LICENSE)

A macOS input source switcher with user-defined shortcuts.

This is a fork of [hatashiro/kawa](https://github.com/hatashiro/kawa), created
by [Hyunje Jun (@hatashiro)](https://github.com/hatashiro). The original
project's last release was 1.1.0 in 2017, built for Intel only. This fork
rebuilds it to run natively on Apple Silicon and keeps it working on current
macOS.

Requires macOS 14 or later.

## Demo

[![demo](https://cloud.githubusercontent.com/assets/1013641/9109734/d73505e4-3c72-11e5-9c71-49cdf4a484da.gif)](http://vimeo.com/135542587)

The demo shows the original 1.x interface. The fork's preferences window looks
different but works the same way.

## What's different in this fork

- **Runs natively on Apple Silicon.** The original binary is Intel-only and
  needs Rosetta. This fork builds for arm64, with an optional universal build.
- **Builds with Swift Package Manager.** The Xcode project, storyboard and
  Carthage setup are replaced with a Swift package and a build script.
- **Uses [KeyboardShortcuts](https://github.com/sindresorhus/KeyboardShortcuts)**
  instead of the abandoned MASShortcut. Shortcuts saved by Kawa 1.x migrate
  automatically on first launch, so you don't have to set them up again.
- **Shows an on-screen indicator** (optional) with the input source name when
  you switch, instead of a system notification.
- **Adds a launch at login option.**
- **Fixes some bugs:**
  - Shortcuts now work as soon as Kawa launches, not only after the
    preferences window has been opened.
  - Input sources you add or remove while Kawa is running show up without a
    restart.
  - Input sources with missing properties no longer crash the app.

See [CHANGELOG.md](CHANGELOG.md) for details.

## Install

This fork has no prebuilt releases and isn't available through Homebrew, so
build it from source (see [Development](#development)). Then quit any running
Kawa and copy the app into place:

```bash
$ ditto build/Kawa.app /Applications/Kawa.app
$ open /Applications/Kawa.app
```

The build is ad-hoc signed, so it is meant for the machine it was built on.
To give it to other people, sign it with a Developer ID and notarize it.

### Upgrading from the original Kawa

The fork uses the same bundle identifier as the original (`net.noraesae.Kawa`),
so it reads your existing settings and shortcuts.

The original was available on Homebrew, but neither `kawa` nor its later name
`kawa-app` is available there any more. If you installed it that way, remove it
with whichever name `brew list --cask` shows (a plain uninstall keeps your
settings):

```bash
$ brew uninstall --cask kawa-app
```

If you used the original's login item, check that it points at
`/Applications/Kawa.app`, or turn on **Launch at login** in Kawa's preferences.

## Caveats

### CJKV input sources

There is a known bug in the macOS's Carbon library that switching keyboard
layouts using `TISSelectInputSource` doesn't work well with complex input
sources like [CJKV](https://en.wikipedia.org/wiki/CJK_characters). The
original project removed its workaround in 2020, and this fork doesn't add one.

## Development

Kawa is a Swift package. Building it requires Xcode (not just the Command Line
Tools), because the KeyboardShortcuts dependency uses SwiftUI preview macros
that only ship with Xcode.

```bash
$ git clone https://github.com/granola-cloud/kawa.git
$ cd kawa
$ ./scripts/build-app.sh              # Apple Silicon only
$ ./scripts/build-app.sh --universal  # Apple Silicon + Intel
```

The app is written to `build/Kawa.app` and ad-hoc signed. Set `CODESIGN_IDENTITY`
to sign with a Developer ID instead.

`System Events` keystrokes from AppleScript don't trigger the global
shortcuts; to test them without a keyboard, post a `CGEvent` to `.cghidEventTap`.

## Credits

Kawa was created by [Hyunje Jun (@hatashiro)](https://github.com/hatashiro),
with contributions from the [original project's contributors](https://github.com/hatashiro/kawa/graphs/contributors).
The logo and app icon are from the original project.

## License

Kawa is released under the [MIT License](LICENSE). The original copyright
notice is kept as required.
