import Foundation

enum DeepLinkType {
    
    case listing
    case search(filter: String?)
    case detail(questionIdentifier: String)
}
