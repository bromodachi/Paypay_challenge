//
//  Environment.swift
//  CurrencyExchange
//
//  Created by Conrado Uraga on 2019/04/13.
//  Copyright © 2019 Conrado Uraga. All rights reserved.
//

import Foundation
// This class helps with what url to point to. Although not used in this app, I just added it since standard practice
public final class Environment {
    public static let `default`: Environment = Environment()
    public var environment: AppEnvironment
    private init() {
        if let configuration = Bundle.main.object(forInfoDictionaryKey: "Config") as? String {
            environment = AppEnvironment.init(rawString: configuration)
        } else {
            environment = .development
        }
    }
}
