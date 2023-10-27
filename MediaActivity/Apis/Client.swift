//

import Foundation
import Dynamic

public struct Client {
  public let bundleIdentifier: String
  public let displayName: String

  init(_ protobuf: AnyObject) {
    let client = Dynamic._MRNowPlayingClientProtobuf.initWithData(protobuf)

    self.bundleIdentifier = client.bundleIdentifier.asString!
    self.displayName = client.displayName.asString!
  }
}
