//

#import "DiscordClient.h"

#import <Foundation/Foundation.h>

@implementation DiscordClient

- (id)initWithId:(discord::ClientId)clientId {
  // Create the Discord core client
  discord::Core* core{};
  auto result = discord::Core::Create(clientId, DiscordCreateFlags_NoRequireDiscord, &core);
  self.core = core;

  // If the initialization failed for whatever reason, return nil
  if (result != discord::Result::Ok) return nil;

  // Run the callbacks every 1 second
  [NSTimer scheduledTimerWithTimeInterval:1 repeats:true block:^(NSTimer * _Nonnull timer) {
    self.core->RunCallbacks();
  }];

  return self;
}

- (void)dealloc {
  delete self.core;
}

- (void)updateActivity:(discord::Activity)activity {
  self.core->ActivityManager().UpdateActivity(activity, nil);
}

- (void)clearActivity {
  self.core->ActivityManager().ClearActivity(nil);
}

@end
