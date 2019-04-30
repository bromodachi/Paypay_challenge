//
//  Response.swift
//  CurrencyExchange
//
//  Created by Conrado Uraga on 2019/04/13.
//  Copyright © 2019 Conrado Uraga. All rights reserved.
//

import Foundation
struct Response<T: Decodable>: Decodable {
    let success: Bool
    let terms: String?
    let privacy: String?
    let currencies: T?
    let quotes: T?
    let source: String?
    let info: String?
    let error: Error?
    enum CodingKeys: String, CodingKey {
        case success
        case terms
        case privacy
        case quotes
        case currencies
        case source
        case info
        case error
    }
    struct Error: Decodable {
        let code: Int
        let info: String
    }
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy:
            CodingKeys.self)
        success = try valueContainer.decode(Bool.self, forKey: Response.CodingKeys.success)
        terms = try? valueContainer.decode(String.self, forKey: Response.CodingKeys.terms)
        privacy = try? valueContainer.decode(String.self, forKey: Response.CodingKeys.privacy)
        source = try? valueContainer.decode(String.self, forKey: Response.CodingKeys.source)
        //TODO: Change this to be more dynamic
        currencies = try? valueContainer.decode(T.self, forKey: Response.CodingKeys.currencies)
        quotes = try? valueContainer.decode(T.self, forKey: Response.CodingKeys.quotes)
        error = try? valueContainer.decode(Error.self, forKey: Response.CodingKeys.error)
        info = self.error?.info 
    }
}
