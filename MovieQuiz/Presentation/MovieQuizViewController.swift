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
    
    private let questionAmmount = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizeQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory = QuestionFactory.init(delegat: self)
        alertPresenter = AlertPresenter(delegat: self)
        statisticService = StatisticServiceImplementation()
        showNextQuestion()
        
        //print(NSHomeDirectory()) Не понял, что делать с этим кодом, в итоге оставил пока как есть.
        let documentURLS = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let jsorURL = "top250MoviesIMDB.json"
        let newUrl = documentURLS.appendingPathComponent(jsorURL)
        if let data = try? Data(contentsOf: newUrl) {
            do {
                let movie = try JSONDecoder().decode(Movies.self, from: data)
                print(movie.items.prefix(5))
            } catch {
                print("Filed to parse")
            }
        }
        
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

extension MovieQuizViewController: QuestionFactoryDelegat {
    func didReceiveNextQuestion(question: QuizeQuestion?) {
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

extension MovieQuizViewController: AlertPresenterDelegat {
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
    
    private func show(quiz result: QuizRezultViewModel) {
        let alertModel = AlertModel(
                    title: result.title,
                    mesage: result.text,
                    buttonText: result.buttonText) { [weak self] in
                        guard let self = self else {
                            return
                        }
                        self.currentQuestionIndex = 0
                        self.correctAnswers = 0
                        self.questionFactory?.requestNextQuestion()
                    }
        alertPresenter?.prepearingDataAndDisplay(alertModel: alertModel)
    }
    
    private func showNextQuestion() {
        self.imageView.layer.borderWidth = 0
        questionFactory?.requestNextQuestion()
    }
    
    private func convert(model: QuizeQuestion) -> QuizStepViewModel {
            QuizStepViewModel(
                image: UIImage(named: model.image) ?? UIImage(),
                question: model.textQuestion,
                questionNumber: "\(currentQuestionIndex + 1)/\(questionAmmount)")
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
    
    private func switchEnableForButtons() {
        [noButton, yesButton].forEach { $0.isEnabled.toggle() }
    }
    
    private func showNextQuestionOrResult() {
        if currentQuestionIndex == questionAmmount - 1 {
            statisticService.store(correct: correctAnswers, total: questionAmmount)
            
            let bestGame = statisticService.bestGame
            let totalAccuracy = String(format: "%.2f", statisticService.totalAccuracy)
           
            let resultModel = QuizRezultViewModel(
                title: "Раунд окончен!",
                text:
                """
                    Ваш результат: \(correctAnswers)/\(questionAmmount)
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
}

