import UIKit

final class MovieQuizViewController: UIViewController {
   
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var questionLabel: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var questionFactory: QuestionFactoryProtocol?
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
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked() {
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
        stopActivityIndicator()
        hideBorder()
        presenter.didReceiveNextQuestion(question: question)
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
    func showAnswerResult(isCorrect: Bool) {
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
            self.presenter.questionFactory = self.questionFactory
            self.presenter.statisticService = self.statisticService
            self.presenter.showNextQuestionOrResult()
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
                        self.hideBorder()
                        self.presenter.resetGameScores()
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
    
    //MARK: Private functions
    private func switchEnableForButtons() {
        [noButton, yesButton].forEach { $0.isEnabled.toggle() }
    }
    
    private func hideBorder() {
        imageView.layer.borderWidth = 0
    }
    
    private func configureElements() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
    }
    
    private func startActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    private func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
}

