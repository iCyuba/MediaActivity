//

import Foundation

extension DiscordNowPlaying {

  /// Timestamp of the start of the media relative to the parsed timestamp
  public var startTimestamp: Date? {
    guard let timestamp,
          let elapsedTime
    else { return nil }

    return timestamp.addingTimeInterval(-elapsedTime)
  }

  /// Timestamp of the start of the media relative to the parsed timestamp
  public var endTimestamp: Date? {
    guard let startTimestamp,
          let duration
    else { return nil }

    return startTimestamp.addingTimeInterval(duration)
  }

  /// Whether the media is paused or not
  public var isPaused: Bool? { playbackRate != nil ? playbackRate == 0 : nil }

  /// Parse the duration, elapsed time, timestamp and playback rate
  func parseTime(_ dict: NSDictionary?, equal: Bool) {
    // If the new values are nil but weren't before and the media is equal, keep the old values
    // This happens when you unpause the media for some reason
    duration = dict?["kMRMediaRemoteNowPlayingInfoDuration"] as? Double ?? (equal ? duration : nil)
    playbackRate = dict?["kMRMediaRemoteNowPlayingInfoPlaybackRate"] as? Int16 ?? (equal ? playbackRate : nil)
    timestamp = dict?["kMRMediaRemoteNowPlayingInfoTimestamp"] as? Date ?? (equal ? timestamp : nil)
    elapsedTime = dict?["kMRMediaRemoteNowPlayingInfoElapsedTime"] as? Double ?? (equal ? elapsedTime : nil)
  }

}
