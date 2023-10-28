//

import Foundation
import Swifter

@Observable public class DiscordNowPlaying {
  
  // Internal stuff
  let discordClient = DiscordClient(id: 1165257733008789554)!
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

  /// A more accurate elapsedTime
  public var realElapsedTime: Double? {
    guard let duration = duration,
          let playbackRate = playbackRate,
          let timestamp = timestamp,
          let elapsedTime = elapsedTime
    else { return nil }

    // If playback rate is 0 (not playing). Just return the value of elapsedTime
    if playbackRate == 0 { return elapsedTime }

    // Here we know the media is playing, which means elapsedTime is inaccurate
    // For that reason, we have to add the date diff between now and the timestamp.
    let time = elapsedTime - timestamp.timeIntervalSinceNow // "-" cuz the interval is negative

    // Cap time to duration
    return min(time, duration)
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
