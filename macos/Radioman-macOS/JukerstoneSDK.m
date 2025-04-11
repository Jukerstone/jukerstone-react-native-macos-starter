#import "JukerstoneSDK.h"

@implementation JukerstoneSDK

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(load:(NSDictionary *)params)
{
  NSLog(@"📡 Native -> JS: load called with %@", params);
}

RCT_EXPORT_METHOD(pause)
{
  NSLog(@"⏸ Native -> JS: pause called");
}

RCT_EXPORT_METHOD(resume)
{
  NSLog(@"▶️ Native -> JS: resume called");
}

RCT_EXPORT_METHOD(seek:(nonnull NSNumber *)seconds)
{
  NSLog(@"⏩ Native -> JS: seek called to %d", [seconds intValue]);
}

@end

