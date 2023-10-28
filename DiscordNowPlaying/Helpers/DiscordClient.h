//

#import "../../discord_game_sdk/cpp/discord.h"
#import <Foundation/Foundation.h>

#ifndef DiscordClient_h
#define DiscordClient_h

@interface DiscordClient : NSObject

@property struct discord::Core* core;

- (id) initWithId:(discord::ClientId)clientId;

- (void) updateActivity:(discord::Activity)activity;
- (void) clearActivity;

@end

#endif /* DiscordClient_h */
