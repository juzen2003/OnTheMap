//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Yu-Jen Chang on 10/2/17.
//  Copyright © 2017 Yu-Jen Chang. All rights reserved.
//

import Foundation

// MARK: Constants for Udacity Clients
extension ParseClient {

    // Constants
    struct Constants {
        
        // Keys
        static let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RESTApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // URL
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes"
    }
    
    // Methods
    struct Methods {
        static let StudentLocation = "/StudentLocation"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let Limit = "limit"
        static let Skip = "skip"
        static let Order = "order"
    }
    
    // JSON Body keys
    struct JSONBodyKeys {
    
    }
    
    // JSON Response Keys
    struct JSONResponseKeys {
        static let Results = "results"
        
        static let CreatedAt = "createdAt"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let UpdatedAt = "updatedAt"
    }

}
