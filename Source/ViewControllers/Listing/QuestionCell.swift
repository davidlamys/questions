import UIKit
import CleanroomLogger
import AlamofireImage

class QuestionCell: UITableViewCell, ReusableViewProtocol {
    @IBOutlet private weak var questionImageView: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var topAnswerLabel: UILabel!
    @IBOutlet private weak var counterImageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    
    static var reusableIdentifier: String {
        return String(describing: self)
    }
    
    static var preferedSize: CGSize {
        return CGSize(width: 0, height: 110)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()        
    }
    
    func reset() {
        questionImageView.image = nil
        questionLabel.text = nil
        topAnswerLabel.text = nil
        counterLabel.text = "0"
    }
    
    func config(model: Any) {
        reset()
        guard let question = model as? QuestionMV else {
            Log.error?.message("Wrong model for cell")
            return
        }
        
        if let url = URL(string: question.imageUrl) {
            questionImageView.af_setImage(withURL: url)
        }
        questionLabel.text = question.question
        
        if let answerIndex = question.answerIndex {
            let myAnswer = question.choices[answerIndex]
            topAnswerLabel.text = L10n.yourAnswear(myAnswer.choice)
            counterLabel.text = String(myAnswer.votes)
            counterImageView.isHidden = false
            counterLabel.isHidden = false
        } else {
            topAnswerLabel.text = L10n.noAnswear
            counterImageView.isHidden = true
            counterLabel.isHidden = true
        }
    }
}
