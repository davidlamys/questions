import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions
                     launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        App.context.initialize(application: application)
        App.context.window.rootViewController = App.context.router.splashVC
        App.context.window.makeKeyAndVisible()
        return true
    }
}
