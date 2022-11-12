//
//  StaticSirvice.swift
//  MovieQuiz
//
//  Created by Konstantin Kirillov on 12.11.2022.
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gameCount: Int { get }
    var bestGame: GameRecord { get }
}


final class StatisticServiceImplementation: StatisticService {
    
}
