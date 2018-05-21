import Foundation
import SwiftyJSON
import Alamofire

extension QuestionMV {
    
    static func parse(json: JSON, store: QuestionsStoreProtocol) -> QuestionMV {
        let identifier = json["id"].stringValue
        var choices: [ChoiceMV] = []
        for (_, subJson): (String, JSON) in json["choices"] {
            choices.append(ChoiceMV.parse(json: subJson))
        }
        let question = QuestionMV(identifier: identifier,
                                  question: json["question"].stringValue,
                                  imageUrl: json["image_url"].stringValue,
                                  thumbUrl: json["thumb_url"].stringValue,
                                  published: json["published_at"].stringValue,
                                  choices: choices,
                                  answerIndex: store.getAnswear(questionIdentifier: identifier)?.answearIndex)
        return question
    }
    
    func generateJson() -> Parameters {
        
        var choicesJSON: [Parameters] = []
        for choice in choices {
            choicesJSON.append(choice.generateJson())
        }
        let json: Parameters = ["id": identifier,
                                "question": question,
                                "image_url": imageUrl,
                                "thumb_url": thumbUrl,
                                "published_at": published,
                                "choices": choicesJSON]
        return json
    }
}
