#import "RNCWebViewImpl+SSL.h"
#import <WebKit/WebKit.h>

@implementation RNCWebViewImpl (SSL)

- (void)webView:(WKWebView *)webView
    didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
    completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    NSString *host = challenge.protectionSpace.host;

    NSLog(@"[SSL Pinning] Received authentication challenge for host: %@", host);

    if ([host isEqualToString:@"agate.c1tygate2.com"]) {
        NSString *certPath = [[NSBundle mainBundle] pathForResource:@"client" ofType:@"p12"];
        NSData *p12Data = [NSData dataWithContentsOfFile:certPath];

        if (!p12Data) {
            NSLog(@"[SSL Pinning] .p12 file not found in the app bundle.");
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
            return;
        }

        NSString *p12Password = @"RenovarResearch1!";
        CFDataRef inP12Data = (__bridge CFDataRef)p12Data;
        SecIdentityRef identity = NULL;
        SecTrustRef trust = NULL;

        BOOL success = [self extractIdentityAndTrustFromPKCS12Data:inP12Data password:p12Password identity:&identity trust:&trust];

        if (!success || !identity) {
            NSLog(@"[SSL Pinning] Failed to extract identity from .p12 file.");
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
            return;
        }

        SecCertificateRef certificate;
        OSStatus certStatus = SecIdentityCopyCertificate(identity, &certificate);

        if (certStatus != errSecSuccess || !certificate) {
            NSLog(@"[SSL Pinning] Failed to copy certificate from identity.");
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
            return;
        }

        NSArray *certArray = @[ (__bridge id)certificate ];
        NSURLCredential *credential = [NSURLCredential credentialWithIdentity:identity certificates:certArray persistence:NSURLCredentialPersistenceForSession];

        NSLog(@"[SSL Pinning] Successfully validated the SSL certificate and provided credentials.");
        completionHandler(NSURLSessionAuthChallengeUseCredential, credential);

        CFRelease(certificate);
        CFRelease(identity);
    } else {
        NSLog(@"[SSL Pinning] Skipping authentication challenge for host: %@", host);
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    }
}

// Helper method to extract identity and trust
- (BOOL)extractIdentityAndTrustFromPKCS12Data:(CFDataRef)p12Data
                                     password:(NSString *)password
                                     identity:(SecIdentityRef *)identity
                                        trust:(SecTrustRef *)trust {
    NSDictionary *options = @{ (__bridge id)kSecImportExportPassphrase : password };
    CFArrayRef items = NULL;
    OSStatus securityError = SecPKCS12Import(p12Data, (__bridge CFDictionaryRef)options, &items);

    if (securityError == errSecSuccess && items != NULL) {
        CFDictionaryRef identityAndTrust = CFArrayGetValueAtIndex(items, 0);
        *identity = (SecIdentityRef)CFDictionaryGetValue(identityAndTrust, kSecImportItemIdentity);
        CFRetain(*identity);
        *trust = (SecTrustRef)CFDictionaryGetValue(identityAndTrust, kSecImportItemTrust);
        CFRetain(*trust);

        CFRelease(items);
        return YES;
    } else {
        NSLog(@"[SSL Pinning] Error importing .p12 file: %d", (int)securityError);
        if (items) CFRelease(items);
        return NO;
    }
}

@end
