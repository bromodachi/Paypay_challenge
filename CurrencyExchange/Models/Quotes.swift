//
//  Quotes.swift
//  CurrencyExchange
//
//  Created by Conrado Uraga on 2019/04/13.
//  Copyright © 2019 Conrado Uraga. All rights reserved.
//

import Foundation
import os.log

class Quotes: NSObject, NSCoding {
    //MARK: Properties
    
    let currency: String
    let rate: Double
    let source: String
    let date  : Date
    
    //MARK: Archiving Paths
    static let DOCUMENT_DIRECTORY = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ARCHIVE_URL        = DOCUMENT_DIRECTORY.appendingPathComponent("quotes")
    static func getArchiveUrlFor(_ name: String) -> URL {
        return DOCUMENT_DIRECTORY.appendingPathComponent("quotes_\(name)")
    }
    //MARK: Initialization
    init(source: String, keyValue: (String, Double), dateCreated: Date) {
        self.source = source
        if let range = keyValue.0.range(of: source) {
            self.currency = keyValue.0.replacingCharacters(in: range, with: "")
        }
        else {
            self.currency = keyValue.0
        }
        self.rate  = keyValue.1
        self.date = dateCreated
    }
    init(source: String, currency: String, rate: Double, date: Date) {
        self.source = source
        self.currency = currency
        self.rate  = rate
        self.date = date
    }
    //MARK: Property key for NSCoding
    private struct PropertyKey {
        static let currency = "currency"
        static let rate = "rate"
        static let source = "source"
        static let date = "date"
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(currency, forKey: PropertyKey.currency)
        aCoder.encode(rate, forKey: PropertyKey.rate)
        aCoder.encode(source, forKey: PropertyKey.source)
        aCoder.encode(date, forKey: PropertyKey.date)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let source = aDecoder.decodeObject(forKey: PropertyKey.source) as? String,
            let currency = aDecoder.decodeObject(forKey: PropertyKey.currency) as? String,
            let date = aDecoder.decodeObject(forKey: PropertyKey.date) as? Date else {
                return nil
        }
        let rate = aDecoder.decodeDouble(forKey: PropertyKey.rate)
        self.init(source: source, currency: currency, rate: rate, date: date)
    }
    
}
extension Quotes {
    //MARK: API call.
    static public func getQuoteFor(currency: Currency) ->  Resource<[Quotes]>{
        //TODO: source should be dynamic
        let url = APIBaseController.getURL(params: ["source": currency.shortName], APIBaseController.BASE_URL , APIBaseController.Path.live.path)
        return Resource<[Quotes]>(url: url, parse: { (data) -> ([Quotes]?, Bool, ErrorString?) in
            guard let response = try? JSONDecoder().decode(Response<[String: Double]>.self, from: data) else { return (nil, false, "Couldn't parse data.")}
            guard let source = response.source,
                let quotesDict = response.quotes else { return (nil, false, response.info ?? "Couldn't parse data") }
            let date = Date()
            //let's sort to always make the user not confused by the order
            let quotes: [Quotes] = quotesDict.map { return Quotes(source: source, keyValue: $0, dateCreated: date) }.sorted(by: { (a, b) -> Bool in
                return a.currency < b.currency
            })
            return (quotes, true, nil)
        })
    }
}
