//
//  MovieQuizPresenterTests.swift
//  MovieQuizTests
//
//  Created by Konstantin Kirillov on 07.12.2022.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerProtocolMock: MovieQuizViewControllerProtocol {
    func stopActivityIndicator() {}
    
    func show(quiz step: QuizStepViewModel) {}
    
    func show(quiz result: QuizResultViewModel) {}
    
    func showNetworkError(message: String) {}
    
    func showAnswerResult(isCorrect: Bool) {}
    
    func highLightImageBorder(isCorrectAnswer: Bool) {}
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerProtocolMock()
        let presenter = MovieQuizePresenter(viewController: viewControllerMock)
        
        let quizQuestion = QuizQuestion(image: Data(),
                                        textQuestion: "Question text",
                                        correctAnswer: true,
                                        rating: 8)
        let quizQuestionViewModel = presenter.convert(model: quizQuestion)
        
        XCTAssertNotNil(quizQuestionViewModel.image)
        XCTAssertTrue(quizQuestionViewModel.question == "Question text")
        XCTAssertEqual(quizQuestionViewModel.questionNumber, "1/10")
    }
}
