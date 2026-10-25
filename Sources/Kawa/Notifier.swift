import Cocoa
import UserNotifications

enum Notifier {
  static func requestAuthorization(completion: @escaping @Sendable (Bool) -> Void) {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { granted, _ in
      completion(granted)
    }
  }

  static func show(_ message: String, icon: NSImage?) {
    let center = UNUserNotificationCenter.current()
    center.removeAllDeliveredNotifications()

    let content = UNMutableNotificationContent()
    content.body = message
    if let attachment = icon.flatMap(attachment(for:)) {
      content.attachments = [attachment]
    }

    center.add(UNNotificationRequest(identifier: "input-source-changed", content: content, trigger: nil))
  }

  // Attachments are moved into the notification store, so hand over a temporary copy of the icon.
  private static func attachment(for icon: NSImage) -> UNNotificationAttachment? {
    guard
      let tiff = icon.tiffRepresentation,
      let png = NSBitmapImageRep(data: tiff)?.representation(using: .png, properties: [:])
    else { return nil }

    let url = FileManager.default.temporaryDirectory
      .appendingPathComponent(UUID().uuidString)
      .appendingPathExtension("png")
    guard (try? png.write(to: url)) != nil else { return nil }
    return try? UNNotificationAttachment(identifier: "icon", url: url)
  }
}
