import Cocoa

@MainActor
final class StatusBar: NSObject {
  let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

  override init() {
    super.init()

    let buttonImage = NSImage(named: "StatusItemIcon")
    buttonImage?.isTemplate = true

    guard let button = item.button else { return }
    button.target = self
    button.action = #selector(action(_:))
    button.image = buttonImage
    button.toolTip = "Click to open preferences"
  }

  @objc func action(_ sender: NSButton) {
    PreferencesWindowController.shared.showAndActivate()
  }
}
