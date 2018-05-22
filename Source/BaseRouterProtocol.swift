import UIKit

protocol BaseRouterProtocol {
    
    var splashVC: UIViewController { get }
    
    var rootVC: UIViewController { get }
    
    func openHome(animated: Bool)
    
    func checkLink()
    
    func handleLink(url: URL) -> Bool
}
