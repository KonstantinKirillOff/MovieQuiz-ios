import UIKit

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory = QuestionFactory.init(delegat: self)
        alertPresenter = AlertPresenter(delegat: self)
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
        alertPresenter?.prepearingDataForDisplay(alertModel: alertModel)
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
        noButton.isEnabled.toggle()
        yesButton.isEnabled.toggle()
    }
    
    private func showNextQuestionOrResult() {
        if currentQuestionIndex == questionAmmount - 1 {
            let resultModel = QuizRezultViewModel(
                title: "Раунд окончен!",
                text: correctAnswers == questionAmmount ? "Поздравляем, вы ответили на 10 из 10!" : "Ваш результат: \(correctAnswers)/\(questionAmmount)",
                buttonText: "Сыграть еще раз")
            
            show(quiz: resultModel)
        } else {
            currentQuestionIndex += 1
            showNextQuestion()
        }
    }
}

