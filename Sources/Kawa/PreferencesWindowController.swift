import Cocoa
import SwiftUI

@MainActor
final class PreferencesWindowController: NSWindowController, NSWindowDelegate {
  static let shared = PreferencesWindowController()

  init() {
    let window = NSWindow(
      contentViewController: NSHostingController(rootView: PreferencesView(store: InputSourceStore.shared))
    )
    window.title = "Kawa"
    window.styleMask = [.titled, .closable, .resizable]
    window.setContentSize(NSSize(width: 460, height: 320))
    window.center()
    window.isReleasedWhenClosed = false
    super.init(window: window)
    window.delegate = self
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func showAndActivate() {
    InputSourceStore.shared.reload()
    showWindow(nil)
    window?.makeKeyAndOrderFront(nil)
    NSApp.activate()
  }

  func windowWillClose(_ notification: Notification) {
    // Hand focus back to whichever app owns the menu bar.
    NSWorkspace.shared.menuBarOwningApplication?.activate()
  }
}
