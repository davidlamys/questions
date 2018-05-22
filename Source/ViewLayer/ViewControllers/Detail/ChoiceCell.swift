import Foundation
import UIKit
import CleanroomLogger

class ChoiceCell: UITableViewCell, ReusableViewProtocol {
    @IBOutlet private weak var choiceLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    
    static var reusableIdentifier: String {
        return String(describing: self)
    }
    
    static var preferedSize: CGSize {
        return CGSize(width: 0, height: 34)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func reset() {
        choiceLabel.text = nil
        counterLabel.text = "0"
    }
    
    func config(model: Any) {
        reset()
        guard let choice = model as? ChoiceMV else {
            Log.error?.message("Wrong model for cell")
            return
        }
        choiceLabel.text = choice.choice
        counterLabel.text = String(choice.votes)
    }
    
    override var isSelected: Bool {
        didSet {
            accessoryType = isSelected ? .checkmark : .none
        }
    }
}
