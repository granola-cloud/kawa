import Cocoa

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
  private var statusBar: StatusBar?

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    ShortcutMigration.migrateFromMASShortcutIfNeeded()
    InputSourceStore.shared.start()
    statusBar = StatusBar()

    if PermanentStorage.launchedForTheFirstTime {
      PermanentStorage.launchedForTheFirstTime = false
      showPreferences()
    }
  }

  // Launching the app again (Finder, Spotlight, `open`) while it runs opens preferences.
  func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
    showPreferences()
    return true
  }

  func showPreferences() {
    PreferencesWindowController.shared.showAndActivate()
  }
}
