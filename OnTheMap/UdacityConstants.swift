//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Yu-Jen Chang on 9/18/17.
//  Copyright © 2017 Yu-Jen Chang. All rights reserved.
//

import Foundation

// MARK: Constants for Udacity Clients
extension UdacityClient {
    
    // Constants
    struct Constants {
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
    }
    
    // Methods
    struct Methods {
        static let Session = "/session"
    }
    
    // JSON Body keys
    struct JSONBodyKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "passowrd"
    }
    
    // JSON Response Keys
    struct JSONResponseKeys {
        static let Account = "account"
        static let Registered = "registered"
        static let Key = "key"
        
        static let Session = "session"
        static let ID = "id"
        static let Expiration = "expiration"
        
        static let StatusCode = "status"
        static let ErrorMessage = "error"
    }
    
    
}
