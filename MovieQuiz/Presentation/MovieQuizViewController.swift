import UIKit

enum ParseError: Error {
    case yearFailure
    case rankFailure
    case imDbRatingFailure
}

final class MovieQuizViewController: UIViewController {
   
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var questionLabel: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    
    private let questionAmount = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory = QuestionFactory.init(delegate: self)
        alertPresenter = AlertPresenter(delegate: self)
        statisticService = StatisticServiceImplementation()
        showNextQuestion()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    @IBAction private func noButtonClicked() {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let isCorrect = currentQuestion.correctAnswer == false
        showAnswerResult(isCorrect: isCorrect)
    }
    
    @IBAction private func yesButtonClicked() {
        guard let currentQuestion = currentQuestion else {
            return
        }

        let isCorrect = currentQuestion.correctAnswer == true
        showAnswerResult(isCorrect: isCorrect)
    }
}

extension MovieQuizViewController: QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let quizStepViewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: quizStepViewModel)
        }
    }
}

extension MovieQuizViewController: AlertPresenterDelegate {
    func showAlert(alert: UIAlertController?) {
        guard let alert = alert else {
            return
        }
        present(alert, animated: true, completion: nil)
    }
}


extension MovieQuizViewController {
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        questionLabel.text = step.question
    }
    
    private func show(quiz result: QuizResultViewModel) {
        let alertModel = AlertModel(
                    title: result.title,
                    mesage: result.text,
                    buttonText: result.buttonText) { [weak self] in
                        guard let self = self else {
                            return
                        }
                        self.currentQuestionIndex = 0
                        self.correctAnswers = 0
                        self.hideBorder()
                        self.questionFactory?.requestNextQuestion()
                    }
        alertPresenter?.prepearingDataAndDisplay(alertModel: alertModel)
    }
    
    private func showNextQuestion() {
        hideBorder()
        questionFactory?.requestNextQuestion()
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
            QuizStepViewModel(
                image: UIImage(named: model.image) ?? UIImage(),
                question: model.textQuestion,
                questionNumber: "\(currentQuestionIndex + 1)/\(questionAmount)")
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        
        if isCorrect {
            imageView.layer.borderColor = UIColor(named: "YP Green")?.cgColor
            correctAnswers += 1
        } else {
            imageView.layer.borderColor = UIColor(named: "YP Red")?.cgColor
        }
        
        switchEnableForButtons()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResult()
            self.switchEnableForButtons()
        }
    }
    
    private func showNextQuestionOrResult() {
        if currentQuestionIndex == questionAmount - 1 {
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
            
            show(quiz: resultModel)
        } else {
            currentQuestionIndex += 1
            showNextQuestion()
        }
    }
    
    private func switchEnableForButtons() {
        [noButton, yesButton].forEach { $0.isEnabled.toggle() }
    }
    
    private func hideBorder() {
        imageView.layer.borderWidth = 0
    }
}

