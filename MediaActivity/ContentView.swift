//

import SwiftUI
import DiscordNowPlaying

struct ContentView: View {
  @Environment(DiscordNowPlaying.self) private var info

  private let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
  @State private var date = Date.now

  var body: some View {
    VStack {
      Label("MediaActivity", systemImage: "music.note.list")
        .font(.largeTitle)
        .foregroundStyle(.tint)
        .shadow(color: .accentColor, radius: 10)

      Spacer()

      VStack {
        // Title
        if let title = info.title {
          Text(title)
            .font(.title2)
        }

        // Description (Album + Artist)
        if let description = info.description {
          Text(description)
            .font(.headline)
            .lineLimit(1)
        }
      }
      .padding()

      // Artwork
      if let artwork = info.artwork,
         let image = NSImage(data: artwork) {
        Image(nsImage: image)
          .resizable()
          .clipShape(RoundedRectangle(cornerRadius: 16.0))
          .aspectRatio(contentMode: .fit)
      }

      // App name
      if let app = info.clientDisplayName,
         let bundle = info.clientBundleIdentifier {
        Text(app)
          .font(.title3)

        Text(bundle)
          .font(.callout)
          .foregroundStyle(.secondary)
      } else {
        Label("Not playing", systemImage: "speaker.slash.fill")
          .font(.title)
      }

      // Time
      if let duration = info.duration,
         let timestamp = info.timestamp,
         let playbackRate = info.playbackRate {
        // timeIntervalSince now is negative, so I'm subtracting.
        // if it's bigger than duration, just show 100%
        let value = min((info.elapsedTime ?? 0) - (playbackRate <= 0 ? 0.0 : Double(timestamp.timeIntervalSince(date))), duration)

        ProgressView(value: value > duration ? duration : value, total: duration)
          .progressViewStyle(.linear)
          .onReceive(timer) { input in
            date = input
          }
      }
    }
    .padding()
    .frame(width: 320, height: 420)
    .background(VisualEffect().ignoresSafeArea())
    .preferredColorScheme(.dark)
  }
}

#Preview {
  ContentView()
    .environment(DiscordNowPlaying())
}
