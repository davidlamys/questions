import UIKit
import CleanroomLogger
import UserNotifications
import Alamofire

class App {
    static let context = App()

    let window: UIWindow
    let router: BaseRouterProtocol
    
    // In this example I use only a base url, but a session manager is way more flexible and scalable
    let baseUrl: String
    let pageSize: Int = 10
    
    init() {
        
        window = UIWindow()
        router = IPhoneRouter(window: self.window)
        baseUrl = "https://private-anon-2f1663e894-blissrecruitmentapi.apiary-mock.com/"
    }
    
    func initialize(application: UIApplication) {
        setupLogs()
        Log.info?.message("Reached the end of App initialization")
    }
    
    func getURL(endpoint: String) -> String {
        return baseUrl + endpoint
    }
    
    private func setupLogs() {
        #if DEBUG
        Log.enable(configuration: AppLogConfiguration(minimumSeverity: .debug))
        #else
        Log.enable(configuration: AppLogConfiguration(minimumSeverity: .error))
        #endif        
    }
}
