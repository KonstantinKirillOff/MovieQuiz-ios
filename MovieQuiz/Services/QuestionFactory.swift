//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Konstantin Kirillov on 06.11.2022.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    private let questions: [QuizeQuestion] = [
        QuizeQuestion(image: "The Godfather",
                      textQuestion: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: true,
                      rating: 9.2),
        QuizeQuestion(image: "The Dark Knight",
                      textQuestion: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: true,
                      rating: 9),
        QuizeQuestion(image: "Kill Bill",
                      textQuestion: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: true,
                      rating: 8.1),
        QuizeQuestion(image: "The Avengers",
                      textQuestion: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: true,
                      rating: 8),
        QuizeQuestion(image: "Deadpool",
                      textQuestion: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: true,
                      rating: 8),
        QuizeQuestion(image: "The Green Knight",
                      textQuestion: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: true,
                      rating: 6.6),
        QuizeQuestion(image: "Old",
                      textQuestion: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: false,
                      rating: 5.8),
        QuizeQuestion(image: "The Ice Age Adventures of Buck Wild",
                      textQuestion: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: false,
                      rating: 4.3),
        QuizeQuestion(image: "Tesla",
                      textQuestion: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: false,
                      rating: 5.1),
        QuizeQuestion(image: "Vivarium",
                      textQuestion: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: false,
                      rating: 5.8)
    ]
    
    func requestNextQuestion() -> QuizeQuestion? {
        guard let index = (0..<questions.count).randomElement() else {
            return nil
        }
        
        return questions[safe: index]
    }
    
}
