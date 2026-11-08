import UIKit
import Core

/// Chỗ gắn các hook cấp process: push token, deep link, background task, SDK cần `didFinishLaunching`.
/// Firebase + DI đã khởi tạo ở `BaseApp.init` nên ở đây chưa cần làm gì.
final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        Logger.info("didFinishLaunching env=\(Environment.name)", category: "App")
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // TODO: gửi token lên BE / FirebaseMessaging.apns token khi bật push.
    }
}
