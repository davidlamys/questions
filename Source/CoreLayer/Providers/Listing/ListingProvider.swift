import Foundation
import Alamofire
import SwiftyJSON
import AlamofireSwiftyJSON
import CleanroomLogger

class ListingProvider: ListingRequest {
    private let pageSize = 10
    var store: QuestionsStoreProtocol!
    
    func getListQuestions(_ responder: ListingResponse, page: Int, filter: String?) {
        var endpoint = "questions?limit=\(pageSize)&offset=\(pageSize * page)"
        if let filter = filter {
            endpoint += "&filter=\(filter)"
        }
        
        Alamofire.request(App.context.getURL(endpoint: endpoint)).responseSwiftyJSON { response in
            var results: [QuestionMV] = []
            if let json = response.result.value {
                for (_, subJson): (String, JSON) in json {
                    results.append(QuestionMV.parse(json: subJson, store: self.store))
                }
            }
            
            let listing = ListingMV(lastpage: page, pageSize: self.pageSize, filter: filter, results: results)
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
