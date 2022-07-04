//
//  CoinData.swift
//  ByteCoin
//
//  Created by Ken Maready on 7/3/22.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation

struct CoinData: Codable {
    let time: Date
    let base: String
    let quote: String
    let rate: Double

    // set CodingKeys to allow renaming of properties
    // from names used in raw JSON
    enum CodingKeys: String, CodingKey {
        case time = "time"
        case base = "asset_id_base"
        case quote = "asset_id_quote"
        case rate = "rate"
    }
    
    static func fromJson(_ json: Data) -> CoinData? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.coinBaseISO8601)
        do {
            let decodedJson = try decoder.decode(CoinData.self, from: json)
            return decodedJson
        } catch {
            print("error encountered when parsing JSON to CoinData object: \(error)")
            return nil
        }
    }
}

extension DateFormatter {
    static let coinBaseISO8601: DateFormatter = {
        let formatter = DateFormatter()
        // 2022-07-03T14:41:29.0000000Z
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
