import UIKit

protocol ReusableViewProtocol {
    
    static var reusableIdentifier: String { get }
    static var preferedSize: CGSize { get }
    
    func config(model: Any)
}
