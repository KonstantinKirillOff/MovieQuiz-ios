//
//  AlertPresenterDelegat.swift
//  MovieQuiz
//
//  Created by Konstantin Kirillov on 08.11.2022.
//

import Foundation
import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func showAlert(alert: UIAlertController?)
}
