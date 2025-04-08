#import "RNSliderMacOS.h"
#import <React/RCTUIManager.h>

@implementation RNSliderView
@end

@implementation RNSliderMacOS

RCT_EXPORT_MODULE(RNSlider)

// ✅ Create a new NSSlider instance
- (NSView *)view
{
  RNSliderView *slider = [[RNSliderView alloc] init];
  slider.minValue = 0;
  slider.maxValue = 1;
  slider.target = self;
  slider.action = @selector(sliderValueChanged:);
  return slider;
}

// ✅ Allow setting `value` from React Native
RCT_CUSTOM_VIEW_PROPERTY(value, double, RNSliderView)
{
  view.doubleValue = [json doubleValue]; // ✅ Set slider value
}

// ✅ Expose `onChange` event
RCT_EXPORT_VIEW_PROPERTY(onChange, RCTBubblingEventBlock)

// ✅ Allow updating slider value via ref
RCT_EXPORT_METHOD(setProgress:(nonnull NSNumber *)value forView:(nonnull NSNumber *)reactTag)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *, NSView *> *viewRegistry) {
      RNSliderView *slider = (RNSliderView *)viewRegistry[reactTag];
      if (slider) {
        slider.doubleValue = [value doubleValue]; // ✅ Update slider value
      }
    }];
  });
}

// ✅ Get current slider progress
RCT_EXPORT_METHOD(getProgress:(nonnull NSNumber *)reactTag resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *, NSView *> *viewRegistry) {
      RNSliderView *slider = (RNSliderView *)viewRegistry[reactTag];
      if (slider) {
        resolve(@(slider.doubleValue)); // ✅ Return current value
      } else {
        reject(@"SLIDER_ERROR", @"Slider view not found", nil);
      }
    }];
  });
}

// ✅ Handle slider value changes and send events to React Native
- (void)sliderValueChanged:(RNSliderView *)sender
{
  if (sender.onChange) {
    sender.onChange(@{@"value": @(sender.doubleValue)});
  }
}

@end
