import Foundation

class QuestionsMemoryStore: QuestionsStoreProtocol {
    // For this example we only support one active listing at a time
    private var activeListing: ListingMV?
    private var answers: [String: AnswerModel] = [:]
    
    func update(listing: ListingMV) {
        self.activeListing = listing.newFullListing()
    }
    
    func update(question: QuestionMV) {
        var answer: AnswerModel?
        if let answerIndex = question.answerIndex {
            answer = AnswerModel(questionIdentifier: question.identifier, answearIndex: answerIndex)
        }
        answers[question.identifier] = answer
        
        if let listing = activeListing {
            // if there is unique id's
            //updateFirstOccurence(listing: listing, question: question)
            
            // if there is chances of duplication
            updateAllOccurences(listing: listing, question: question)
        }
    }
    
    private func updateFirstOccurence(listing: ListingMV, question: QuestionMV) {
        if let questionIndex = listing.pageArray.index(of: question) {
            var pageArray = listing.pageArray
            pageArray[questionIndex] = question
            self.activeListing = ListingMV(pageArray: pageArray, filter: listing.filter)
        }
    }
    
    private func updateAllOccurences(listing: ListingMV, question: QuestionMV) {
        var pageArray = listing.pageArray
        for (index, value) in listing.pageArray.enumerated() where value == question {
            pageArray[index] = question
        }
        self.activeListing = ListingMV(pageArray: pageArray, filter: listing.filter)
    }
    
    func getAnswear(questionIdentifier: String) -> AnswerModel? {
        return answers[questionIdentifier]
    }
    
    func getFullListing() -> ListingMV? {
        return self.activeListing
    }
}
