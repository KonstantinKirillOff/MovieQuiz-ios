import UIKit

final class MovieQuizViewController: UIViewController {
   
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var questionLabel: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var alertPresenter: AlertPresenterProtocol?
    private var presenter: MovieQuizePresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizePresenter(viewController: self)
        
        alertPresenter = AlertPresenter(delegate: self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    @IBAction private func noButtonClicked() {
        presenter?.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked() {
        presenter?.yesButtonClicked()
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
                        self.presenter.questionFactory?.requestNextQuestion()
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
                        self.presenter.resetGameScores()
                        self.presenter.questionFactory?.loadData()
                    }
        alertPresenter?.prepearingDataAndDisplay(alertModel: alertModel)
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
    
    func switchEnableForButtons() {
        [noButton, yesButton].forEach { $0.isEnabled.toggle() }
    }
    
    func hideBorder() {
        imageView.layer.borderWidth = 0
    }
}

