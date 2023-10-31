//

import Foundation
import CryptoKit
import AppKit

extension DiscordNowPlaying {

  public struct Artwork {
    public var data: Data

    public var identifier: String?
    public var width: Int64?
    public var height: Int64?
    public var mimeType: String?

    public var image: NSImage? { NSImage(data: data) }

    // YouTube sometimes returns tiff, which isn't supported by Discord's cdn, so I'm converting it here.
    public var jpegData: Data? {
      return NSBitmapImageRep(data: data)?.representation(using: .jpeg, properties: [.compressionFactor : 1.0])
    }

    public var hash: CryptoKit.SHA256Digest { CryptoKit.SHA256.hash(data: jpegData ?? data) }
    public var hashBase64url: String {
      Data(hash)
        .base64EncodedString()
        .replacingOccurrences(of: "+", with: "-")
        .replacingOccurrences(of: "/", with: "_")
        .replacingOccurrences(of: "=", with: "")
    }
  }

  /// Parse all the info about the artwork
  func parseArtwork(_ dict: NSDictionary?, equal: Bool) {
    guard let data = dict?["kMRMediaRemoteNowPlayingInfoArtworkData"] as? Data else {
      // If the new data is nil, but the media hasn't changed, keep the old artwork
      // This happens when you pause the media, for whatever reason.
      if (!equal) { artwork = nil }

      return
    }

    artwork = Artwork(
      data: data,
      identifier: dict?["kMRMediaRemoteNowPlayingInfoArtworkIdentifier"] as? String,
      width: dict?["kMRMediaRemoteNowPlayingInfoArtworkDataWidth"] as? Int64,
      height: dict?["kMRMediaRemoteNowPlayingInfoArtworkDataHeight"] as? Int64,
      mimeType: dict?["kMRMediaRemoteNowPlayingInfoArtworkMIMEType"] as? String
    )
  }

}
