import KeyboardShortcuts
import SwiftUI

struct PreferencesView: View {
  @ObservedObject var store: InputSourceStore
  @State private var showsIndicator = PermanentStorage.showsIndicator
  @State private var launchesAtLogin = LaunchAtLogin.isEnabled

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

      HStack(alignment: .bottom) {
        VStack(alignment: .leading, spacing: 6) {
          Toggle("Show indicator on switch", isOn: $showsIndicator)
            .onChange(of: showsIndicator) { _, enabled in
              PermanentStorage.showsIndicator = enabled
            }
          Toggle("Launch at login", isOn: Binding(
            get: { launchesAtLogin },
            set: { enabled in
              LaunchAtLogin.set(enabled)
              launchesAtLogin = LaunchAtLogin.isEnabled
            }
          ))
        }
        Spacer()
        Button("Quit Kawa") {
          NSApplication.shared.terminate(nil)
        }
      }
      .padding(12)
    }
    .frame(minWidth: 420, minHeight: 280)
    // The login item can also be toggled from System Settings.
    .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification)) { _ in
      launchesAtLogin = LaunchAtLogin.isEnabled
    }
  }
}
