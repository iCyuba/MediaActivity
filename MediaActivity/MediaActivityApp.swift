//

import SwiftUI

@main
struct MediaActivityApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
        .frame(width: 320, height: 420)
        .background(VisualEffect().ignoresSafeArea())
        .preferredColorScheme(.dark)
    }
    .windowStyle(.hiddenTitleBar)
    .windowResizability(.contentSize)
  }
}

struct VisualEffect: NSViewRepresentable {
  func makeNSView(context: Self.Context) -> NSView {
    let view = NSVisualEffectView()
    view.state = NSVisualEffectView.State.active

    return view
  }

  func updateNSView(_ nsView: NSView, context: Context) { }
}
