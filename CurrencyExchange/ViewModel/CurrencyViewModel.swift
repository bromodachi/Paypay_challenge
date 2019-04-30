//
//  CurrencyViewModel.swift
//  CurrencyExchange
//
//  Created by Conrado Uraga on 2019/04/13.
//  Copyright © 2019 Conrado Uraga. All rights reserved.
//

import Foundation

/// Model that holds the list of currencies
struct CurrencyViewModel {
    //MARK: Initialization
    private(set) var currencies: [Currency]
    var currentSelected: Currency {
        didSet {
            didSetNotify(currentSelected)
        }
    }
    public var didSetNotify: (Currency)->()
}
extension CurrencyViewModel {
    //MARK: TableView datasource
    public var numberOfSections: Int { return 1 }
    public var numberOfItemsInSection: Int { return self.currencies.count }
    //MARK: Get model related info
    public func currencyAt(index: Int) -> Currency {
        return self.currencies[index]
    }
}
