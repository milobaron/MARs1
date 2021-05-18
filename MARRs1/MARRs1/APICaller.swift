//
//  APICaller.swift
//  MARRs1
//
//  Created by Mike Veson on 5/15/21.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private struct Constants {
        static let apiKey = "31EABC3C-EB7E-41D6-8D49-4AE02040EFD5"
        static let assetsEndpoint = "https://rest.coinapi.io/v1/assets/"
    }
    private init() {}
    
    public func getAllCryptoData(completion: @escaping (Result<[Crypto], Error>) -> Void) {
        guard let url = URL(string: Constants.assetsEndpoint + "?apikey="+Constants.apiKey) else {
           return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                // decode response
                let cryptos = try JSONDecoder().decode([Crypto].self, from: data)
                completion(.success(
                            cryptos.sorted {first, second -> Bool in
                                var new1 = first
                                var new2 = second
                    if (first.price_usd ?? 0 > 44000){
                        new1.price_usd = 0
                    }
                    if (second.price_usd ?? 0 > 44000){
                        new2.price_usd = 0
                    }
                                    return new1.price_usd ?? 0 > new2.price_usd ?? 0

                                }))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
   
}

