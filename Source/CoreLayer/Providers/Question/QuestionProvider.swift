import Foundation
import Alamofire
import SwiftyJSON
import AlamofireSwiftyJSON
import CleanroomLogger

class QuestionProvider: QuestionRequest {
    var store: QuestionsStoreProtocol!
    
    func getQuestion(_ responder: QuestionResponse, identifier: String) {
        let endpoint = "questions/\(identifier)"
        Alamofire.request(App.context.getURL(endpoint: endpoint)).responseSwiftyJSON { response in
            Log.debug?.message("Request:\n\(String(describing: response.request))")
            
            if let json = response.result.value {
                let question = QuestionMV.parse(json: json, store: self.store)
                responder.responseQuestion(result: Result(value: question))
            }
        }
    }
    
    func answerQuestion(_ responder: QuestionResponse, question: QuestionMV, answer: Int) {
        var newChoices = question.choices
        if let previousIndex = question.answerIndex {
            newChoices[previousIndex] = self.downvote(question.choices[previousIndex])
        }
        newChoices[answer] = self.upvote(question.choices[answer])
        let newQuestion = question.newQuestion(withAnswer: answer, newChoices: newChoices)
        
        notifyServer(question: newQuestion, responder: responder)
    }
    
    func removeAnswer(_ responder: QuestionResponse, question: QuestionMV) {
        var newChoices = question.choices
        if let previousIndex = question.answerIndex {
            newChoices[previousIndex] = self.downvote(question.choices[previousIndex])
        }
        let newQuestion = question.newQuestion(withAnswer: nil, newChoices: newChoices)
        notifyServer(question: newQuestion, responder: responder)
    }
    
    private func notifyServer(question: QuestionMV, responder: QuestionResponse) {
        let endpoint = "questions/\(question.identifier)"
        let parameters = question.generateParameters()
        let urlConvertible: URLConvertible = URL(string: App.context.getURL(endpoint: endpoint))!
        
        Alamofire.request(urlConvertible,
                          method: .put,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: [:]).responseSwiftyJSON { response in                            
                            Log.debug?.message("Request:\n\(String(describing: response.request))")
                            
                            if response.result.value != nil {
                                self.store.update(question: question)
                                responder.responseQuestion(result: Result(value: question))
                            }
        }
    }
    
    private func upvote(_ choice: ChoiceMV) -> ChoiceMV {
        return ChoiceMV(choice: choice.choice, votes: choice.votes + 1)
    }
    
    private func downvote(_ choice: ChoiceMV) -> ChoiceMV {
        return ChoiceMV(choice: choice.choice, votes: Swift.max(0, choice.votes - 1))
    }
}
