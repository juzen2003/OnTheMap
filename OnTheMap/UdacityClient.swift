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
    var sessionID: String? = nil
    
    
    // MARK: POST method
    func taskForPOSTMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        // 1,2,3: Set parameters, build the URL, and config request
        let url = makeURLFromParameters(parameters, withPathExtension: method)
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        // 4: Make the request
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            // GUARD: Was there an error?
            guard (error == nil) else {
                sendError(String(describing: error!.localizedDescription))
                return
            }
            
            // GUARD: Was there any data returned? (data != nil)
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) // subset response data
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            
            // 5,6: parse and use the data (happens in completion handler)
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        // 7: Start the request
        task.resume()
        
        return task
    }
    
    
    // MARK: DELETE method
    func taskForDELETEMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForDELETE: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        // 1,2,3: Set parameters, build the URL, and config request
        let url = makeURLFromParameters(parameters, withPathExtension: method)
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        // 4: Make the request
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForDELETE(nil, NSError(domain: "taskForDELETEMethod", code: 1, userInfo: userInfo))
            }
            
            // GUARD: Was there an error?
            guard (error == nil) else {
                sendError(String(describing: error!.localizedDescription))
                return
            }
            
            // GUARD: Was there any data returned? (data != nil)
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) // subset response data
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            
            // 5,6: parse and use the data (happens in completion handler)
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForDELETE)
        }
        
        // 7: Start the request
        task.resume()
        
        return task
    }
    
    
}


// MARK: convert JSON data to object
private extension UdacityClient {
    
    func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
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
