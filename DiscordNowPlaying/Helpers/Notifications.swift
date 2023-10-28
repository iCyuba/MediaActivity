//

import Foundation

extension DiscordNowPlaying {

  /// Register info change notifications
  func registerNotifications() {
    MRMediaRemoteRegisterForNowPlayingNotifications(.main)

    [
      "kMRMediaRemoteNowPlayingApplicationDidChangeNotification",
      "kMRMediaRemoteNowPlayingInfoDidChangeNotification",
      "kMRMediaRemoteNowPlayingApplicationIsPlayingDidChangeNotification",
    ].forEach { name in
      // For each notification, just refetch the data.
      NotificationCenter.default.addObserver(self, selector: #selector(getInfo), name: Notification.Name(name), object: nil)
    }
  }

  /// Unregister the notifications
  func unregisterNotifications() {
    MRMediaRemoteUnregisterForNowPlayingNotifications()
  }

}
