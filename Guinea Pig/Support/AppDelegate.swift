

import UIKit

@available(iOS 13.0, *)
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.backgroundColor = .white
        let ctrl = UINavigationController(rootViewController: MainViewController())
        window?.rootViewController = ctrl
        window?.makeKeyAndVisible()
        return true
    }

}
