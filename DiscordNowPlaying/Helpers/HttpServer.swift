//

import Foundation
import Swifter

extension DiscordNowPlaying {

  /// Setup http server
  func setupHttpServer() {
    // Register the route
    httpServer["/:hash"] = { request in
      let hash = request.params[":hash"]

      // Make sure the hashes match
      if let artwork = self.artwork, hash == artwork.hashBase64url {
        // If they do, serve the artwork
        return .ok(.data(artwork.jpegData ?? artwork.data, contentType: artwork.mimeType))
      } else {
        // Otherwise, return 404
        return .notFound
      }
    }

    // Start the server
    try! httpServer.start()
  }

}
