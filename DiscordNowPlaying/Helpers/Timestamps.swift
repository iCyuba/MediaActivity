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

}
