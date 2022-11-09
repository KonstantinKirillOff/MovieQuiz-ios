//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Konstantin Kirillov on 08.11.2022.
//

import Foundation

protocol QuestionFactoryDelegat: AnyObject {
    func didReceiveNextQuestion(question: QuizeQuestion?) 
}
