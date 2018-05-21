import UIKit
import AlamofireImage
import CleanroomLogger

class QuestionHeader: UITableViewHeaderFooterView, ReusableViewProtocol {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var choicesTitleLabel: UILabel!
    @IBOutlet private weak var questionIdLabel: UILabel!
    
    static var reusableIdentifier: String {
        return String(describing: self)
    }
    static var preferedSize: CGSize {
        return CGSize(width: 0, height: 300)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func reset() {
        imageView.image = nil
        questionLabel.text = nil
        questionIdLabel.text = nil
    }
    
    func config(model: Any) {
        reset()
        guard let question = model as? QuestionMV else {
            Log.error?.message("Wrong model")
            return
        }
        
        if let url = URL(string: question.imageUrl) {
            imageView.af_setImage(withURL: url)
        }
        questionLabel.text = String(question.question)
        questionIdLabel.text = L10n.questionIdentifier(question.identifier)
    }
}
