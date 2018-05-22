import Foundation

class LinkParser {
    
    static func parseLink(_ url: URL) -> DeepLinkType? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true), let host = components.host else {
            return nil
        }
        
        guard host == "questions" else {
            return .listing
        }
        
        if let queryItem = components.queryItems?.first, let value = queryItem.value {
            switch queryItem.name {
            case "question_id":
                return .detail(questionIdentifier: value)
            default:
                break
            }
        }
        
        return .listing
    }
}
