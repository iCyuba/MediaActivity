//

import Foundation
import Dynamic
import Observation

@Observable public class DiscordNowPlaying {
  private let discordClient = DiscordClient(id: 1165257733008789554)!

  public var clientDisplayName: String?
  public var clientBundleIdentifier: String?
  public var artwork: Data?
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

    if let album {
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
      // Parse the client properties
      if let clientData = dict?["kMRMediaRemoteNowPlayingInfoClientPropertiesData"] as? AnyObject {
        let client = Dynamic._MRNowPlayingClientProtobuf.initWithData(clientData)

        self.clientDisplayName = client.displayName.asString
        self.clientBundleIdentifier = client.bundleIdentifier.asString
      } else {
        // If for whatever reason the client wasn't returned, just set both values to nil
        self.clientDisplayName = nil
        self.clientBundleIdentifier = nil
      }

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

      self.updateDiscordStatus()
    }
  }

  public func updateDiscordStatus() {
    if let title {
      var activity = discord.Activity()
      activity.SetDetails(title)

      // Description
      if let description {
        activity.SetState(description)
      }

      // Try to set the artwork (only works for iTunes media)
      if let id {
        activity.GetAssetsMutating().pointee.SetLargeImage("https://itunes-artwork.icy.cx/\(id)")
      }

      discordClient.update(activity)
    } else {
      discordClient.clearActivity()
    }
  }

  @objc private func handleNotification(notification: Notification) {
    print(notification.name)

    getInfo()
  }
}

