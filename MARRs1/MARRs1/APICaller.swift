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
        static let apiKey = "2AFC2D13-A14B-44CA-AD1E-A891C042EAB4"
        static let assetsEndpoint = "https://rest.coinapi.io/v1/assets/"
    }
    private init() {}
    
    public var icons: [Icon] = []
    
    private var whenReadyBlock: ((Result<[Crypto], Error>) -> Void)?
    
    public func getAllCryptoData
    (completion: @escaping (Result<[Crypto], Error>) -> Void) {
        guard icons.isEmpty else {
            whenReadyBlock = completion
            return
        }
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
                completion(.success( cryptos.sorted {first, second -> Bool in
                    return first.price_usd ?? 0 > second.price_usd ?? 0
                    
                }))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    public func getAllIcons(){
        guard let url = URL(string: "https://rest.coinapi.io/v1/assets/icons/55/?apikey=2AFC2D13-A14B-44CA-AD1E-A891C042EAB4")
        else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                // decode response
                self?.icons = try JSONDecoder().decode([Icon].self, from: data)
                if let completion = self?.whenReadyBlock {
                self?.getAllCryptoData(completion: completion)
                }
            }
            catch {
                print("RED ALERT MF \(error)")
            }
        }
        task.resume()
    }
    
    }

