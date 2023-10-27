//

import Foundation

// MARK: MediaRemote.framework
let bundle = CFBundleCreate(kCFAllocatorDefault, NSURL.fileURL(withPath: "/System/Library/PrivateFrameworks/MediaRemote.framework") as CFURL);

// MARK: MRMediaRemoteGetNowPlayingInfo
private let MRMediaRemoteGetNowPlayingInfoPointer = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteGetNowPlayingInfo" as CFString)

typealias MRMediaRemoteGetNowPlayingInfoFunction = @convention(c) (DispatchQueue, @escaping (NSDictionary?) -> Void) -> Void
let MRMediaRemoteGetNowPlayingInfo = unsafeBitCast(MRMediaRemoteGetNowPlayingInfoPointer, to: MRMediaRemoteGetNowPlayingInfoFunction.self)

// MARK: MRMediaRemoteRegisterForNowPlayingNotifications
private let MRMediaRemoteRegisterForNowPlayingNotificationsPointer = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteRegisterForNowPlayingNotifications" as CFString)

typealias MRMediaRemoteRegisterForNowPlayingNotificationsFunction = @convention(c) (DispatchQueue) -> Void
let MRMediaRemoteRegisterForNowPlayingNotifications = unsafeBitCast(MRMediaRemoteRegisterForNowPlayingNotificationsPointer, to: MRMediaRemoteRegisterForNowPlayingNotificationsFunction.self)

// MARK: MRMediaRemoteUnregisterForNowPlayingNotifications
private let MRMediaRemoteUnregisterForNowPlayingNotificationsPointer = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteUnregisterForNowPlayingNotifications" as CFString)

typealias MRMediaRemoteUnregisterForNowPlayingNotificationsFunction = @convention(c) () -> Void
let MRMediaRemoteUnregisterForNowPlayingNotifications = unsafeBitCast(MRMediaRemoteUnregisterForNowPlayingNotificationsPointer, to: MRMediaRemoteUnregisterForNowPlayingNotificationsFunction.self)
