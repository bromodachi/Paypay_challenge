//
//  AppEnvironment.swift
//  CurrencyExchange
//
//  Created by Conrado Uraga on 2019/04/13.
//  Copyright © 2019 Conrado Uraga. All rights reserved.
//

import Foundation
/// An enum that represents what enviornment the app is pointing at. This is configured via the scheme. Debug is YOUR local environment
public enum AppEnvironment {
    case development, testing, release
    /// Given the string set via the schema, we can create an Environ enum.
    ///
    /// - Parameter rawString: Debug - development, Testing - testing, release - Release
    init(rawString: String) {
        switch rawString {
        case "Debug":
            self = .development
        case "Testing":
            self = .testing
        case "Release":
            self = .release
        default:
            self = .development
        }
    }
    /// Depending on the environment, either return http or https. If it's production, it usually should be https. For this, we this app, we won't need it.
    private var getHTTP_S: String {
        switch self {
        case .development, .testing:
            return "http"
        default:
            return "https"
        }
    }
    /// Depending on the environment, we grab the correct url. Only used within this class. Usually this will have multiple urls but since this is a demo app, we only have one...
    private var _getBase: String {
        switch self {
        case .development:
            return "apilayer.net/api"
        case .testing:
            return "apilayer.net/api"
        case .release:
            return "apilayer.net/api"
        }
    }
    
    /// gets the base url with the correct http protocol
    public var getBase: String {
        let http = getHTTP_S
        let base: String = _getBase
        return "\(http)://\(base)"
    }
}
