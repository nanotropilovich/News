//
//  NetworkManager.swift
//  tinkoffNews
//
//  Created by Ilya on 05.02.2023.
//
import Foundation
class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    func fetchData(from urlString: String, with complition: @escaping (News) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error { print(error); return }
            guard let data = data else { return }
            do {
                let news = try JSONDecoder().decode(News.self, from: data)
                complition(news)
            } catch let jsonError {
                print(jsonError.localizedDescription)
            }
        }.resume()
    }
}
class ImageManager {
    static let shared = ImageManager()
    private init() {}
    func getImage(from url: URL, comletion: @escaping (Data, URLResponse) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            guard let data = data, let response = response else { return }
            guard let responseURL = response.url else { return }
            guard responseURL == url else { return }
            comletion(data, response)
        }.resume()
    }
}
