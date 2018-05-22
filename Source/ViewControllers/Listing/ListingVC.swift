import UIKit

// Note:
//  Usually I use a different approach to register cells that allows for a certain type of model view to be associated
//  with a view and be config in a clean way. But this example it just has 1 cell type so I keep it simple.
//  Also, sometimes, I separate the content view so it could be used as a collection cell or table cell
//
class ListingVC: UIViewController, ListingResponse, UITableViewDataSource, UITableViewDelegate {    
    @IBOutlet private weak var tableView: UITableView!
    
    var listingRequest: ListingRequest!
    private var listing: ListingMV = ListingMV.empty()
    
    // Warning:
    //  We should use Operations or Observable to allow cancellation
    //  In this example will not implement cancellation wich leads to some problematic edge cases
    private var loadingOperations: Set<Int> = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if listing.isEmpty {
            loadDataForPage(0)
        } else {
            listingRequest.getUpdatedListQuestions(self)
        }
    }
    
    @IBAction func onRefresh(_ sender: Any) {
        clearListing()
        loadDataForPage(0)
    }
    
    func clearListing() {
        // Here we should cancel all possible loading pages on going
        loadingOperations.removeAll()
        listing = ListingMV.empty()
        tableView.reloadData()
    }
    
    private func registerCells() {
        
        tableView.register(UINib(nibName: String(describing: QuestionCell.self), bundle: nil),
                           forCellReuseIdentifier: QuestionCell.reusableIdentifier)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listing.pageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        loadMorePagesIfNeeded(forRow: (indexPath as NSIndexPath).row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: QuestionCell.reusableIdentifier, for: indexPath)
        if let cell = cell as? ReusableViewProtocol, let model = listing.pageArray[indexPath.row] {
            cell.config(model: model)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        perform(segue: StoryboardSegue.Main.showDetail, sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return QuestionCell.preferedSize.height
    }
    
    func responseListQuestions(result: Result<ListingMV, NoError>) {
        switch result {
        case .success(let listing):
            self.listing = listing
            tableView.reloadData()
            if let updatedPage = listing.lastUpdatedPage {
                loadingOperations.remove(updatedPage)
            } else {
                tableView.reloadData()
            }
        case .failure:
            break
        }
    }
    
    private func visibleIndexPathsForIndexes(_ indexes: CountableRange<Int>) -> [IndexPath]? {
        return tableView.indexPathsForVisibleRows?.filter { indexes.contains(($0 as NSIndexPath).row) }
    }
    
    private func needsLoadDataForPage(_ page: Int) -> Bool {
        if listing.pageArray.elements[page] != nil || loadingOperations.contains(page) {
            return false
        }
        
        let previousPage = page - 1
        if previousPage >= 0, let pageElements = listing.pageArray.elements[previousPage] {
            return pageElements.count == App.context.pageSize
        }
        
        return true
    }
    
    private func loadDataForPage(_ page: Int) {
        listingRequest.getPageQuestions(self, page: page, filter: self.listing.filter)
        loadingOperations.insert(page)
    }
    
    private func loadMorePagesIfNeeded(forRow row: Int) {
        let currentPage = listing.pageArray.page(for: row)
        if needsLoadDataForPage(currentPage) {
            loadDataForPage(currentPage)
        }
        
        let preloadIndex = row + App.context.pageSize / 2 // half page ahead
        if preloadIndex > listing.pageArray.endIndex {
            let preloadPage = currentPage + 1
            if needsLoadDataForPage(preloadPage) {
                loadDataForPage(preloadPage)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailVC {
            
            if let index = sender as? Int, let question = listing.pageArray[index] {
                destination.question = question
                return
            }
            
            if let questionIdentifier = sender as? String {
                destination.questionIdentifier = questionIdentifier
                return
            }
        }
    }
}
