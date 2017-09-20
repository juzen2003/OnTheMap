//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Yu-Jen Chang on 9/18/17.
//  Copyright © 2017 Yu-Jen Chang. All rights reserved.
//

import Foundation


// MARK: UdacityClient
class UdacityClient: NSObject {
    
    // initializer
    override init() {
        super.init()
    }
    
    // shared session
    var session = URLSession.shared
    
    
    // MARK: POST method
    func taskForPOSTMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
    }
    
    
    
}


// MARK: create URL from parameters
private extension UdacityClient {
    
    func makeURLFromParameters(_ paramters: [String: AnyObject], withPathExtension: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = UdacityClient.Constants.ApiScheme
        components.host = UdacityClient.Constants.ApiHost
        components.path = UdacityClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in paramters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
}


// MARK: make a shared instance for UdacityClient
extension UdacityClient {
    
    class func sharedInstance() -> UdacityClient {
        
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        
        return Singleton.sharedInstance
    }
}
