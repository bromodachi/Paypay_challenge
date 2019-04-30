//
//  QuotesViewModel.swift
//  CurrencyExchange
//
//  Created by Conrado Uraga on 2019/04/13.
//  Copyright © 2019 Conrado Uraga. All rights reserved.
//

import Foundation
import os.log

/// Model that holds the rates.
struct QuotesViewModel {
    //MARK: Initialization
    private(set) var quotes: [Quotes]
    public var getDate: Date? {
        return quotes.first?.date
    }
}
extension QuotesViewModel {
    //MARK: Persistent data
    /// Writes to disk not using a secure coding(to simplify things).
    public func writeToDisk(){
        guard let firstQuote = quotes.first else { return }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: quotes, requiringSecureCoding: false)
            try data.write(to: Quotes.getArchiveUrlFor(firstQuote.source), options: .atomic)
        } catch {
            os_log("Error has occurred...couldn't save", log: OSLog.default, type: .error)
        }
    }
    
    /// Loads the currency rate for a given currency. If it's not within 30 minutes or if we don't have any new data, this return false
    ///
    /// - Parameter currency: the currency you wish to focus on
    /// - Returns: false if not within 30 minutes or if we have no quotes(aka, we never searched for that currency before). True otherwise.
    public mutating func loadFromDisk(currency: Currency)-> Bool {
        do {
            let data = try Data.init(contentsOf: Quotes.getArchiveUrlFor(currency.shortName))
            if let quotes =  try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Quotes],
                let quote = quotes.first,
                (Date().timeIntervalSince(quote.date) / 60) <= 29.999
            {
                self.quotes = quotes
                return true
            }
            return false
        } catch  {
            os_log("Was loaded", log: OSLog.default, type: .error)
        }
        return false
    }
    //MARK: Collection View datasource functions
    public var numberOfSections: Int { return 0 }
    public var numberOfItemsInSection: Int { return self.quotes.count }
    
    //MARK: access data
    public func currencyAt(index: Int) -> Quotes {
        return self.quotes[index]
    }
}
