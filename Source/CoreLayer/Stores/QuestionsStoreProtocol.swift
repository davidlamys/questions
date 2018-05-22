import Foundation

protocol QuestionsStoreProtocol {
    
    func update(listing: ListingMV)
    func update(question: QuestionMV)
    
    func getAnswear(questionIdentifier: String) -> AnswerModel?
    func getFullListing() -> ListingMV?
    
    func deleteAnswer(questionIdentifier: String)
}
