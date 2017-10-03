//
//  UdacityConvenienceMethod.swift
//  OnTheMap
//
//  Created by Yu-Jen Chang on 10/2/17.
//  Copyright © 2017 Yu-Jen Chang. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    // MARK: login and get session ID
    func loginAndGetSessionID(_ username: String, password: String, completionHandlerForSessionID: @escaping (_ success: Bool, _ sessionID: String?, _ errorString: String?) -> Void) {
        
        // 1: Specify parameters, method (if has {key}), and HTTP body (if POST)
        let parameters = [String: AnyObject]()
        let method = UdacityClient.Methods.Session
        let jsonBody = "{\"\(UdacityClient.JSONBodyKeys.Udacity)\": {\"\(UdacityClient.JSONBodyKeys.Username)\": \"\(username)\", \"\(UdacityClient.JSONBodyKeys.Password)\": \"\(password)\"}}"
        
        // 2: Make the request
        let _ = taskForPOSTMethod(method, parameters: parameters, jsonBody: jsonBody) { (results, error) in
            
            // 3: Send the desired value(s) to completion handler
            guard error == nil else {
                completionHandlerForSessionID(false, nil, String(describing: error!.localizedDescription))
                return
            }
            
            if let returnedError = results?[UdacityClient.JSONResponseKeys.ErrorMessage] as? String {
                
                // error returned
                completionHandlerForSessionID(false, nil, returnedError)
            } else {
                
                // GUARD: did we login successfully and get the session id
                guard let returnedSession = results?[UdacityClient.JSONResponseKeys.Session] as? [String: AnyObject], let returnedSessionID = returnedSession[UdacityClient.JSONResponseKeys.ID] as? String else {
                    completionHandlerForSessionID(false, nil, "Could not obtain session ID.")
                    return
                }
                
                // successfully get the session ID (Login success)
                completionHandlerForSessionID(true, returnedSessionID, nil)
                self.sessionID = returnedSessionID
            }
        }
    }
    
}
