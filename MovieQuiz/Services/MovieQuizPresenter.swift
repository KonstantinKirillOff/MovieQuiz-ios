//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Konstantin Kirillov on 04.12.2022.
//

import Foundation
import UIKit

final class MovieQuizePresenter {
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    
    private var currentQuestionIndex: Int = 0
    private(set) var correctAnswers: Int = 0
    
    let questionAmount: Int = 10
    
    var isLastQuestion: Bool {
        currentQuestionIndex == questionAmount - 1
    }
    
    func noButtonClicked() {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let isCorrect = currentQuestion.correctAnswer == false
        viewController?.showAnswerResult(isCorrect: isCorrect)
    }
    
    func yesButtonClicked() {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let isCorrect = currentQuestion.correctAnswer == true
        viewController?.showAnswerResult(isCorrect: isCorrect)
    }
    
    func resetGameScores() {
        currentQuestionIndex = 0
        correctAnswers = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func addCorrectScore() {
        correctAnswers += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.textQuestion,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionAmount)"
        )
    }
    
    func getTextError(from error: Error) -> String {
        var textError = ""
        if let error = error as? NetworkError {
            switch error {
            case .serverError(let description):
                textError = description
            default:
                textError = error.localizedDescription
            }
        } else {
            textError = error.localizedDescription
        }
        
        return textError
    }
}

