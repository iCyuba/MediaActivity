//

import Foundation
import Dynamic

@Observable @objc public class Info: NSObject {
  public var client: Client?

  public var artwork: Data?
  public var duration: Double?
  public var title: String?
  public var playbackRate: Int16?
  public var album: String?
  public var timestamp: Date?
  public var artist: String?
  public var id: Int64?
  public var elapsedTime: Double?

  private let discord = DiscordClient()

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

  public override init() {
    super.init()

    MRMediaRemoteRegisterForNowPlayingNotifications(.main)

    [
      "kMRMediaRemoteNowPlayingApplicationDidChangeNotification",
      "kMRMediaRemoteNowPlayingInfoDidChangeNotification",
      "kMRMediaRemoteNowPlayingApplicationIsPlayingDidChangeNotification",
    ].forEach { name in
      NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: Notification.Name(name), object: nil)
    }

    getInfo()
  }

  deinit {
    MRMediaRemoteUnregisterForNowPlayingNotifications()
  }

  /// Get information about the current playing media
  ///
  /// - Returns: The now playing media information, or nil if nothing is playing.
  public func getInfo() {
    MRMediaRemoteGetNowPlayingInfo(.main) { dict in
      // Parse the client properties as a Client struct
      self.client = {
        if let clientData = dict?["kMRMediaRemoteNowPlayingInfoClientPropertiesData"] as? AnyObject {
          Client(clientData)
        } else {
          nil
        }
      }()

      // Retrieve the rest
      self.artwork = dict?["kMRMediaRemoteNowPlayingInfoArtworkData"] as? Data
      self.duration = dict?["kMRMediaRemoteNowPlayingInfoDuration"] as? Double
      self.title = dict?["kMRMediaRemoteNowPlayingInfoTitle"] as? String
      self.playbackRate = dict?["kMRMediaRemoteNowPlayingInfoPlaybackRate"] as? Int16
      self.album = dict?["kMRMediaRemoteNowPlayingInfoAlbum"] as? String
      self.timestamp = dict?["kMRMediaRemoteNowPlayingInfoTimestamp"] as? Date
      self.artist = dict?["kMRMediaRemoteNowPlayingInfoArtist"] as? String
      self.id = dict?["kMRMediaRemoteNowPlayingInfoAlbumiTunesStoreAdamIdentifier"] as? Int64 ?? dict?["kMRMediaRemoteNowPlayingInfoiTunesStoreIdentifier"] as? Int64
      self.elapsedTime = dict?["kMRMediaRemoteNowPlayingInfoElapsedTime"] as? Double

      // Update the discord activity
      if let title = self.title,
         let artist = self.artist,
         let artwork = self.id,
         self.playbackRate == 1
      {
        self.discord.setActivity(artist, title, artwork)
      } else {
        self.discord.clearActivity()
      }
    }
  }

  @objc private func handleNotification(notification: Notification) {
    print(notification.name)

    getInfo()
  }
}
