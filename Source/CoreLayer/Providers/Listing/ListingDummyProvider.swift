import Foundation

class ListingDummyProvider: ListingRequest {
    var store: QuestionsStoreProtocol!
    
    func getPageQuestions(_ responder: ListingResponse, page: Int, filter: String?) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let results = [
                QuestionMV(identifier: "1",
                           question: "Favourite programming language?",
                           imageUrl: "https://dummyimage.com/600x400/000/fff.png&text=question+1+image+(600x400)",
                           thumbUrl: "https://dummyimage.com/120x120/000/fff.png&text=question+1+image+(120x120)",
                           published: "",
                           choices: [
                            ChoiceMV(choice: "Swift", votes: 2048),
                            ChoiceMV(choice: "Python", votes: 1024),
                            ChoiceMV(choice: "Objective-C", votes: 512),
                            ChoiceMV(choice: "Ruby", votes: 256)],
                           answerIndex: 0)
            ]
            
            let pageQuestions = PageQuestionsModel(filter: filter,
                                              page: page,
                                              pageSize: App.context.pageSize,
                                              results: results)
            let listing = ListingMV(page: pageQuestions)
            self.store.update(listing: listing)
            responder.responseListQuestions(result: Result(value: listing))
        }
    }
    
    func getUpdatedListQuestions(_ responder: ListingResponse) {
        guard let listing = store.getFullListing() else {
            getPageQuestions(responder, page: 0, filter: nil)
            return
        }
        
        responder.responseListQuestions(result: Result(value: listing))
    }
}
