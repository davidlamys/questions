import Foundation
import Swinject
import SwinjectStoryboard

let assembler = Assembler(container: SwinjectStoryboard.defaultContainer)

extension SwinjectStoryboard {
    
    @objc
    class func setup() {
        registerStore(container: defaultContainer)
        registerProviders(container: defaultContainer)
        registerViewControllers(container: defaultContainer)
    }
    
    static func registerStore(container: Container) {
        container.register(QuestionsStoreProtocol.self) { _ in
            return QuestionsMemoryStore()
        }.inObjectScope(.container)
    }
    
    static func registerProviders(container: Container) {
        container.register(HealthStatusRequest.self) { _ in
            //return HealthStatusDummyProvider()
            return HealthStatusProvider()
        }
        
        container.register(ListingRequest.self) { register in
            //let provider = ListingDummyProvider()
            let provider = ListingProvider()
            provider.store = register.resolve(QuestionsStoreProtocol.self)
            return provider
        }
        
        container.register(QuestionRequest.self) { register in
            //let provider = QuestionDummyProvider()
            let provider = QuestionProvider()
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
