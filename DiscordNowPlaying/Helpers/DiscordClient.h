//

#import "../../discord_game_sdk/cpp/discord.h"
#import <Foundation/Foundation.h>

#ifndef DiscordClient_h
#define DiscordClient_h

@interface DiscordClient : NSObject

@property struct discord::Core* core;
@property struct discord::ActivityManager* activity;

- (id) initWithId:(discord::ClientId)clientId;

- (void) runCallbacks;
- (void) updateActivity:(discord::Activity)activity;
//- (void) clearActivity; // This doesn't work. Delete the client instead

@end

#endif /* DiscordClient_h */
