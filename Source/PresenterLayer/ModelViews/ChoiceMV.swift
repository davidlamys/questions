import Foundation

struct ChoiceMV: Codable {
    let choice: String
    let votes: Int
    
    func upvote() -> ChoiceMV {
        return ChoiceMV(choice: choice, votes: votes + 1)
    }
    
    func downvote() -> ChoiceMV {
        return ChoiceMV(choice: choice, votes: Swift.max(0, votes - 1))
    }
}
