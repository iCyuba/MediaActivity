//

#import "../discord_game_sdk/cpp/discord.h"
#import <Foundation/Foundation.h>

#ifndef Client_h
#define Client_h

@interface DiscordClient : NSObject

@property struct discord::Core* core;

- (id) initWithId:(discord::ClientId)clientId;

- (void) updateActivity:(discord::Activity)activity;
- (void) clearActivity;

@end

#endif /* Client_h */
