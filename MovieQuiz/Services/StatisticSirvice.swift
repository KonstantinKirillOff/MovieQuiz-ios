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
    var total: Int { get }
    var correct: Int { get }
    
    func store(correct count: Int, total amount: Int)
}

final class StatisticServiceImplementation: StatisticService {
    let userDefaults = UserDefaults.standard
    
    private(set) var total: Int {
        get {
            userDefaults.integer(forKey: Keys.total.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    private(set) var correct: Int {
        get {
            userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
        
    var totalAccuracy: Double {
        get {
            return (total == 0) ? 0 : Double(correct) / Double(total) * 100
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
        let newPotentialRecord = GameRecord(correct: count,
                                            total: amount,
                                            date: Date())
        if bestGame < newPotentialRecord {
            bestGame = newPotentialRecord
        }
        
        total += amount
        correct += count
        gameCount += 1
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
