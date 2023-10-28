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

      // Update the Discord status
      self.updateDiscordStatus()
    }
  }

}
