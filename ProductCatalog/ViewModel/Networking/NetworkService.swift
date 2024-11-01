//
//  NetworkServise.swift
//  ProductCatalog
//
//  Created by Dmitriy Eliseev on 28.10.2024.
//

import Foundation

final class NetworkService {
    private let session: URLSession
    
    //настройка с URLSession с параметрами таймаута
    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        session = URLSession(configuration: config)
    }
    
    //универсальная функция для запроса данных в сети через URL -> Result<Data, Error>
    func fetch(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "URLError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL: \(urlString)"])))
            return
        }
        self.session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching products: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "ResponseError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                let statusCodeError = NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP Error: \(httpResponse.statusCode)"])
                completion(.failure(statusCodeError))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "DataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data returned"])))
                return
            }
            completion(.success(data))
        }.resume()
    }
}
