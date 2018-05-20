import Foundation

struct QuestionMV {
    let identifier: String
    let question: String
    let imageUrl: URL
    let thumbUrl: URL
    let published: Date
    let choices: [Any]    
}
