import Foundation
import Alamofire
import SwiftyJSON
import AlamofireSwiftyJSON
import CleanroomLogger

class ListingProvider: ListingRequest {
    var store: QuestionsStoreProtocol!
    
    func getPageQuestions(_ responder: ListingResponse, page: Int, filter: String?) {
        let pageSize = App.context.pageSize
        var endpoint = "questions?limit=\(pageSize)&offset=\(pageSize * page)"
        if let filter = filter {
            endpoint += "&filter=\(filter)"
        }
        
        let request = Alamofire.request(App.context.getURL(endpoint: endpoint)).responseSwiftyJSON { response in
            switch response.result {
            case .success(let json):
                self.handleSuccess(responder, page: page, filter: filter, json: json)
            case .failure(let error):
                Log.error?.message("Load page fail. Error: \(error)")
            }        
        }
        Log.debug?.message("Request:\n\(String(describing: request))")
    }
    
    private func handleSuccess(_ responder: ListingResponse, page: Int, filter: String?, json: JSON) {
        var pageResults: [QuestionMV] = []
        for (_, subJson): (String, JSON) in json {
            pageResults.append(QuestionMV.parseAndVerifyAnswer(json: subJson, store: self.store))
        }
    
        let pageQuestions = PageQuestionsModel(filter: filter,
                                               page: page,
                                               pageSize: App.context.pageSize,
                                               results: pageResults)
        let listing = self.getFinalListing(with: pageQuestions)
        self.store.update(listing: listing)
        responder.responseListQuestions(result: Result(value: listing))
    }
    
    private func getFinalListing(with pageQuestion: PageQuestionsModel) -> ListingMV {
        if pageQuestion.page == 0 {
            return ListingMV(page: pageQuestion)
        }
        
        if let listing = store.getFullListing() {
            return listing.merge(page: pageQuestion)
        }
        
        return ListingMV(page: pageQuestion)
    }
    
    func getUpdatedListQuestions(_ responder: ListingResponse) {
        guard let listing = store.getFullListing() else {
            getPageQuestions(responder, page: 0, filter: nil)
            return
        }
        
        responder.responseListQuestions(result: Result(value: listing))
    }
}
