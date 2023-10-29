//

import Foundation
import Dynamic

extension DiscordNowPlaying {

  public struct Client {
    public var displayName: String?
    public var bundleIdentifier: String
  }

  /// Parse the client info from a now playing response
  func parseClient(_ dict: NSDictionary?) -> Void {
    // Get the client data
    guard let data = dict?["kMRMediaRemoteNowPlayingInfoClientPropertiesData"] as? AnyObject,
          !data.isKind(of: NSNull.self) // Make sure it's not NSNull, which is returned when nothing is playing
    else { return client = nil }

    // Initialize the protobuf
    let protobuf = Dynamic._MRNowPlayingClientProtobuf.initWithData(data)

    // Parse the info from the protobuf
    guard let bundleIdentifier = protobuf.bundleIdentifier.asString
    else { return client = nil }

    client = Client(
      displayName: protobuf.displayName.asString,
      bundleIdentifier: bundleIdentifier
    )
  }

}
