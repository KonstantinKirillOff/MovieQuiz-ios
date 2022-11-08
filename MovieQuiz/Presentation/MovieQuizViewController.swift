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
    private let questionFactory: QuestionFactoryProtocol = QuestionFactory()
    private var currentQuestion: QuizeQuestion?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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


extension MovieQuizViewController {
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        questionLabel.text = step.question
    }
    
    private func show(quiz result: QuizRezultViewModel) {
        let alertController = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let actionButton = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.showNextQuestion()
        }
        
        alertController.addAction(actionButton)
        present(alertController, animated: true, completion: nil)
    }
    
    private func showNextQuestion() {
        self.imageView.layer.borderWidth = 0
       
        if let question = questionFactory.requestNextQuestion() {
            currentQuestion = question
            let quizStepViewModel = convert(model: question)
            show(quiz: quizStepViewModel)
        }
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

