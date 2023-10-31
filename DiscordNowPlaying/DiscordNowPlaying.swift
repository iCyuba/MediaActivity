//

import Foundation
import Swifter

@Observable public class DiscordNowPlaying {

  // Internal stuff
  var discordClient: DiscordClient?
  var discordCallbackTimer: Timer?
  var discordDebounceTimer: Timer? // This is used to not spam the discord sdk
  let httpServer = Swifter.HttpServer()

  public var client: Client?
  public var artwork: Artwork?

  public var duration: Double?
  public var title: String?
  public var playbackRate: Int16?
  public var album: String?
  public var timestamp: Date?
  public var artist: String?
  public var id: Int64?
  public var elapsedTime: Double?

  /// Artist + album if available
  public var description: String? {
    guard let artist else { return nil }

    if let album, !album.isEmpty {
      return "\(artist) — \(album)"
    } else {
      return artist
    }
  }

  public init() {
    setupHttpServer()
    registerNotifications()
    getInfo()
  }

  deinit {
    unregisterNotifications()
  }

}
