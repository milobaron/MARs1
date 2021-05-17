//
//  NewsAPICaller.swift
//  MARRs1
//
//  Created by Mike Veson on 5/15/21.
//

import Foundation

final class NewsAPICaller {
    static let shared = NewsAPICaller()
    struct APIResponse: Codable {
        let articles: [Article]
    }
    struct Article: Codable {
        let source: Source
        let title: String
        let description: String?
        let url: String?
        let urlToImage: String?
        let publishedAt: String
    }
    struct Source: Codable {
        let name: String
    }
    struct Constants {
        static let topHeadlinesURL = URL(string: "https://newsapi.org/v2/everything?q=Apple&from=2021-05-16&sortBy=popularity&apiKey=8a4c432fe4d9472d9f4addbfc6eb5e1e")
    }
    private init() {}
    
    public func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = Constants.topHeadlinesURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                   
                    print("Articles \(result.articles.count)")
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

