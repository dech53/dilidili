import UIKit
import Flutter
@main
@objc class AppDelegate: FlutterAppDelegate {
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        GeneratedPluginRegistrant.register(with: self)
        
        // 获取 FlutterViewController
        if let controller = window?.rootViewController as? FlutterViewController {
            let clipboardChannel = FlutterMethodChannel(
                name: "app.clipboard",
                binaryMessenger: controller.binaryMessenger
            )
            
            clipboardChannel.setMethodCallHandler { [weak self] (call, result) in
                if call.method == "copyImage" {
                    if let args = call.arguments as? [String: Any],
                       let imageData = args["imageData"] as? FlutterStandardTypedData {
                        self?.copyImageToClipboard(data: imageData.data)
                        result("success")
                    } else {
                        result(FlutterError(code: "INVALID_ARGUMENT", message: "No image data provided", details: nil))
                    }
                } else {
                    result(FlutterMethodNotImplemented)
                }
            }
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func copyImageToClipboard(data: Data) {
        if let image = UIImage(data: data) {
            UIPasteboard.general.image = image
        }
    }
}