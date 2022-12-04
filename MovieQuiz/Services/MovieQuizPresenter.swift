//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Konstantin Kirillov on 04.12.2022.
//

import Foundation
import UIKit

final class MovieQuizePresenter {
    weak var viewController: MovieQuizViewController?
   
    var questionFactory: QuestionFactoryProtocol?
    var currentQuestion: QuizQuestion?
    var statisticService: StatisticService!
    
    let questionAmount: Int = 10
    
    var isLastQuestion: Bool {
        currentQuestionIndex == questionAmount - 1
    }
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        
        viewController.configureElements()
        viewController.startActivityIndicator()
        
        questionFactory = QuestionFactory(delegate: self, moviesLoader: MovieLoader())
        questionFactory?.loadData()
        
        statisticService = StatisticServiceImplementation()
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
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
    
    func showNextQuestionOrResult() {
        if isLastQuestion {
            statisticService.store(correct: correctAnswers, total: questionAmount)
            
            let bestGame = statisticService.bestGame
            let totalAccuracy = String(format: "%.2f", statisticService.totalAccuracy)
           
            let resultModel = QuizResultViewModel(
                title: "Раунд окончен!",
                text:
                """
                    Ваш результат: \(correctAnswers)/\(questionAmount)
                    Количество сыгранных квизов: \(statisticService.gameCount)
                    Рекорд: \(bestGame.correct)/\(bestGame.total)(\(bestGame.date.dateTimeString))
                    Средняя точность: \(totalAccuracy)%
                """,
                buttonText: "Сыграть еще раз")
            
            viewController?.show(quiz: resultModel)
        } else {
            switchToNextQuestion()
            showNextQuestion()
        }
    }
    
    func showNextQuestion() {
        questionFactory?.requestNextQuestion()
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
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let isCorrect = currentQuestion.correctAnswer == isYes
        viewController?.showAnswerResult(isCorrect: isCorrect)
    }
}

extension MovieQuizePresenter: QuestionFactoryDelegate {
    func didLoadDataFromServer() {
        showNextQuestion()
        viewController?.stopActivityIndicator()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.stopActivityIndicator()
        viewController?.hideBorder()
        
        let textError = getTextError(from: error)
        viewController?.showNetworkError(message: textError)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        viewController?.stopActivityIndicator()
        viewController?.hideBorder()
        
        guard let question = question else {
            return
        }
        currentQuestion = question
        
        let quizStepViewModel = convert(model: question)
        viewController?.show(quiz: quizStepViewModel)
    }
    
}

