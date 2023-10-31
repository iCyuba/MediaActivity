//

import Foundation

extension DiscordNowPlaying {

  /// Update the discord activity based on the current info
  public func updateDiscordStatus() {
    // Since Discord's ClearActivity function is broken, I have to destroy the client instead.
    guard title != nil, playbackRate != 0 else {
      discordClient = nil
      discordCallbackTimer = nil

      return
    }

    // If the client is nil, try to create a new one.
    if discordClient == nil { 
      discordClient = DiscordClient(id: 1165257733008789554)

      // But if creating it fails, just return.
      guard discordClient != nil else { return }

      // Setup the callback timer
      discordCallbackTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] _ in
        discordClient?.runCallbacks()
      })
    }

    var activity = discord.Activity()
    activity.SetDetails(title)

    // Description
    if let description {
      activity.SetState(description)
    }

    // Try to set the iTunes artwork, but fallback to local http server for the artwork
//    if let id {
//      activity.GetAssetsMutating().pointee.SetLargeImage("https://itunes-artwork.icy.cx/\(id)")
//    } else 
    if let artwork {
      activity.GetAssetsMutating().pointee.SetLargeImage("https://remote.icyuba.com/\(artwork.hashBase64url)")
    }

    discordClient!.updateActivity(activity)
  }

}
