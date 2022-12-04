import UIKit

final class MovieQuizViewController: UIViewController {
   
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var questionLabel: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService!
    private let presenter = MovieQuizePresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureElements()
        startActivityIndicator()
        
        presenter.viewController = self
        
        questionFactory = QuestionFactory(delegate: self, moviesLoader: MovieLoader())
        questionFactory?.loadData()
        
        alertPresenter = AlertPresenter(delegate: self)
        statisticService = StatisticServiceImplementation()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    @IBAction private func noButtonClicked() {
        presenter.currentQuestion = currentQuestion
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked() {
        presenter.currentQuestion = currentQuestion
        presenter.yesButtonClicked()
    }
}

extension MovieQuizViewController: QuestionFactoryDelegate {
    func didLoadDataFromServer() {
        showNextQuestion()
        stopActivityIndicator()
    }
    
    func didFailToLoadData(with error: Error) {
        stopActivityIndicator()
        hideBorder()
        
        let textError = presenter.getTextError(from: error)
        showNetworkError(message: textError)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        
        let quizStepViewModel = presenter.convert(model: question)
        stopActivityIndicator()
        hideBorder()
        show(quiz: quizStepViewModel)
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

private extension MovieQuizViewController {
    internal func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        
        if isCorrect {
            imageView.layer.borderColor = UIColor(named: "YP Green")?.cgColor
            presenter.addCorrectScore()
        } else {
            imageView.layer.borderColor = UIColor(named: "YP Red")?.cgColor
        }
        
        switchEnableForButtons()
        startActivityIndicator()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {
                return
            }
            self.showNextQuestionOrResult()
            self.switchEnableForButtons()
        }
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        questionLabel.text = step.question
    }
    
    func show(quiz result: QuizResultViewModel) {
        let alertModel = AlertModel(
                    title: result.title,
                    mesage: result.text,
                    buttonText: result.buttonText) { [weak self] in
                        guard let self = self else {
                            return
                        }
                        self.presenter.resetGameScores()
                        self.hideBorder()
                        self.questionFactory?.requestNextQuestion()
                    }
        alertPresenter?.prepearingDataAndDisplay(alertModel: alertModel)
    }
    
    func showNetworkError(message: String) {
        let alertModel = AlertModel(
                    title: "Что то пошло не так(",
                    mesage: message,
                    buttonText: "Попробовать еще раз") { [weak self] in
                        guard let self = self else {
                            return
                        }
                        self.hideBorder()
                        self.questionFactory?.loadData()
                    }
        alertPresenter?.prepearingDataAndDisplay(alertModel: alertModel)
    }
    
    func showNextQuestion() {
        questionFactory?.requestNextQuestion()
    }
    

    func showNextQuestionOrResult() {
        if presenter.isLastQuestion {
            statisticService.store(correct: presenter.correctAnswers, total: presenter.questionAmount)
            
            let bestGame = statisticService.bestGame
            let totalAccuracy = String(format: "%.2f", statisticService.totalAccuracy)
           
            let resultModel = QuizResultViewModel(
                title: "Раунд окончен!",
                text:
                """
                    Ваш результат: \(presenter.correctAnswers)/\(presenter.questionAmount)
                    Количество сыгранных квизов: \(statisticService.gameCount)
                    Рекорд: \(bestGame.correct)/\(bestGame.total)(\(bestGame.date.dateTimeString))
                    Средняя точность: \(totalAccuracy)%
                """,
                buttonText: "Сыграть еще раз")
            
            show(quiz: resultModel)
        } else {
            presenter.switchToNextQuestion()
            showNextQuestion()
        }
    }
    
    func switchEnableForButtons() {
        [noButton, yesButton].forEach { $0.isEnabled.toggle() }
    }
    
    func hideBorder() {
        imageView.layer.borderWidth = 0
    }
    
    func configureElements() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
    }
    
    func startActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
}

