//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Konstantin Kirillov on 17.11.2022.
//

import Foundation

enum NetworkError: Error {
    case codeError
    case parseJsonError
    case filedLoadImage
}

struct NetworkClient {

    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Проверяем, пришла ли ошибка
            if let error = error {
                handler(.failure(error))
                return
            }
            
            // Проверяем, что нам пришёл успешный код ответа
            if let response = response as? HTTPURLResponse,
                response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }
            
            // Возвращаем данные
            guard let data = data else { return }
            handler(.success(data))
        }
        task.resume()
    }
}
