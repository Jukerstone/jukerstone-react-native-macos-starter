#import "AppDelegate.h"

#import <React/RCTBundleURLProvider.h>
#import "RNCWebViewImpl+SSL.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    self.moduleName = @"Radioman";
    self.initialProps = @{};

    [self installCerts];

    // Listen for the window becoming active
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(makeWindowFullscreen)
                                                 name:NSWindowDidBecomeKeyNotification
                                               object:nil];

    return [super applicationDidFinishLaunching:notification];
}

// Apply fullscreen only when the window is ready
- (void)makeWindowFullscreen {
    NSWindow *window = [NSApp mainWindow];

    if (window) {
        NSLog(@"✅ Window is now active. Applying fullscreen mode...");

        // Hide ONLY the maximize button (green)
        [[window standardWindowButton:NSWindowZoomButton] setHidden:YES];

        // Allow closing (red) and minimizing (yellow)
        [[window standardWindowButton:NSWindowCloseButton] setHidden:NO];
        [[window standardWindowButton:NSWindowMiniaturizeButton] setHidden:NO];

        // Ensure fullscreen mode is allowed
        [window setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];

        // Prevent resizing
        [window setStyleMask:([window styleMask] & ~NSWindowStyleMaskResizable)];

        // Set window to fullscreen size manually
        NSScreen *mainScreen = [NSScreen mainScreen];
        [window setFrame:[mainScreen frame] display:YES animate:NO];

        // Force fullscreen if not already in fullscreen
        if (![window isZoomed]) {
            [window toggleFullScreen:nil];
        }

        // Remove observer after fullscreen is applied
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:NSWindowDidBecomeKeyNotification
                                                      object:nil];
    } else {
        NSLog(@"⚠️ Window is still not available. Retrying in 100ms...");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self makeWindowFullscreen]; // Retry if window isn't available yet
        });
    }
}

- (void)installCerts {
    NSBundle *bundle = [NSBundle mainBundle];
    NSMutableDictionary *certMap = [NSMutableDictionary new];

    // Load your .der certificate
    NSData *certData = [NSData dataWithContentsOfFile:[bundle pathForResource:@"client" ofType:@"der"]];
    if (certData) {
        SecCertificateRef certificate = SecCertificateCreateWithData(NULL, (CFDataRef)certData);
        [certMap setObject:(__bridge id _Nonnull)(certificate) forKey:@"client"];
        CFRelease(certificate); // Avoid memory leaks
    } else {
        NSLog(@"[SSL] Error: Certificate file not found in the bundle.");
    }

    // Pass the certificates to the WebView implementation
    [RNCWebViewImpl setCustomCertificatesForHost:certMap];
}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
    return [self bundleURL];
}

- (NSURL *)bundleURL
{
#if DEBUG
    return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index"];
#else
    return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

- (BOOL)concurrentRootEnabled
{
#ifdef RN_FABRIC_ENABLED
    return true;
#else
    return false;
#endif
}

@end
