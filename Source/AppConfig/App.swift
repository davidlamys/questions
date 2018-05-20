import UIKit
import CleanroomLogger
import UserNotifications

class App {
    static let context = App()

    let window: UIWindow
    let router: BaseRouterProtocol
    
    init() {
        
        window = UIWindow()
        router = IPhoneRouter(window: self.window)
    }
    
    func initialize(application: UIApplication) {
        setupLogs()
        Log.info?.message("Reached the end of App initialization")
    }
    
    private func setupLogs() {
        #if DEBUG
        Log.enable(configuration: AppLogConfiguration(minimumSeverity: .debug))
        #else
        Log.enable(configuration: AppLogConfiguration(minimumSeverity: .error))
        #endif        
    }
}
