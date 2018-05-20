import Foundation
import Swinject
import SwinjectStoryboard

let assembler = Assembler(container: SwinjectStoryboard.defaultContainer)

extension SwinjectStoryboard {
    
    @objc
    class func setup() {
        registerStore(container: defaultContainer)
        registerActions(container: defaultContainer)
        registerViewControllers(container: defaultContainer)
    }
    
    static func registerStore(container: Container) {
        container.register(QuestionsStoreProtocol.self) { _ in
            return QuestionsMemoryStore()
        }.inObjectScope(.container)
    }
    
    static func registerActions(container: Container) {
        container.register(HealthStatusRequest.self) { _ in
            return HealthStatusDummyProvider()
        }
        
        container.register(ListingRequest.self) { register in
            let provider = ListingDummyProvider()
            provider.store = register.resolve(QuestionsStoreProtocol.self)
            return provider
        }
        
        container.register(QuestionRequest.self) { register in
            let provider = QuestionDummyProvider()
            provider.store = register.resolve(QuestionsStoreProtocol.self)
            return provider
        }
    }
    
    static func registerViewControllers(container: Container) {
        Container.loggingFunction = nil
        
        container.storyboardInitCompleted(LoadingVC.self, initCompleted: { register, viewController in
            viewController.healthRequest = register.resolve(HealthStatusRequest.self)!
        })
        
        container.storyboardInitCompleted(ListingVC.self, initCompleted: { register, viewController in
            viewController.listingRequest = register.resolve(ListingRequest.self)!
        })
        
        container.storyboardInitCompleted(DetailVC.self, initCompleted: { register, viewController in
            viewController.questionRequest = register.resolve(QuestionRequest.self)!
        })
    }
}
