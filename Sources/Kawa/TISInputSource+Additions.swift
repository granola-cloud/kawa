import Carbon

extension TISInputSource {
  private func property<T>(_ key: CFString) -> T? {
    guard let pointer = TISGetInputSourceProperty(self, key) else { return nil }
    return Unmanaged<AnyObject>.fromOpaque(pointer).takeUnretainedValue() as? T
  }

  var id: String? {
    property(kTISPropertyInputSourceID)
  }

  var name: String? {
    property(kTISPropertyLocalizedName)
  }

  var category: String? {
    property(kTISPropertyInputSourceCategory)
  }

  var isSelectable: Bool {
    property(kTISPropertyInputSourceIsSelectCapable) ?? false
  }

  var iconImageURL: URL? {
    property(kTISPropertyIconImageURL)
  }

  var iconRef: IconRef? {
    guard let pointer = TISGetInputSourceProperty(self, kTISPropertyIconRef) else { return nil }
    return IconRef(pointer)
  }

  static func keyboardSources(includeAllInstalled: Bool = false) -> [TISInputSource] {
    guard let list = TISCreateInputSourceList(nil, includeAllInstalled)?.takeRetainedValue() as? [TISInputSource] else {
      return []
    }
    return list.filter {
      $0.category == (kTISCategoryKeyboardInputSource as String) && $0.isSelectable
    }
  }
}
