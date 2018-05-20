import Foundation

struct ListingMV {
    let lastpage: Int
    let pageSize: Int
    let filter: String?
    let results: [QuestionMV]
    
    func newListing(withResults newResults: [QuestionMV]) -> ListingMV {
        return ListingMV(lastpage: lastpage,
                         pageSize: pageSize,
                         filter: filter,
                         results: newResults)
    }
}
