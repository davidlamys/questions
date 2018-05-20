import UIKit

// Note:
//  Usually I use a different approach to register cells that allows for a certain type of model view to be associated
//  with a view and be config in a clean way. But this example it just has 1 cell type so I keep it simple.
//  Also, sometimes, I separate the content view so it could be used as a collection cell or table cell
//
class ListingVC: UIViewController, ListingResponse, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet private weak var tableView: UITableView!
    
    var listingRequest: ListingRequest!
    private var questions: [QuestionMV] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if questions.count == 0 {
            listingRequest.getListQuestions(self, page: 0, filter: nil)
        } else {
            listingRequest.getUpdatedListQuestions(self)
        }
    }
    
    func registerCells() {
        
        tableView.register(UINib(nibName: String(describing: QuestionCell.self), bundle: nil),
                           forCellReuseIdentifier: QuestionCell.reusableIdentifier)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QuestionCell.reusableIdentifier, for: indexPath)
        if let cell = cell as? ReusableViewProtocol {
            cell.config(model: questions[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        perform(segue: StoryboardSegue.Main.showDetail, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return QuestionCell.preferedSize.height
    }
    
    func responseListQuestions(result: Result<ListingMV, NoError>) {
        switch result {
        case .success(let listing):
            questions = listing.results
        case .failure:
            questions = []
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexpath = sender as? IndexPath, let destination = segue.destination as? DetailVC {
            destination.question = questions[indexpath.row]
        }
    }
}
