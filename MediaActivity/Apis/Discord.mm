//

#import "Discord.h"
#import "MediaActivity-Swift.h"

#import <Foundation/Foundation.h>

@implementation DiscordClient

- (id)init {
  // Create the Discord core client
  discord::Core* core{};
  auto result = discord::Core::Create(1165257733008789554, DiscordCreateFlags_NoRequireDiscord, &core);
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

- (void)setActivity:(NSString *)state :(NSString *)detail :(SInt64)artwork {
  discord::Activity activity{};
  activity.SetState(state.UTF8String);
  activity.SetDetails(detail.UTF8String);
  activity.SetType(discord::ActivityType::Listening);

  NSString *url = [NSString stringWithFormat:@"https://test.icy.cx/%lld", artwork];
  activity.GetAssets().SetLargeImage(url.UTF8String);

  self.core->ActivityManager().UpdateActivity(activity, nil);
}

- (void)clearActivity {
  self.core->ActivityManager().ClearActivity(nil);
}

@end
