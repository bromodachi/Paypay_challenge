//
//  Resource.swift
//  CurrencyExchange
//
//  Created by Conrado Uraga on 2019/04/13.
//  Copyright © 2019 Conrado Uraga. All rights reserved.
//

import Foundation
typealias ErrorString = String
struct Resource<T> {
    typealias ParseResult = (T?, Bool, ErrorString?)
    let url: URL
    let parse: (Data) -> ParseResult
}
