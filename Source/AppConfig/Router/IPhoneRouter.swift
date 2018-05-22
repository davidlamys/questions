import UIKit
import CleanroomLogger

class IPhoneRouter: BaseRouterProtocol {
    let window: UIWindow
    private var activeLink: DeepLinkType?
    
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
        (window.rootViewController as? UINavigationController)?.popToRootViewController(animated: animated)
    }
    
    func checkLink() {
        guard let activeLink = activeLink else {
            return
        }
        
        if let navigationController = window.rootViewController as? UINavigationController {
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
