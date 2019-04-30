//
//  URL+Extensions.swift
//  CurrencyExchange
//
//  Created by Conrado Uraga on 2019/04/13.
//  Copyright © 2019 Conrado Uraga. All rights reserved.
//

import Foundation
extension URL {
    public func withQueries(_ queries: [String: Any?]?) -> URL? {
        var components = URLComponents.init(url: self, resolvingAgainstBaseURL: true)
        guard let queries = queries else { return self }
        components?.queryItems = queries.compactMap{
            guard let value =  $0.1 else {
                return nil
            }
            return URLQueryItem.init(name: $0.0, value: "\(value)")
        }
        return components?.url
    }
}
