import Foundation

protocol QuestionsStoreProtocol {
    
    var listing: ListingMV? { get set }
    
    func update(question: QuestionMV)
    func getAnswear(questionIdentifier: String) -> AnswerModel?
}
