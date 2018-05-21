import Foundation

struct ListingMV {
    let filter: String?
    let pageArray: PagedArray<QuestionMV>
    let lastUpdatedPage: Int? // This will tell wich page was refreshed
    
    static func empty() -> ListingMV {
        return ListingMV(pageArray: PagedArray<QuestionMV>(count: 0, pageSize: 0))
    }
    
    init(page: PageQuestions) {
        self.filter = page.filter
        var pageArray = PagedArray<QuestionMV>(count: 0, pageSize: page.pageSize)
        pageArray.updatesCountWhenSettingPages = true
        pageArray.set(page.results, forPage: page.page)
        self.pageArray = pageArray
        self.lastUpdatedPage = nil
    }
    
    init(pageArray: PagedArray<QuestionMV>, filter: String? = nil, lastUpdatedPage: Int? = nil) {
        self.pageArray = pageArray
        self.filter = filter
        self.lastUpdatedPage = lastUpdatedPage
    }
    
    func merge(page: PageQuestions) -> ListingMV {
        var newPageArray = pageArray
        newPageArray.set(page.results, forPage: page.page)
        return ListingMV(pageArray: newPageArray, filter: filter, lastUpdatedPage: page.page)
    }
    
    func newFullListing() -> ListingMV {
        return ListingMV(pageArray: pageArray, filter: filter)
    }
    
    var isEmpty: Bool {
        return pageArray.pageSize == 0
    }
}

struct PageQuestions {
    let filter: String?
    let page: Int
    let pageSize: Int
    let results: [QuestionMV]
}
