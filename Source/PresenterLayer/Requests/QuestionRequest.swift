import Foundation

protocol QuestionRequest {
    
    func getQuestion(_ responder: QuestionResponse, identifier: String)
    
    func answerQuestion(_ responder: QuestionResponse, question: QuestionMV, answer: Int)
    
    func removeAnswer(_ responder: QuestionResponse, question: QuestionMV)
}

protocol QuestionResponse {
    
    func responseQuestion(result: Result<QuestionMV, AnyError>)
}
