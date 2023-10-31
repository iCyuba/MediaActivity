//

import Foundation

extension DiscordNowPlaying {

  /// Get information about the current playing media
  ///
  /// - Returns: The now playing media information, or nil if nothing is playing.
  @objc public func getInfo() {
    MRMediaRemoteGetNowPlayingInfo(.main) { dict in
      // Parse the client and info
      self.parseClient(dict)
      self.parseArtwork(dict)

      self.duration = dict?["kMRMediaRemoteNowPlayingInfoDuration"] as? Double
      self.title = dict?["kMRMediaRemoteNowPlayingInfoTitle"] as? String
      self.playbackRate = dict?["kMRMediaRemoteNowPlayingInfoPlaybackRate"] as? Int16
      self.album = dict?["kMRMediaRemoteNowPlayingInfoAlbum"] as? String
      self.timestamp = dict?["kMRMediaRemoteNowPlayingInfoTimestamp"] as? Date
      self.artist = dict?["kMRMediaRemoteNowPlayingInfoArtist"] as? String
      self.id = dict?["kMRMediaRemoteNowPlayingInfoAlbumiTunesStoreAdamIdentifier"] as? Int64 ?? dict?["kMRMediaRemoteNowPlayingInfoiTunesStoreIdentifier"] as? Int64
      self.elapsedTime = dict?["kMRMediaRemoteNowPlayingInfoElapsedTime"] as? Double

      // Update the Discord status after like 0.25s
      // This is because the MediaRemote notifications get spammed like crazy when a change occurs
      self.discordDebounceTimer?.invalidate()
      self.discordDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false) { _ in
        self.discordDebounceTimer?.invalidate()
        self.discordDebounceTimer = nil

        self.updateDiscordStatus()
      }
    }
  }

}
