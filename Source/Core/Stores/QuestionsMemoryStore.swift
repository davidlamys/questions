import Foundation

class QuestionsMemoryStore: QuestionsStoreProtocol {
    
    var listing: ListingMV? 
    private var answers: [String: AnswerModel] = [:]
    
    func update(question: QuestionMV) {
        var answer: AnswerModel?
        if let answerIndex = question.answerIndex {
            answer = AnswerModel(questionIdentifier: question.identifier, answearIndex: answerIndex)
        }
        answers[question.identifier] = answer
        
        if var results = listing?.results, let questionIndex = results.index(of: question) {
            results[questionIndex] = question
            listing = listing?.newListing(withResults: results)
        }
    }
    
    func getAnswear(questionIdentifier: String) -> AnswerModel? {
        return answers[questionIdentifier]
    }
}
