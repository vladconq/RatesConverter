//
//  RatesModel.swift
//  RatesConverter
//
//  Created by Vladislav on 21.07.2021.
//

import Foundation

struct Rates: Decodable {
    let rates: [String: Double]
}
