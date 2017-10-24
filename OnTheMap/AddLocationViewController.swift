//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Yu-Jen Chang on 10/23/17.
//  Copyright © 2017 Yu-Jen Chang. All rights reserved.
//

import Foundation
import UIKit

class AddLocationViewController: UIViewController {
    
    var keyboardOnScreen = false
    
    @IBOutlet weak var worldLocationImageView: UIImageView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow), observer: self)
        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide), observer: self)
        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow), observer: self)
        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide), observer: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        unsubscribeFromAllNotifications(self)
    }
    
    
    @IBAction func geocodeLocation(_ sender: Any) {
        print("Perform geocoding here")
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
