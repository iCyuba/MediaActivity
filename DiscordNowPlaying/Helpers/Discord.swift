//

import Foundation

extension DiscordNowPlaying {

  /// Update the discord activity based on the current info
  public func updateDiscordStatus() {
    guard let title
    else { return discordClient.clearActivity() }

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

    discordClient.update(activity)
  }

}
