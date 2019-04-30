//
//  Double+Extensions.swift
//  CurrencyExchange
//
//  Created by Conrado Uraga on 2019/04/14.
//  Copyright © 2019 Conrado Uraga. All rights reserved.
//

import Foundation
extension Double {
    func roundTo(places: Int) -> Double {
        let divide = pow(10.0, places.getDouble)
        return (self * divide).rounded() / divide
    }
}
