//

#import "../../discord_game_sdk/cpp/discord.h"
#import <Foundation/Foundation.h>

#ifndef Discord_h
#define Discord_h

@interface DiscordClient : NSObject

@property struct discord::Core* core;

- (void) clearActivity;
- (void) setActivity:(NSString *)state :(NSString *)detail :(SInt64)artwork;

@end

#endif /* Discord_h */
