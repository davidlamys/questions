import UIKit

class IPhoneRouter: BaseRouterProtocol {
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
        
    var splashVC: UIViewController {
        return StoryboardScene.Main.initialScene.instantiate()
    }
    
    var rootVC: UIViewController {
        return StoryboardScene.Main.root.instantiate()
    }
    
    func openHome(animated: Bool, completion: @escaping () -> Void) {
    }
}
