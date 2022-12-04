////
////  MovieModel.swift
////  MovieQuiz
////
////  Created by Konstantin Kirillov on 12.11.2022.
////
//
//import Foundation
//
//enum ParseError: Error {
//    case yearFailure
//    case rankFailure
//    case imDbRatingFailure
//    case imageURLFailure
//}
//
//struct Actor: Codable {
//    let id: String
//    let image: String
//    let name: String
//    let asCharacter: String
//}
//
//struct MovieIMDB: Codable {
//    let id: String
//    let rank: Int
//    let title: String
//    let fullTitle: String
//    let year: Int
//    let image: String
//    let crew: String
//    let imDbRating: Float
//    let imDbRatingCount: String
//    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        
//        id = try container.decode(String.self, forKey: .id)
//        title = try container.decode(String.self, forKey: .title)
//        fullTitle = try container.decode(String.self, forKey: .title)
//        image = try container.decode(String.self, forKey: .image)
//        crew = try container.decode(String.self, forKey: .crew)
//        imDbRatingCount = try container.decode(String.self, forKey: .imDbRatingCount)
//        
//        let rank = try container.decode(String.self, forKey: .rank)
//        guard let rank = Int(rank) else {
//            throw ParseError.rankFailure
//        }
//        self.rank = rank
//        
//        let year = try container.decode(String.self, forKey: .year)
//        guard let year = Int(year) else {
//            throw ParseError.yearFailure
//        }
//        self.year = year
//        
//        let imDbRating = try container.decode(String.self, forKey: .imDbRating)
//        guard let imDbRating = Float(imDbRating) else {
//            throw ParseError.imDbRatingFailure
//        }
//        self.imDbRating = imDbRating
//    }
//    
//    enum CodingKeys: CodingKey {
//        case id, rank, title, fullTitle, year, image, crew, imDbRating, imDbRatingCount
//    }
//}
//
//struct Movies: Codable {
//    let items: [MovieIMDB]
//}
//
//
