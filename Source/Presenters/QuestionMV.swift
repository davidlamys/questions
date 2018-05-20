import Foundation

struct QuestionMV {
    let identifier: String
    let question: String
    let imageUrl: String
    let thumbUrl: String
    let published: Date
    let choices: [ChoiceMV]
    let answerIndex: Int?
    
    func newQuestion(withAnswer newAnswer: Int?, newChoices: [ChoiceMV]) -> QuestionMV {
        return QuestionMV(identifier: identifier,
                          question: question,
                          imageUrl: imageUrl,
                          thumbUrl: thumbUrl,
                          published: published,
                          choices: newChoices,
                          answerIndex: newAnswer)
    }
}

extension QuestionMV: Equatable {
    
    static func == (lhs: QuestionMV, rhs: QuestionMV) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
