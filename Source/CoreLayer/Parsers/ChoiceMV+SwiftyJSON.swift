import Foundation
import SwiftyJSON
import Alamofire

extension ChoiceMV {
    
    static func parse(json: JSON) -> ChoiceMV {
        let choice = ChoiceMV(choice: json["choice"].stringValue,
                              votes: json["votes"].intValue)
        return choice
    }
    
    func generateJson() -> Parameters {
        let json: Parameters = ["choice": choice, "votes": votes]
        return json
    }
}
