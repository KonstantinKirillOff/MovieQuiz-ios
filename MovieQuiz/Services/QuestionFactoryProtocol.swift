//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Konstantin Kirillov on 07.11.2022.
//

import Foundation

protocol QuestionFactoryProtocol {
    func requestNextQuestion()
    func loadData()
}
