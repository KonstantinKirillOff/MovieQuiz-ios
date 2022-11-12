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
    
    func store(correct count: Int, total amount: Int)
}


final class StatisticServiceImplementation: StatisticService {
    let userDefaults = UserDefaults.standard
        
    var totalAccuracy: Double {
        get {
            let totalAllTime = userDefaults.integer(forKey: Keys.total.rawValue)
            let correctAllTime = userDefaults.integer(forKey: Keys.correct.rawValue)
            return (totalAllTime == 0) ? 0 : Double(correctAllTime) / Double(totalAllTime) * 100
        }
    }
    
    private(set) var gameCount: Int {
        get {
            return userDefaults.integer(forKey: Keys.gameCount.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.gameCount.rawValue)
        }
    }
    
    private(set) var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            
            return record
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить данные")
                return
            }
            
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }

    func store(correct count: Int, total amount: Int) {
        var totalAllTime = userDefaults.integer(forKey: Keys.total.rawValue)
        totalAllTime += amount
        
        var correctAllTime = userDefaults.integer(forKey: Keys.correct.rawValue)
        correctAllTime += count
        gameCount += 1
        
        let newPotentialRecord = GameRecord(correct: count,
                                            total: amount,
                                            date: Date())
        if bestGame < newPotentialRecord {
            guard let data = try? JSONEncoder().encode(newPotentialRecord) else {
                print("Невозможно сохранить данные")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
        
        userDefaults.set(totalAllTime, forKey: Keys.total.rawValue)
        userDefaults.set(correctAllTime, forKey: Keys.correct.rawValue)
        userDefaults.set(gameCount, forKey: Keys.gameCount.rawValue)
    }
    
    private enum Keys: String {
        case correct, total, bestGame, gameCount
    }
}

struct GameRecord: Comparable, Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        lhs.correct < rhs.correct
    }
}
