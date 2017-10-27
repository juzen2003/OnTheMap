//
//  InfoPostViewController.swift
//  OnTheMap
//
//  Created by Yu-Jen Chang on 10/26/17.
//  Copyright © 2017 Yu-Jen Chang. All rights reserved.
//

import Foundation
import MapKit

class InfoPostViewController: UIViewController {
    
    @IBOutlet weak var infoPostMapView: MKMapView!
    
    let annotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performUIUpdatesOnMain {
            self.infoPostMapView.addAnnotation(self.annotation)
            self.zoomIn(point: self.annotation)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
    }
    
    // focus to the submit pin in infoPostMapView
    func zoomIn(point: MKAnnotation) {
        let regionRadius: CLLocationDistance = 1500
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(point.coordinate, regionRadius, regionRadius)
        self.infoPostMapView.setRegion(coordinateRegion, animated: true)
    }
    
    @objc func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
}


// MARK: MKMapViewDelegate
extension InfoPostViewController: MKMapViewDelegate {
    
    // annotation view
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        //var pinView = mapView.view(for: annotation)
        
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
  
}


// MARK: Configure UI
private extension InfoPostViewController {
    
    func addGoBackButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack))
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(goBack))
    }
    
    func configureUI() {
        addGoBackButton()
    }
}
