import UIKit
import CleanroomLogger

class IPhoneRouter: BaseRouterProtocol {
    let window: UIWindow
    private var activeLink: DeepLinkType?
    
    private var navigationController: UINavigationController? {
        return window.rootViewController as? UINavigationController
    }
    
    init(window: UIWindow) {
        self.window = window
    }
        
    var splashVC: UIViewController {
        return StoryboardScene.Main.initialScene.instantiate()
    }
    
    var rootVC: UIViewController {
        return StoryboardScene.Main.root.instantiate()
    }
    
    func openHome(animated: Bool) {
        navigationController?.popToRootViewController(animated: animated)
    }
    
    func changeReachability(isReachable: Bool) {
        // Warning:
        //  This is a quick solution to show lack of internet reachability
        //  but if there is other presentation controllers on the viewcontroller
        //  that could be an issue        
        let viewController = navigationController?.visibleViewController
        if isReachable {
            viewController?.dismiss(animated: true, completion: nil)
        } else {
            let alertViewController = UIAlertController(title: L10n.noConnectionTitle,
                                          message: L10n.noConnectionMessage,
                                          preferredStyle: .alert)
            viewController?.present(alertViewController, animated: true, completion: nil)
        }
    }
    
    func checkLink() {
        guard let activeLink = activeLink else {
            return
        }
        
        if let navigationController = navigationController {
            proceedToLink(activeLink, navigationController: navigationController)
            self.activeLink = nil
        } else {
            Log.verbose?.message("Waiting for splashscreen")
        }
    }
    
    func handleLink(url: URL) -> Bool {
        activeLink = LinkParser.parseLink(url)
        return activeLink != nil
    }
    
    private func proceedToLink(_ type: DeepLinkType, navigationController: UINavigationController) {
        navigationController.popToRootViewController(animated: false)
        let viewController = navigationController.viewControllers.first
        
        switch type {
        case .listing, .search:
            break
        case .detail(let questionIdentifier):
            let segue = StoryboardSegue.Main.showDetail.rawValue
            viewController?.performSegue(withIdentifier: segue, sender: questionIdentifier)
        }
    }
}
