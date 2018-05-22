import UIKit
import AlamofireImage
import ToastSwiftFramework

class DetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate, QuestionResponse {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var tableView: UITableView!
    
    var questionRequest: QuestionRequest!
    var question: QuestionMV?
    var questionIdentifier: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        requestQuestionIfNeeded()
        reloadUI()
    }
    
    func reloadUI() {
        tableView.reloadData()
    }
    
    func requestQuestionIfNeeded() {
        if question == nil, let questionIdentifier = questionIdentifier {
            questionRequest.getQuestion(self, identifier: questionIdentifier)
        }
    }
    
    func registerCells() {
        
        tableView.register(UINib(nibName: String(describing: ChoiceCell.self), bundle: nil),
                           forCellReuseIdentifier: ChoiceCell.reusableIdentifier)
        tableView.register(UINib(nibName: String(describing: QuestionHeader.self), bundle: nil),
                           forHeaderFooterViewReuseIdentifier: QuestionHeader.reusableIdentifier)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let question = question else {
            return 0
        }
        return question.choices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChoiceCell.reusableIdentifier, for: indexPath)
        if let cell = cell as? ChoiceCell, let question = question {
            cell.config(model: question.choices[indexPath.row])
            cell.isSelected = (question.answerIndex == indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ChoiceCell.preferedSize.height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return QuestionHeader.preferedSize.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let question = question else {
            return nil
        }
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: QuestionHeader.reusableIdentifier)
        if let header = header as? QuestionHeader {
            header.config(model: question)
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let question = question {
            if question.answerIndex == indexPath.row {
                questionRequest.removeAnswer(self, question: question)
            } else {
                questionRequest.answerQuestion(self, question: question, answer: indexPath.row)
            }
        }
    }
    
    func responseQuestion(result: Result<QuestionMV, AnyError>) {
        switch result {
        case .success(let questionResponse):
            question = questionResponse
        case .failure:
            self.view.makeToast(L10n.unexepectedError)
        }
                
        reloadUI()
    }
}
