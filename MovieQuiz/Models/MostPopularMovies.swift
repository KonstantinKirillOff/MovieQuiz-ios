//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Konstantin Kirillov on 18.11.2022.
//

import Foundation

enum ParseError: Error {
    case rankFailure
    case imDbRatingFailure
    case imageURLFailure
}

struct MostPopularMovies: Codable {
    let errorMessage: String
    let items: [MostPopularMovie]
}

struct MostPopularMovie: Codable {
    let title: String
    let rating: Float
    let imageURL: URL
    
    var resizedImageURL: URL {
        let urlString = imageURL.absoluteString
        let imageUrlString = urlString.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"
        
        guard let newURL = URL(string: imageUrlString) else {
            return imageURL
        }
        
        return newURL
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(String.self, forKey: .title)
        
        let rating = try container.decode(String.self, forKey: .rating)
        guard let rating = Float(rating) else {
            throw ParseError.rankFailure
        }
        self.rating = rating
        
        let image = try container.decode(String.self, forKey: .imageURL)
        guard let imageURL = URL(string: image) else {
            throw ParseError.imageURLFailure
        }
        self.imageURL = imageURL
    }
    
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
}
