import Carbon
import Cocoa
import KeyboardShortcuts

// Kawa 1.x stored MASShortcut objects as keyed archives under the input source ID with "." replaced by "-".
enum ShortcutMigration {
  @MainActor
  static func migrateFromMASShortcutIfNeeded() {
    guard !PermanentStorage.migratedMASShortcuts else { return }
    defer { PermanentStorage.migratedMASShortcuts = true }

    for source in TISInputSource.keyboardSources(includeAllInstalled: true) {
      guard let id = source.id else { continue }
      let name = KeyboardShortcuts.Name(id)
      let legacyKey = id.replacingOccurrences(of: ".", with: "-")

      guard
        KeyboardShortcuts.getShortcut(for: name) == nil,
        let data = UserDefaults.standard.data(forKey: legacyKey),
        let legacy = decode(data)
      else { continue }

      let shortcut = KeyboardShortcuts.Shortcut(
        KeyboardShortcuts.Key(rawValue: legacy.keyCode),
        modifiers: NSEvent.ModifierFlags(rawValue: legacy.modifierFlags)
      )
      KeyboardShortcuts.setShortcut(shortcut, for: name)
    }
  }

  private static func decode(_ data: Data) -> LegacyShortcut? {
    guard let unarchiver = try? NSKeyedUnarchiver(forReadingFrom: data) else { return nil }
    unarchiver.requiresSecureCoding = false
    unarchiver.setClass(LegacyShortcut.self, forClassName: "MASShortcut")
    defer { unarchiver.finishDecoding() }
    return unarchiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as? LegacyShortcut
  }
}

@objc(KawaLegacyShortcut)
private final class LegacyShortcut: NSObject, NSCoding {
  let keyCode: Int
  let modifierFlags: UInt

  init?(coder: NSCoder) {
    keyCode = coder.decodeInteger(forKey: "KeyCode")
    modifierFlags = UInt(bitPattern: coder.decodeInteger(forKey: "ModifierFlags"))
  }

  func encode(with coder: NSCoder) {}
}
