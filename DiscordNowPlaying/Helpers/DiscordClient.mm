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
  if (result != discord::Result::Ok) {
    delete core;

    return nil;
  }

  // Save the activity manager
  self.activity = &core->ActivityManager();

  return self;
}

- (void)dealloc {
  // Destroy the Discord client
  delete self.core;
}

- (void)runCallbacks {
  self.core->RunCallbacks();
}

- (void)updateActivity:(discord::Activity)activity {
  self.activity->UpdateActivity(activity, nil);
}

// Maybe Discord will fix this one day
//- (void)clearActivity {
//  self.activity->ClearActivity(ClearActivityCb);
//}

@end
