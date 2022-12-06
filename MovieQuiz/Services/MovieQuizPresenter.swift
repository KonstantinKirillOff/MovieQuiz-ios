//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Konstantin Kirillov on 04.12.2022.
//

import UIKit

final class MovieQuizePresenter {
    private weak var viewController: MovieQuizViewControllerProtocol?
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private let statisticService: StatisticService!
    
    let questionAmount: Int = 10
    var isLastQuestion: Bool {
        currentQuestionIndex == questionAmount - 1
    }
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        statisticService = StatisticServiceImplementation()
        
        questionFactory = QuestionFactory(delegate: self, moviesLoader: MovieLoader())
        questionFactory?.loadData()
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
        questionFactory?.requestNextQuestion()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
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
    
    func showAnswerResultWithDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {
                return
            }
            self.showNextQuestionOrResult()
        }
    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
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
        
        let textError = getTextError(from: error)
        viewController?.showNetworkError(message: textError)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        viewController?.stopActivityIndicator()
        
        guard let question = question else {
            return
        }
        currentQuestion = question
        
        let quizStepViewModel = convert(model: question)
        viewController?.show(quiz: quizStepViewModel)
    }
    
}

