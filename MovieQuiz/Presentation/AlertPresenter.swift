//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Konstantin Kirillov on 08.11.2022.
//

import Foundation
import UIKit

struct AlertPresenter: AlertPresenterProtocol {
    weak var delegate: AlertPresenterDelegate?

    func preparingDataAndDisplay(alertModel: AlertModel) {
        let alertController = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        alertController.view.accessibilityIdentifier = "resultAlert"
        
        let alertAction = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            guard let completion = alertModel.completion else { return }
            completion()
        }
        
        alertController.addAction(alertAction)
        delegate?.showAlert(alert: alertController)
    }
   
}
