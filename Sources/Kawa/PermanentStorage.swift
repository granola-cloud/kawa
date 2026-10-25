import Foundation

enum PermanentStorage {
  private enum StorageKey: String {
    case showsNotification = "show-notification"
    case launchedForTheFirstTime = "launched-for-the-first-time"
    case migratedMASShortcuts = "migrated-mas-shortcuts"
  }

  private static func object<T>(forKey key: StorageKey, withDefault defaultValue: T) -> T {
    UserDefaults.standard.object(forKey: key.rawValue) as? T ?? defaultValue
  }

  private static func set<T>(_ value: T, forKey key: StorageKey) {
    UserDefaults.standard.set(value, forKey: key.rawValue)
  }

  static var showsNotification: Bool {
    get { object(forKey: .showsNotification, withDefault: false) }
    set { set(newValue, forKey: .showsNotification) }
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
