import Foundation

enum PermanentStorage {
  private enum StorageKey: String {
    // Key kept from 1.x, when the indicator was a system notification.
    case showsIndicator = "show-notification"
    case launchedForTheFirstTime = "launched-for-the-first-time"
    case migratedMASShortcuts = "migrated-mas-shortcuts"
  }

  private static func object<T>(forKey key: StorageKey, withDefault defaultValue: T) -> T {
    UserDefaults.standard.object(forKey: key.rawValue) as? T ?? defaultValue
  }

  private static func set<T>(_ value: T, forKey key: StorageKey) {
    UserDefaults.standard.set(value, forKey: key.rawValue)
  }

  static var showsIndicator: Bool {
    get { object(forKey: .showsIndicator, withDefault: false) }
    set { set(newValue, forKey: .showsIndicator) }
  }

  static var launchedForTheFirstTime: Bool {
    get { object(forKey: .launchedForTheFirstTime, withDefault: true) }
    set { set(newValue, forKey: .launchedForTheFirstTime) }
  }

  static var migratedMASShortcuts: Bool {
    get { object(forKey: .migratedMASShortcuts, withDefault: false) }
    set { set(newValue, forKey: .migratedMASShortcuts) }
  }
}
