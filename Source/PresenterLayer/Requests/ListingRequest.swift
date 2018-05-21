import Foundation

protocol ListingRequest {
    
    func getPageQuestions(_ responder: ListingResponse, page: Int, filter: String?)
    
    func getUpdatedListQuestions(_ responder: ListingResponse)
}

protocol ListingResponse {
    
    func responseListQuestions(result: Result<ListingMV, NoError>)
}
