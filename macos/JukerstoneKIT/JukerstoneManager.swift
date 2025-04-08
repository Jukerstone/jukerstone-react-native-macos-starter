import Foundation
import React

@objc public class JukerstoneBridgeManager: NSObject {
  private var bridge: RCTBridge?

  @objc public override init() {
    super.init()

    guard let jsBundle = Bundle.main.url(forResource: "main", withExtension: "jsbundle") else {
      print("❌ Could not find main.jsbundle")
      return
    }

    bridge = RCTBridge(bundleURL: jsBundle, moduleProvider: nil, launchOptions: nil)
  }

  @objc public func callJSMethod(_ method: String, args: [Any] = []) {
    let fullMethod = "global.JukerstoneBridge.\(method)"
    bridge?.enqueueJSCall(fullMethod, method: method, args: args, completion: nil)
  }
}
