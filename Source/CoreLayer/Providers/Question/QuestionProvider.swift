import Foundation
import Alamofire
import SwiftyJSON
import AlamofireSwiftyJSON
import CleanroomLogger

class QuestionProvider: QuestionRequest {
    var store: QuestionsStoreProtocol!
    
    func getQuestion(_ responder: QuestionResponse, identifier: String) {
        let endpoint = "questions/\(identifier)"
        let request = Alamofire.request(App.context.getURL(endpoint: endpoint)).responseSwiftyJSON { response in
            switch response.result {
            case .success(let json):
                let question = QuestionMV.parseAndVerifyAnswer(json: json, store: self.store)
                responder.responseQuestion(result: Result(value: question))
            case .failure(let error):
                Log.error?.message("Load page fail. Error: \(error)")
                responder.responseQuestion(result: Result<QuestionMV, AnyError>(error: AnyError(error)))
            }
        }
        Log.debug?.message("Request:\n\(String(describing: request))")
    }
    
    func answerQuestion(_ responder: QuestionResponse, question: QuestionMV, answer: Int) {
        let newQuestion = question.answerQuestion(answer: answer)
        let answerModel = AnswerModel(questionIdentifier: question.identifier,
                                      choice: question.choices[answer].choice,
                                      index: answer)
        notifyServer(question: newQuestion, answerModel: answerModel, responder: responder)
    }
    
    func removeAnswer(_ responder: QuestionResponse, question: QuestionMV) {
        let newQuestion = question.answerQuestion(answer: nil)
        notifyServer(question: newQuestion, answerModel: nil, responder: responder)
    }
    
    private func notifyServer(question: QuestionMV,
                              answerModel: AnswerModel?,
                              responder: QuestionResponse) {
        
        let endpoint = "questions/\(question.identifier)"
        let parameters = question.generateParameters()
        let urlConvertible: URLConvertible = URL(string: App.context.getURL(endpoint: endpoint))!
        
        let request = Alamofire.request(urlConvertible,
                                        method: .put,
                                        parameters: parameters,
                                        encoding: JSONEncoding.default,
                                        headers: [:]).responseSwiftyJSON { response in
                                            
                                            if App.context.shouldUpdateWithServerData {
                                                self.treatServerResponse(response: response,
                                                                         answerModel: answerModel,
                                                                         responder: responder)
                                            } else {
                                                self.treatIgnoringServerResponse(question: question,
                                                                                 response: response,
                                                                                 responder: responder)
                                            }
        }
        Log.debug?.message("Request:\n\(String(describing: request))")
    }
    
    private func treatServerResponse(response: Alamofire.DataResponse<SwiftyJSON.JSON>,
                                     answerModel: AnswerModel?,
                                     responder: QuestionResponse) {
        switch response.result {
        case .success(let json):
            
            // Note:
            // Here we are assuming that the change is only votes
            // A more robust parsing or handling should be done to prevent updates from structure of the question
            let serverQuestion = QuestionMV.parse(json: json, answerModel: answerModel)
            self.store.update(question: serverQuestion)
            
            responder.responseQuestion(result: Result(value: serverQuestion))
        case .failure(let error):
            Log.error?.message("Update question fail. Error: \(error)")
            responder.responseQuestion(result: Result<QuestionMV, AnyError>(error: AnyError(error)))
        }
    }
    
    private func treatIgnoringServerResponse(question: QuestionMV,
                                             response: Alamofire.DataResponse<SwiftyJSON.JSON>,
                                             responder: QuestionResponse) {
        switch response.result {
        case .success:
            
            // Warning:
            // For this to work with existent apiary, we will use this instead.
            // But the correct implementation is above
            self.store.update(question: question)
            responder.responseQuestion(result: Result(value: question))
        case .failure(let error):
            Log.error?.message("Update question fail. Error: \(error)")
            responder.responseQuestion(result: Result<QuestionMV, AnyError>(error: AnyError(error)))
        }
    }
}
