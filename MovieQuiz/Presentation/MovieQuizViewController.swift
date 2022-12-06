import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultViewModel)
    
    func showNetworkError(message: String)
    func showAnswerResult(isCorrect: Bool)
    func highLightImageBorder(isCorrectAnswer: Bool)
    func stopActivityIndicator()
    
}

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
   
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var questionLabel: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    private var alertPresenter: AlertPresenterProtocol?
    private var presenter: MovieQuizePresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureElements()
        startActivityIndicator()
        
        presenter = MovieQuizePresenter(viewController: self)
        alertPresenter = AlertPresenter(delegate: self)
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

extension MovieQuizViewController: AlertPresenterDelegate {
    func showAlert(alert: UIAlertController?) {
        guard let alert = alert else {
            return
        }
        hideBorder()
        present(alert, animated: true, completion: nil)
    }
}

extension MovieQuizViewController {
    func showAnswerResult(isCorrect: Bool) {
        presenter.didAnswer(isCorrectAnswer: isCorrect)
        highLightImageBorder(isCorrectAnswer: isCorrect)
        switchEnableForButtons()
        startActivityIndicator()
        presenter.showAnswerResultWithDelay()
        switchEnableForButtons()
    }
    
   func show(quiz step: QuizStepViewModel) {
        hideBorder()
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
                        self.presenter.resetGameScores()
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
    
    func highLightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        
        if isCorrectAnswer {
            imageView.layer.borderColor = UIColor(named: "YP Green")?.cgColor
        } else {
            imageView.layer.borderColor = UIColor(named: "YP Red")?.cgColor
        }
    }
}

