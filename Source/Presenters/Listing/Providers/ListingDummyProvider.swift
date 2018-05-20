import Foundation

class ListingDummyProvider: ListingRequest {
    var store: QuestionsStoreProtocol!
    
    func getListQuestions(_ responder: ListingResponse, page: Int, filter: String?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let results = [
                QuestionMV(identifier: "1",
                           question: "Favourite programming language?",
                           imageUrl: "https://dummyimage.com/600x400/000/fff.png&text=question+1+image+(600x400)",
                           thumbUrl: "https://dummyimage.com/120x120/000/fff.png&text=question+1+image+(120x120)",
                           published: Date(),
                           choices: [
                            ChoiceMV(choice: "Swift", votes: 2048),
                            ChoiceMV(choice: "Python", votes: 1024),
                            ChoiceMV(choice: "Objective-C", votes: 512),
                            ChoiceMV(choice: "Ruby", votes: 256)],
                           answerIndex: 0)
            ]
            
            let listing = ListingMV(lastpage: page, pageSize: 10, filter: filter, results: results)
            
            self.store.listing = listing
            responder.responseListQuestions(result: Result(value: listing))
        }
    }
    
    func getUpdatedListQuestions(_ responder: ListingResponse) {
        guard let listing = store.listing else {
            getListQuestions(responder, page: 0, filter: nil)
            return
        }
        
        responder.responseListQuestions(result: Result(value: listing))
    }
}
