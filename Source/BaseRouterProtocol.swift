import UIKit

protocol BaseRouterProtocol {
    
    var splashVC: UIViewController { get }
    
    var rootVC: UIViewController { get }
    
    func openHome(animated: Bool, completion: @escaping () -> Void)        
}
