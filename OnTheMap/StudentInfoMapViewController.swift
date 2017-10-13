//
//  StudentInfoMapViewController.swift
//  OnTheMap
//
//  Created by Yu-Jen Chang on 10/10/17.
//  Copyright © 2017 Yu-Jen Chang. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class StudentInfoMapViewController: UIViewController {
    
    var studentInfo: [StudentInformation] = [StudentInformation]()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadAndDisplayStudentInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
    }
    
    
    // create an array of MKPointAnnotation to store student info (location & url) for pins
    func createAnnotationArray(_ data: [StudentInformation]) -> [MKPointAnnotation] {
        var annotations = [MKPointAnnotation]()
        
        for singleStudentInfo in data {
            
            // if downloaded longitude and latitude are nil, we set it to 0
            let longValue = Double(singleStudentInfo.longitude ?? 0)
            let latValue = Double(singleStudentInfo.latitude ?? 0)
            let longtitude = CLLocationDegrees(longValue)
            let latitude = CLLocationDegrees(latValue)
            
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
            
            let firstName = singleStudentInfo.firstName ?? ""
            let lastName = singleStudentInfo.lastName ?? ""
            let mediaURL = singleStudentInfo.mediaURL ?? ""
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(firstName)" + " " + "\(lastName)"
            annotation.subtitle = "\(mediaURL)"
            
            annotations.append(annotation)
        }
        
        return annotations
    }

    
    // download student info and display on map view
    @objc func downloadAndDisplayStudentInfo() {
        self.activityIndicatorIsOn(true)
        ParseClient.sharedInstance().getMultipleLocations { (results, error) in
            if let results = results {
                let annotations = self.createAnnotationArray(results)
                performUIUpdatesOnMain {
                     self.activityIndicatorIsOn(false)
                    self.mapView.addAnnotations(annotations)
                }
            } else {
                 self.activityIndicatorIsOn(false)
                self.presentAlertView(error, title: "Download Failed")
            }
        }
    }
    
    
    // logout by deleting a session id
    @objc func logout() {
        self.activityIndicatorIsOn(true)
        UdacityClient.sharedInstance().logOutAndDeleteSession { (success, error) in
            if success {
                performUIUpdatesOnMain {
                    self.activityIndicatorIsOn(false)
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                self.activityIndicatorIsOn(false)
                self.presentAlertView(error, title: "Logout Failed")
            }
        }
    }

}


// MARK: MKMapViewDelegate
extension StudentInfoMapViewController: MKMapViewDelegate {
    
    // annotation view with callout accessory view
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.pinTintColor = UIColor.red
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // when a pin is tapped
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            
            // GURAD: check see if there is any blank URL posted
            guard let postedUrlString = view.annotation?.subtitle! else {
                self.presentAlertView("URL does not exist!", title: "Blank URL")
                return
            }
            
            // add https:// if posted url has no scheme
            var urlString = ""
            if postedUrlString.contains("https://") || postedUrlString.contains("http://") {
                urlString = postedUrlString
            } else {
                urlString = "https://" + postedUrlString
            }
            
            // open the link posted by the student when tapping a cell
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                    if !success {
                        self.presentAlertView("Failed to open posted URL in Safari!", title: "URL Error")
                    }
                })
            }
            
        }
    }
    
    
}


// MARK: Present alert view when failed to download data or failed to open up url in safari
extension StudentInfoMapViewController {
    
    func presentAlertView(_ alertMessages: String?, title: String) {
        var alertString: String?
        // add a more detailed description when network has problem
        if alertMessages!.contains("request timed out") {
            alertString = "Network connection failed. " + alertMessages!
        } else {
            alertString = alertMessages!
        }
        
        let alertVC = UIAlertController(title: title, message: alertString!, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }
}


// MARK:
extension StudentInfoMapViewController {
    
    func configureUI() {
        // logout, refresh and add button
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(downloadAndDisplayStudentInfo))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        parent!.navigationItem.leftBarButtonItem = logoutButton
        parent!.navigationItem.rightBarButtonItems = [addButton, refreshButton]
        
        self.activityIndicatorIsOn(false)
    }
    
    func setUIEnabled(_ enable: Bool) {
        parent!.navigationItem.leftBarButtonItem?.isEnabled = enable
        parent!.navigationItem.rightBarButtonItems?[0].isEnabled = enable
        parent!.navigationItem.rightBarButtonItems?[1].isEnabled = enable
    }
    
    // config activity indicator, this is to inform users that logout or refresh is in process when those buttons are tapped 
    func activityIndicatorIsOn(_ on: Bool) {
        if on {
            setUIEnabled(false)
            activityIndicator.alpha = 1.0
            activityIndicator.startAnimating()
        } else {
            setUIEnabled(true)
            activityIndicator.alpha = 0.0
            activityIndicator.stopAnimating()
        }
    }
}
