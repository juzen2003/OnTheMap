//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Yu-Jen Chang on 10/23/17.
//  Copyright © 2017 Yu-Jen Chang. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    
    var keyboardOnScreen = false
    
    @IBOutlet weak var worldLocationImageView: UIImageView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureUI()
        
        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow), observer: self)
        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide), observer: self)
        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow), observer: self)
        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide), observer: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications(self)
    }
    
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func geocodeLocation(_ sender: Any) {
        userDidTapView(self)
        
        let address = self.locationTextField.text!
        let url = self.urlTextField.text!
        var coordinateInfo: CLLocationCoordinate2D? = nil
        //let controller = storyboard?.instantiateViewController(withIdentifier: "InfoPostViewController") as! InfoPostViewController
        let controller = storyboard?.instantiateViewController(withIdentifier: "InfoPostNavigationViewController") as! UINavigationController
        
        if (self.locationTextField.text!.isEmpty || self.urlTextField.text!.isEmpty) {
            presentAlertView("Location or URL Empty!", title: "Forward Geocoding Failed", targetViewController: self)
        } else {
            
            self.setUIEnabled(false)
            geocoder.geocodeAddressString(address) { (placemarks: [CLPlacemark]?, error: Error?) in
                if let placemarks = placemarks {
                    //print("\(String(describing: placemarks[0].location?.coordinate))")
                    coordinateInfo = placemarks[0].location?.coordinate
                    (controller.topViewController as! InfoPostViewController).annotation.coordinate = coordinateInfo!
                    (controller.topViewController as! InfoPostViewController).annotation.title = address
                    (controller.topViewController as! InfoPostViewController).annotation.subtitle = url
                    
                    performUIUpdatesOnMain {
                        self.present(controller, animated: true, completion: nil)
                    }
                }
                if error != nil {
                    presentAlertView("\(String(describing:error!.localizedDescription))", title: "Forward Geocoding Failed", targetViewController: self)
                    self.setUIEnabled(true)
                }
            }
            
        }
    }
}


// MARK: UITextFieldDelegate
extension AddLocationViewController: UITextFieldDelegate {
    
    
    // UITextFieldDelegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // Keyboard show & hide
    @objc func keyboardWillShow(_ notification: Notification) {
        if (!keyboardOnScreen) {
            
            self.worldLocationImageView.isHidden = true
            self.view.frame.origin.y = 0.0
            //self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardDidShow(_ notification: Notification) {
        keyboardOnScreen = true
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if keyboardOnScreen {
            self.worldLocationImageView.isHidden = false
            self.view.frame.origin.y = 0.0
            //self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardDidHide(_ notification: Notification) {
        keyboardOnScreen = false
    }
    
    private func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        // notification carries info in userInfo dictionary
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    
    // when user taps other place at view, textfields resign the first responder
    private func resignIfIsFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func userDidTapView(_ sender: AnyObject) {
        resignIfIsFirstResponder(locationTextField)
        resignIfIsFirstResponder(urlTextField)
    }
    
}


// MARK: Configure UI
private extension AddLocationViewController {
    
    func activityIndicatorIsOn(_ on: Bool) {
        if on {
            activityIndicator.alpha = 1.0
            activityIndicator.startAnimating()
        } else {
            activityIndicator.alpha = 0.0
            activityIndicator.stopAnimating()
        }
    }
    
    func setUIEnabled(_ enabled: Bool) {
        locationTextField.isEnabled = enabled
        urlTextField.isEnabled = enabled
        submitButton.isEnabled = enabled
        
        if enabled {
            submitButton.alpha = 1.0
            activityIndicatorIsOn(false)
        } else {
            submitButton.alpha = 0.5
            activityIndicatorIsOn(true)
        }
    }
    
    func configureTextField(_ textField: UITextField, placeHolder: String, secure: Bool) {
        textField.delegate = self
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        textField.placeholder = placeHolder
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor.white
        textField.isSecureTextEntry = secure
        textField.keyboardType = .default
        textField.autocorrectionType = .no
        textField.text = ""
    }
    
    func addCancelButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
    }
    
    func configureUI() {
        configureTextField(locationTextField, placeHolder: "Location, e.g., Los Angeles, CA", secure: false)
        configureTextField(urlTextField, placeHolder: "URL, e.g., https://www.udacity.com", secure: false)
        setUIEnabled(true)
        keyboardOnScreen = false
        submitButton.setTitle("FIND LOCATION", for: .normal)
        addCancelButton()
    }
}

