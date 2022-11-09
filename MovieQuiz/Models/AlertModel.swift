//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Konstantin Kirillov on 08.11.2022.
//

import Foundation
import UIKit

struct AlertModel {
    let title: String
    let mesage: String
    let buttonText: String
    let completion: (() -> Void)?
}
