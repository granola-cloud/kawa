import KeyboardShortcuts
import SwiftUI

struct PreferencesView: View {
  @ObservedObject var store: InputSourceStore
  @State private var showsNotification = PermanentStorage.showsNotification

  var body: some View {
    VStack(spacing: 0) {
      List(store.sources) { source in
        HStack {
          if let icon = source.icon {
            Image(nsImage: icon)
              .resizable()
              .frame(width: 16, height: 16)
          }
          Text(source.name)
          Spacer()
          KeyboardShortcuts.Recorder(for: source.shortcutName)
        }
        .padding(.vertical, 2)
      }

      Divider()

      HStack {
        Toggle("Show notification on switch", isOn: $showsNotification)
          .onChange(of: showsNotification) { _, enabled in
            PermanentStorage.showsNotification = enabled
            if enabled {
              Notifier.requestAuthorization { _ in }
            }
          }
        Spacer()
        Button("Quit Kawa") {
          NSApplication.shared.terminate(nil)
        }
      }
      .padding(12)
    }
    .frame(minWidth: 420, minHeight: 280)
  }
}
