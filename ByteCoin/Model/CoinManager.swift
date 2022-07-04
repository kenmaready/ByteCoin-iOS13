//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateData(_: CoinData)
    func didFailWithError(_: Error)
}

struct CoinManager {
    var delegate: CoinManagerDelegate?
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    let apiKey = ProcessInfo.processInfo.environment["coinAPI_api_key"]
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String) {
        let url = baseURL + "\(currency)?apikey=\(apiKey ?? "")"
        performRequest(url)
    }

    func performRequest(_ urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            print("about to request data from: \(urlString)")
            let task = session.dataTask(with: url) {(data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                
                if let safeData = data {
                    if let coinData = CoinData.fromJson(safeData) {
                        print("coinData: \(coinData)")
                        self.delegate?.didUpdateData(coinData)
                    }
                }
            }
            
            task.resume()
        }
    }
    
}

