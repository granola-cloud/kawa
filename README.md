![logo](resource/png/logo.png)

# Kawa [![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/utatti/kawa/master/LICENSE) [![GitHub release](https://img.shields.io/github/release/utatti/kawa.svg)](https://github.com/utatti/kawa/releases)

A macOS input source switcher with user-defined shortcuts.

Requires macOS 14 or later. Runs natively on Apple Silicon.

## Demo

[![demo](https://cloud.githubusercontent.com/assets/1013641/9109734/d73505e4-3c72-11e5-9c71-49cdf4a484da.gif)](http://vimeo.com/135542587)

## Install

### Using [Homebrew](https://brew.sh/)

```shell
brew update
brew install --cask kawa
```

### Manually

The prebuilt binaries can be found in [Releases](https://github.com/utatti/kawa/releases).

Unzip `Kawa.zip` and move `Kawa.app` to `Applications`.

## Caveats

### CJKV input sources

There is a known bug in the macOS's Carbon library that switching keyboard
layouts using `TISSelectInputSource` doesn't work well with complex input
sources like [CJKV](https://en.wikipedia.org/wiki/CJK_characters).

## Development

Kawa is a Swift package. Building it requires Xcode (not just the Command Line
Tools), because the [KeyboardShortcuts](https://github.com/sindresorhus/KeyboardShortcuts)
dependency uses SwiftUI preview macros that only ship with Xcode.

```bash
$ git clone https://github.com/hatashiro/kawa.git
$ cd kawa
$ ./scripts/build-app.sh              # Apple Silicon only
$ ./scripts/build-app.sh --universal  # Apple Silicon + Intel
```

The app is written to `build/Kawa.app` and ad-hoc signed. Set `CODESIGN_IDENTITY`
to sign with a Developer ID instead.

Shortcuts saved by Kawa 1.x are migrated automatically on first launch.

`System Events` keystrokes from AppleScript don't trigger the global
shortcuts; to test them without a keyboard, post a `CGEvent` to `.cghidEventTap`.

## License

Kawa is released under the [MIT License](LICENSE).
