//

import SwiftUI
import DiscordNowPlaying

@main
struct MediaActivityApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
    .windowStyle(.hiddenTitleBar)
    .windowResizability(.contentSize)
    .environment(DiscordNowPlaying())
  }
}
