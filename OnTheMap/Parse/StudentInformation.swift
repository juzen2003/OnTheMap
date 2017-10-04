//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Yu-Jen Chang on 10/2/17.
//  Copyright © 2017 Yu-Jen Chang. All rights reserved.
//

import Foundation

// MARK: StudentInformation struct
struct StudentInformation {
    
    // MARK: Properties
    let firstName: String?
    let lastName: String?
    let longitude: Float?
    let latitude: Float?
    let mediaURL: String?
    let mapString: String?
    let objectId: String?
    
    
    // MARK: Initializer
    init(dictionary: [String:AnyObject]) {
        firstName = dictionary[ParseClient.JSONResponseKeys.FirstName] as? String
        lastName = dictionary[ParseClient.JSONResponseKeys.LastName] as? String
        longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as? Float
        latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as? Float
        mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as? String
        mapString = dictionary[ParseClient.JSONResponseKeys.MapString] as? String
        objectId = dictionary[ParseClient.JSONResponseKeys.ObjectId] as? String
    }
    
    
    // MARK: make an array of student information from parsed result (array of dictionary)
    static func studentInformationFromResults(_ results: [[String:AnyObject]]) -> [StudentInformation] {
        var studentInformationArray = [StudentInformation]()
        
        for eachInfo in results {
            studentInformationArray.append(StudentInformation(dictionary: eachInfo))
        }
        
        return studentInformationArray
    }
    
}
