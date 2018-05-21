import Foundation

class QuestionDummyProvider: QuestionRequest {
    var store: QuestionsStoreProtocol!
    
    func getQuestion(_ responder: QuestionResponse, identifier: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let question = QuestionMV(identifier: "1",
                                      question: "Favourite programming language?",
                                      imageUrl:
                "https://dummyimage.com/600x400/000/fff.png&text=question+1+image+(600x400)",
                                      thumbUrl:
                "https://dummyimage.com/120x120/000/fff.png&text=question+1+image+(120x120)",
                                      published: "",
                                      choices: [
                                        ChoiceMV(choice: "Swift", votes: 2048),
                                        ChoiceMV(choice: "Python", votes: 1024),
                                        ChoiceMV(choice: "Objective-C", votes: 512),
                                        ChoiceMV(choice: "Ruby", votes: 256)],
                                      answerIndex: 0)
            
            responder.responseQuestion(result: Result(value: question))
        }
    }
    
    func answerQuestion(_ responder: QuestionResponse, question: QuestionMV, answer: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            var newChoices = question.choices
            if let previousIndex = question.answerIndex {
                newChoices[previousIndex] = self.downvote(question.choices[previousIndex])
            }
            newChoices[answer] = self.upvote(question.choices[answer])
            let newQuestion = question.newQuestion(withAnswer: answer, newChoices: newChoices)
            self.store.update(question: newQuestion)
            responder.responseQuestion(result: Result(value: newQuestion))
        }
    }
    
    func removeAnswer(_ responder: QuestionResponse, question: QuestionMV) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            var newChoices = question.choices
            if let previousIndex = question.answerIndex {
                newChoices[previousIndex] = self.downvote(question.choices[previousIndex])
            }
            let newQuestion = question.newQuestion(withAnswer: nil, newChoices: newChoices)
            self.store.update(question: newQuestion)
            responder.responseQuestion(result: Result(value: newQuestion))
        }
    }
    
    private func upvote(_ choice: ChoiceMV) -> ChoiceMV {
        return ChoiceMV(choice: choice.choice, votes: choice.votes + 1)
    }
    
    private func downvote(_ choice: ChoiceMV) -> ChoiceMV {
        return ChoiceMV(choice: choice.choice, votes: Swift.max(0, choice.votes - 1))
    }
}
