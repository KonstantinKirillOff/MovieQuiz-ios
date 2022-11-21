//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Konstantin Kirillov on 06.11.2022.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    weak var delegate: QuestionFactoryDelegate?
    var questionCount: Int {
        //movies.count
        12
    }
    
    private let moviesLoader: MoviesLoading
    private var movies: [MostPopularMovie] = []
    
//   private let questions: [QuizQuestion]  = [
//        QuizQuestion(image: "The Godfather",
//                      textQuestion: "Рейтинг этого фильма больше чем 6?",
//                      correctAnswer: true,
//                      rating: 9.2),
//        QuizQuestion(image: "The Dark Knight",
//                      textQuestion: "Рейтинг этого фильма больше чем 6?",
//                      correctAnswer: true,
//                      rating: 9),
//        QuizQuestion(image: "Kill Bill",
//                      textQuestion: "Рейтинг этого фильма больше чем 6?",
//                      correctAnswer: true,
//                      rating: 8.1),
//        QuizQuestion(image: "The Avengers",
//                      textQuestion: "Рейтинг этого фильма больше чем 6?",
//                      correctAnswer: true,
//                      rating: 8),
//        QuizQuestion(image: "Deadpool",
//                      textQuestion: "Рейтинг этого фильма больше чем 6?",
//                      correctAnswer: true,
//                      rating: 8),
//        QuizQuestion(image: "The Green Knight",
//                      textQuestion: "Рейтинг этого фильма больше чем 6?",
//                      correctAnswer: true,
//                      rating: 6.6),
//        QuizQuestion(image: "Old",
//                      textQuestion: "Рейтинг этого фильма больше чем 6?",
//                      correctAnswer: false,
//                      rating: 5.8),
//        QuizQuestion(image: "The Ice Age Adventures of Buck Wild",
//                      textQuestion: "Рейтинг этого фильма больше чем 6?",
//                      correctAnswer: false,
//                      rating: 4.3),
//        QuizQuestion(image: "Tesla",
//                      textQuestion: "Рейтинг этого фильма больше чем 6?",
//                      correctAnswer: false,
//                      rating: 5.1),
//        QuizQuestion(image: "Vivarium",
//                      textQuestion: "Рейтинг этого фильма больше чем 6?",
//                      correctAnswer: false,
//                      rating: 5.8)
//    ]
    
    init(delegate: QuestionFactoryDelegate?, moviesLoader: MoviesLoading) {
        self.delegate = delegate
        self.moviesLoader = moviesLoader
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                switch result {
                case .success(let mostPopularMovies):
                        self.movies = mostPopularMovies.items
                        self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }

    func requestNextQuestion() {
        guard let index = (0..<movies.count).randomElement() else {
            self.delegate?.didReceiveNextQuestion(question: nil)
            return
        }
        guard let movie = movies[safe: index] else {
            self.delegate?.didReceiveNextQuestion(question: nil)
            return
        }

        DispatchQueue.global().async { [weak self] in
            guard let self = self else {
                return
            }
            do {
                let imageData = try Data(contentsOf: movie.resizedImageURL)
                let randomRating = Int.random(in: 4...9)
                let question = QuizQuestion(image: imageData,
                                            textQuestion: "Рейтинг фильма больще \(randomRating)",
                                            correctAnswer: movie.rating > Float(randomRating),
                                            rating: movie.rating)
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {
                        return
                    }
                    self.delegate?.didReceiveNextQuestion(question: question)
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {
                        return
                    }
                    self.delegate?.didFailToLoadData(with: NetworkError.filedLoadImage)
                }
            }
        }
    }
    
}
