#import <React/RCTBridgeModule.h>
#import <React/RCTViewManager.h>
#import <React/RCTEventDispatcher.h>

// Custom NSSlider subclass with an onChange property
@interface RNSliderView : NSSlider
@property (nonatomic, copy) RCTBubblingEventBlock onChange;
@end

// Module interface for React Native
@interface RNSliderMacOS : RCTViewManager
@end
