//

import SwiftUI

struct VisualEffect: NSViewRepresentable {
  func makeNSView(context: Self.Context) -> NSView {
    let view = NSVisualEffectView()
    view.state = .active

    return view
  }

  func updateNSView(_ nsView: NSView, context: Context) { }
}
