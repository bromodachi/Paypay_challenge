//
//  API_Base.swift
//  CurrencyExchange
//
//  Created by Conrado Uraga on 2019/04/13.
//  Copyright © 2019 Conrado Uraga. All rights reserved.
//

import Foundation
// I would extend this class for certain concreate APIs. For a basic app, this simple enough
class APIBaseController{
    //MARK: API related properties
    //Paypay's api. The one that's commented out is mine. 
    private static let API_KEY = "YOUR_API_KEY"
    public static let BASE_URL = Environment.default.environment.getBase
    
    enum Path {
        case list
        case live
        var path: String {
            switch self {
                case .list:
                    return "list"
                case .live:
                    return "live"
            }
        }
    }
    //MARK: API related functions
    /// Creates a url given a diction of params. Access key will always be appended for you.
    ///
    /// - Parameters:
    ///   - params: a dicitionary of params you would like to pass. For this APP, it's only source.
    ///   - paths: the url paths(like list, live)
    /// - Returns: a url to call with.
    public static func getURL(params: [String: Any]? = nil, _ paths: String...)-> URL {
        let urlString = paths.joined(separator: "/")
        let _ = urlString.dropLast()
        guard let url = URL(string: urlString) else {
            fatalError("should not happen")
        }
        var params = params ?? [String:Any]()
        params["access_key"] = self.API_KEY
        return url.withQueries(params) ?? url
    }
    
    ///  Makes the call to the API. Requres a resource to execute.
    ///
    /// - Parameters:
    ///   - queue: Set queue after receiving data from the API. Default is main thread.
    ///   - resource: The model that contains the url it uses to get its data.
    ///   - completion: A completion closure that returns the object you wanted.
    public static func load<T>(_ resource: Resource<T>, queue: DispatchQueue = DispatchQueue.main,  completion: @escaping (T?, Bool, ErrorString?)->()) {
        URLSession.shared.dataTask(with: resource.url){ data, response, error in
            if let data = data {
                queue.async {
                    let completionData = resource.parse(data)
                    completion(completionData.0, completionData.1, completionData.2)
                }
            }
            else {
                queue.async {
                    completion(nil, false, error?.localizedDescription ?? "Network related error")
                }
            }
        }.resume()
    }
    
}
