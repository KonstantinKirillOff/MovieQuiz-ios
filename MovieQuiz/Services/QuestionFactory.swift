//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Konstantin Kirillov on 06.11.2022.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    
    weak var delegate: QuestionFactoryDelegate?
    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather",
                      textQuestion: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: true,
                      rating: 9.2),
        QuizQuestion(image: "The Dark Knight",
                      textQuestion: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: true,
                      rating: 9),
        QuizQuestion(image: "Kill Bill",
                      textQuestion: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: true,
                      rating: 8.1),
        QuizQuestion(image: "The Avengers",
                      textQuestion: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: true,
                      rating: 8),
        QuizQuestion(image: "Deadpool",
                      textQuestion: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: true,
                      rating: 8),
        QuizQuestion(image: "The Green Knight",
                      textQuestion: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: true,
                      rating: 6.6),
        QuizQuestion(image: "Old",
                      textQuestion: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: false,
                      rating: 5.8),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild",
                      textQuestion: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: false,
                      rating: 4.3),
        QuizQuestion(image: "Tesla",
                      textQuestion: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: false,
                      rating: 5.1),
        QuizQuestion(image: "Vivarium",
                      textQuestion: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: false,
                      rating: 5.8)
    ]
    
    init(delegate: QuestionFactoryDelegate?) {
        self.delegate = delegate
    }
    
    func requestNextQuestion() {
        guard let index = (0..<questions.count).randomElement() else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }
        
        let question = questions[safe: index]
        delegate?.didReceiveNextQuestion(question: question)
    }
    
}
