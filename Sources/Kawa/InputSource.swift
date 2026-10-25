import Carbon
import Cocoa
import KeyboardShortcuts

final class InputSource: Identifiable {
  let tisInputSource: TISInputSource
  let id: String
  let name: String
  let icon: NSImage?

  init?(tisInputSource: TISInputSource) {
    guard let id = tisInputSource.id else { return nil }
    self.tisInputSource = tisInputSource
    self.id = id
    self.name = tisInputSource.name ?? id
    self.icon = Self.loadIcon(tisInputSource)
  }

  var shortcutName: KeyboardShortcuts.Name {
    KeyboardShortcuts.Name(id)
  }

  func select() {
    TISSelectInputSource(tisInputSource)
  }

  private static func loadIcon(_ source: TISInputSource) -> NSImage? {
    if let imageURL = source.iconImageURL {
      for url in [imageURL.retinaImageURL, imageURL.tiffImageURL, imageURL] {
        if let image = NSImage(contentsOf: url) {
          return image
        }
      }
    }
    if let iconRef = source.iconRef {
      return NSImage(iconRef: iconRef)
    }
    return nil
  }
}

@MainActor
final class InputSourceStore: ObservableObject {
  static let shared = InputSourceStore()

  @Published private(set) var sources: [InputSource] = []

  private var boundShortcutNames = Set<KeyboardShortcuts.Name>()

  func start() {
    reload()

    DistributedNotificationCenter.default().addObserver(
      forName: Notification.Name(kTISNotifyEnabledKeyboardInputSourcesChanged as String),
      object: nil,
      queue: .main
    ) { _ in
      MainActor.assumeIsolated { InputSourceStore.shared.reload() }
    }
  }

  func reload() {
    sources = TISInputSource.keyboardSources().compactMap(InputSource.init)
    sources.forEach(bind)
  }

  private func bind(_ source: InputSource) {
    let name = source.shortcutName
    guard boundShortcutNames.insert(name).inserted else { return }

    KeyboardShortcuts.onKeyDown(for: name) { [weak self] in
      // Look the source up at fire time so a reload never leaves a stale TISInputSource behind.
      guard let current = self?.sources.first(where: { $0.id == source.id }) else { return }
      current.select()

      if PermanentStorage.showsNotification {
        Notifier.show(current.name, icon: current.icon)
      }
    }
  }
}

private extension URL {
  var retinaImageURL: URL {
    let ext = pathExtension
    let base = deletingPathExtension().lastPathComponent
    return deletingLastPathComponent().appendingPathComponent("\(base)@2x").appendingPathExtension(ext)
  }

  var tiffImageURL: URL {
    deletingPathExtension().appendingPathExtension("tiff")
  }
}
