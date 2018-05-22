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
    var manager: NetworkReachabilityManager?
    let shouldUpdateWithServerData: Bool = true
    
    init() {
        
        window = UIWindow()
        router = IPhoneRouter(window: self.window)
        baseUrl = "https://private-anon-2f1663e894-blissrecruitmentapi.apiary-mock.com"
    }
    
    func initialize(application: UIApplication) {
        setupLogs()
        setupReachability()
        Log.info?.message("Reached the end of App initialization")
    }
    
    func getURL(endpoint: String) -> String {
        return "\(baseUrl)/\(endpoint)"
    }
    
    private func setupLogs() {
        #if DEBUG
        Log.enable(configuration: AppLogConfiguration(minimumSeverity: .debug))
        #else
        Log.enable(configuration: AppLogConfiguration(minimumSeverity: .error))
        #endif        
    }
    
    private func setupReachability() {
        guard manager == nil else {
            return
        }
        
        guard let newManager = NetworkReachabilityManager(host: String(baseUrl.dropFirst("https://".count))) else {
            Log.error?.message("Network Reachability failed init")
            return
        }
        
        newManager.listener = { status in
            Log.info?.message("Network Status Changed: \(status)")
            switch status {
            case .notReachable:
                self.router.onChangeReachability(isReachable: false)
            case .reachable, .unknown:
                self.router.onChangeReachability(isReachable: true)
            }
        }
            
        newManager.startListening()
        manager = newManager
    }
}
