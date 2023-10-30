//

import Foundation

extension DiscordNowPlaying {

  /// Get the elapsed time based on the current date
  public var currentElapsedTime: Double? { getElapsedTime() }

  /// Get an elapsed time based on the given object, defaults to Date.now
  public func getElapsedTime(for date: Date = Date.now) -> Double? {
    guard let duration = duration,
          let playbackRate = playbackRate,
          let timestamp = timestamp,
          let elapsedTime = elapsedTime
    else { return nil }

    // If playback rate is 0 (not playing). Just return the value of elapsedTime
    if playbackRate == 0 { return elapsedTime }

    // Here we know the media is playing, which means elapsedTime is inaccurate
    // For that reason, we have to add the date diff between now and the timestamp.
    let time = elapsedTime - timestamp.timeIntervalSince(date) // "-" cuz the interval is negative

    // Cap time to duration and make sure it doesn't go under 0
    return min(max(time, 0), duration)
  }

}
