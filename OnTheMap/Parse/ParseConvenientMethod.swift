//
//  ParseConvenientMethod.swift
//  OnTheMap
//
//  Created by Yu-Jen Chang on 10/3/17.
//  Copyright © 2017 Yu-Jen Chang. All rights reserved.
//

import Foundation


extension ParseClient {
    
    
    // MARK: get multiple students locations
    func getMultipleLocations(_ completionHandlerForGetMultiLocations: @escaping (_ results: [StudentInformation]?, _ errorString: String?) -> Void) {
        let numberOfInfo = "2"
        
        // 1: Specify parameters and method
        let parameters = [ParseClient.ParameterKeys.Limit: numberOfInfo] as [String: AnyObject]
        let method = ParseClient.Methods.StudentLocation
        
        // 2: Make the request
        let _ = taskForGETMethod(method, parameters: parameters) { (results, error) in
            
            // 3: Send the desired value(s) to completion handler
            guard error == nil else {
                completionHandlerForGetMultiLocations(nil, String(describing: error!.localizedDescription))
                return
            }
            
            if let returnedError = results?[ParseClient.JSONResponseKeys.ErrorMessage] as? String {
                // error returned
                completionHandlerForGetMultiLocations(nil, returnedError)
            } else {
                
                // GUARD: did we get the results
                guard let results = results?[ParseClient.JSONResponseKeys.Results] as? [[String: AnyObject]] else {
                    completionHandlerForGetMultiLocations(nil, "Could not obtain student locations.")
                    return
                }
                
                let multiStudentInformation = StudentInformation.studentInformationFromResults(results)
                completionHandlerForGetMultiLocations(multiStudentInformation, nil)
            }
            
        }
    }
    
}
