//

import SwiftUI
import DiscordNowPlaying

struct ContentView: View {
  @Environment(DiscordNowPlaying.self) private var info

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
      if let image = info.artwork?.image {
        Image(nsImage: image)
          .resizable()
          .clipShape(RoundedRectangle(cornerRadius: 16.0))
          .aspectRatio(contentMode: .fit)
      }

      // App name
      if let client = info.client {
        Text(client.name)
          .font(.title3)

        // If the text above is showing the app name, show the bundle id beneath it.
        if client.displayName != nil {
          Text(client.bundleIdentifier)
            .font(.callout)
            .foregroundStyle(.secondary)
        }
      } else {
        Label("Not playing", systemImage: "speaker.slash.fill")
          .font(.title)
          .padding()
      }

      // Time
      if let isPaused = info.isPaused,
         let duration = info.duration,
         let start = info.startTimestamp,
         let end = info.endTimestamp {
        if isPaused {
          ProgressView(value: info.elapsedTime, total: duration)
        } else {
          ProgressView(timerInterval: start...end, countsDown: false)
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
