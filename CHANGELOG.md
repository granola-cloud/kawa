## 2.0.0 (25 Oct 2026)

* Run natively on Apple Silicon (arm64; optional universal build)
* Require macOS 14 or later
* Replace Carthage + MASShortcut with SwiftPM + KeyboardShortcuts; migrate existing shortcuts
* Replace the Xcode project and storyboard with a Swift package and SwiftUI preferences
* Register shortcuts at launch instead of when the preferences table renders
* Pick up input sources added or removed while Kawa is running
* Replace notifications with an on-screen indicator on switch
* Add a launch at login option
* Avoid crashes on input sources with missing properties

## 1.1.0 (10 Nov 2017)

* Remove previous notifications on new one (#17)

## 1.0.1 (18 Sep 2017)

* Make statusbar icon visible in dark UI

## 1.0.0 (16 Sep 2017)

* Add an option to show macOS notification on source change (#9)
* Implement a proper workaround for the known CJKV bug (#12)
* Update licenses for 2017
* Minor code refactoring

## 0.1.3 (3 Oct 2016)

* Use Swift 3
* Remove 'advanced input switching'

## 0.1.2 (6 Aug 2015)

* Change 'simple method' option to 'advanced method' option.
* Open 'Preferences' initially only for the first launch.

## 0.1.0 (6 Aug 2015)

* Initial release
