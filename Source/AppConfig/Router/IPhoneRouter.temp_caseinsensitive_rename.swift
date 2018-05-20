import UIKit

class IPhoneRouter BaseRootProtocol {
    
    var initialViewController: UIViewController { get }
    
    var rootViewController: UIViewController { get }
    
    var loginViewController: UIViewController { get }
    
    func logout()
    
    func openHome(animated: Bool, completion: @escaping () -> Void)
    
    func checkLink()
    
    func handleShortcut(item: String) -> Bool
    
    func handleLink(url: URL) -> Bool
    
    func handleRemoteNotification(_ notification: [AnyHashable: Any])
}
