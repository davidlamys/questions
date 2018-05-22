import Foundation
import SwiftyJSON
import Alamofire

extension QuestionMV {
    
    static func parse(json: JSON, answerModel: AnswerModel?) -> QuestionMV {
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
                                  answerIndex: updatedAnswer(identifier, choices: choices, answerModel: answerModel))
        return question
    }
    
    static func parseAndVerifyAnswer(json: JSON, store: QuestionsStoreProtocol) -> QuestionMV {
        let identifier = json["id"].stringValue
        let answerModel = store.getAnswear(questionIdentifier: identifier)
        let question = QuestionMV.parse(json: json, answerModel: answerModel)
        if answerModel != nil && question.answerIndex == nil {
            store.deleteAnswer(questionIdentifier: identifier)
        }
        return question
    }
    
    private static func updatedAnswer(_ identifier: String,
                                      choices: [ChoiceMV],
                                      answerModel: AnswerModel?) -> Int? {
        guard let answerModel = answerModel else {
            return nil
        }
        
        if answerModel.index < choices.count && answerModel.choice == choices[answerModel.index].choice {
            return answerModel.index
        }
        return nil
    }
    
    func generateParameters() -> Parameters {
        
        var choicesJSON: [Parameters] = []
        for choice in choices {
            choicesJSON.append(choice.generateParameters())
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
