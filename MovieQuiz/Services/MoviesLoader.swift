//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Konstantin Kirillov on 18.11.2022.
//

import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MovieLoader: MoviesLoading {
    private let networkClient: NetworkRouting
    private var mostPopularMovieURL: URL {
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_m1txwlqk") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    init(networkClient: NetworkRouting = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMovieURL) { result in
            switch result {
            case .success(let data):
                do {
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    if !mostPopularMovies.errorMessage.isEmpty {
                        handler(.failure(NetworkError.serverError(mostPopularMovies.errorMessage)))
                    } else {
                        handler(.success(mostPopularMovies))
                    }
                } catch let error {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}

