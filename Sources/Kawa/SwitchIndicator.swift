import Cocoa
import SwiftUI

// A brief, non-activating overlay naming the selected input source, in the style of the system volume HUD.
@MainActor
final class SwitchIndicator {
  static let shared = SwitchIndicator()

  private let panel: NSPanel
  private var hideWorkItem: DispatchWorkItem?

  private init() {
    panel = NSPanel(
      contentRect: .zero,
      styleMask: [.borderless, .nonactivatingPanel],
      backing: .buffered,
      defer: true
    )
    panel.level = .statusBar
    panel.isOpaque = false
    panel.backgroundColor = .clear
    panel.hasShadow = false
    panel.ignoresMouseEvents = true
    panel.hidesOnDeactivate = false
    panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary, .ignoresCycle]
  }

  func show(_ name: String, icon: NSImage?) {
    let hostingView = NSHostingView(rootView: IndicatorView(name: name, icon: icon))
    panel.contentView = hostingView
    panel.setContentSize(hostingView.fittingSize)
    position()

    hideWorkItem?.cancel()
    panel.alphaValue = 1
    panel.orderFrontRegardless()

    let hide = DispatchWorkItem { [weak self] in
      NSAnimationContext.runAnimationGroup { context in
        context.duration = 0.25
        self?.panel.animator().alphaValue = 0
      } completionHandler: {
        MainActor.assumeIsolated {
          if self?.panel.alphaValue == 0 { self?.panel.orderOut(nil) }
        }
      }
    }
    hideWorkItem = hide
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.9, execute: hide)
  }

  // Lower third of the screen the mouse is on, where the system HUDs appear.
  private func position() {
    let mouse = NSEvent.mouseLocation
    guard let screen = NSScreen.screens.first(where: { $0.frame.contains(mouse) }) ?? NSScreen.main else { return }
    let visible = screen.visibleFrame
    let size = panel.frame.size
    panel.setFrameOrigin(NSPoint(x: visible.midX - size.width / 2, y: visible.minY + visible.height * 0.2))
  }
}

private struct IndicatorView: View {
  let name: String
  let icon: NSImage?

  var body: some View {
    HStack(spacing: 10) {
      if let icon {
        Image(nsImage: icon)
          .resizable()
          .frame(width: 22, height: 22)
      }
      Text(name)
        .font(.system(size: 17, weight: .medium))
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 12)
    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    .fixedSize()
  }
}
