//
//  RatesManager.swift
//  RatesConverter
//
//  Created by Vladislav on 22.07.2021.
//

import Foundation

protocol RatesManagerDelegate {
    func didUpdateRates()
}

class RatesManager {
    var delegate: RatesManagerDelegate?
    
    var currencyCode: [String] = []
    var values: [Double] = []
    var currentRate: Double = 0.0
    
    func getRates() {
        guard let url = URL(string: "https://openexchangerates.org/api/latest.json?app_id=\(K.apiKey)") else {return}
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            
            guard let safeData = data else {return}
            
            do {
                let results = try JSONDecoder().decode(Rates.self, from: safeData)
                self.currencyCode.append(contentsOf: results.rates.keys)
                self.values.append(contentsOf: results.rates.values)
                self.delegate?.didUpdateRates()
            } catch {
                print(error)
                return
            }
        }.resume()
    }
}
