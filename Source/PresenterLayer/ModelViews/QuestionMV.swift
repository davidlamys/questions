import Foundation

struct QuestionMV: Codable {
    let identifier: String
    let question: String
    let imageUrl: String
    let thumbUrl: String
    let published: String
    let choices: [ChoiceMV]
    let answerIndex: Int?
    
    func newQuestion(withAnswer answer: Int?, newChoices: [ChoiceMV]) -> QuestionMV {
        return QuestionMV(identifier: identifier,
                          question: question,
                          imageUrl: imageUrl,
                          thumbUrl: thumbUrl,
                          published: published,
                          choices: newChoices,
                          answerIndex: answer)
    }
    
    func answerQuestion(answer: Int?) -> QuestionMV {
        var newChoices = choices
        if let previousIndex = answerIndex {
            newChoices[previousIndex] = choices[previousIndex].downvote()
        }
        if let answer = answer {
            newChoices[answer] = choices[answer].upvote()
        }
        return newQuestion(withAnswer: answer, newChoices: newChoices)
    }
}

extension QuestionMV: Equatable {
    
    static func == (lhs: QuestionMV, rhs: QuestionMV) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
