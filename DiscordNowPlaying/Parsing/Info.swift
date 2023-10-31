//

import Foundation

extension DiscordNowPlaying {

  /// Get information about the current playing media
  ///
  /// - Returns: The now playing media information, or nil if nothing is playing.
  @objc public func getInfo() {
    MRMediaRemoteGetNowPlayingInfo(.main) { [self] dict in
      // Check if the new media is the same as the current one
      // (Not checking "id" on purpose, because it can be null even with playing media)
      let title = dict?["kMRMediaRemoteNowPlayingInfoTitle"] as? String
      let artist = dict?["kMRMediaRemoteNowPlayingInfoArtist"] as? String
      let album = dict?["kMRMediaRemoteNowPlayingInfoAlbum"] as? String

      let equal = title != nil && title == self.title && artist == self.artist && album == self.album

      // Set the new values
      self.title = title
      self.album = album
      self.artist = artist

      // Parse the client, artwork and time
      parseClient(dict)
      parseArtwork(dict, equal: equal)
      parseTime(dict, equal: equal)

      // And finally, set the iTunes id
      id = dict?["kMRMediaRemoteNowPlayingInfoAlbumiTunesStoreAdamIdentifier"] as? Int64 ?? dict?["kMRMediaRemoteNowPlayingInfoiTunesStoreIdentifier"] as? Int64

      // Update the Discord status after like 0.25s
      // This is because the MediaRemote notifications get spammed like crazy when a change occurs
      discordDebounceTimer?.invalidate()
      discordDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false) { [self] _ in
        discordDebounceTimer?.invalidate()
        discordDebounceTimer = nil

        updateDiscordStatus()
      }
    }
  }

}
