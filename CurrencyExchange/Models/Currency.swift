//
//  Currencies.swift
//  CurrencyExchange
//
//  Created by Conrado Uraga on 2019/04/13.
//  Copyright © 2019 Conrado Uraga. All rights reserved.
//

import Foundation
struct Currency {
    //MARK: Properties
    let shortName: String
    let fullName: String
    //TODO: decide if we should use this or not?
    var quote: Quotes? = nil
    //MARK: Initialization
    init(keyValue: (String, String)) {
        self.shortName = keyValue.0
        self.fullName  = keyValue.1
    }
}
extension Currency {
    //MARK: Get currencies by creating a Resource that will return an array of currency
    static var getCurrencies: Resource<[Currency]>{
        return Resource<[Currency]>(url: APIBaseController.getURL(APIBaseController.BASE_URL , APIBaseController.Path.list.path), parse: { (data) -> ([Currency]?, Bool, ErrorString?) in
            guard let response = try? JSONDecoder().decode(Response<[String: String]>.self, from: data) else { return (nil, false, "Couldn't parse data.")}
            
            guard let currenciesDict = response.currencies else { return (nil, false, response.info ?? "Couldn't parse data.") }
            
            let currencies: [Currency] = currenciesDict.map { return Currency(keyValue: $0) }.sorted(by: { (a, b) -> Bool in
                return a.fullName < b.fullName
            })
            return (currencies, true, nil)
        })
    }
}
