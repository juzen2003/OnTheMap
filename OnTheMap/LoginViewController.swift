//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Yu-Jen Chang on 9/14/17.
//  Copyright © 2017 Yu-Jen Chang. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var keyboardOnScreen = false
    // MARK: Outlets
    @IBOutlet weak var udacityImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow))
        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide))
        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow))
        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }


}






// MARK: UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    
    // UITextFieldDelegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // Keyboard show & hide
    func keyboardWillShow(_ notification: Notification) {
        if (!keyboardOnScreen) {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
            self.udacityImageView.isHidden = true
        }
    }
    
    func keyboardDidShow(_ notification: Notification) {
        keyboardOnScreen = true
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if keyboardOnScreen {
            self.view.frame.origin.y += getKeyboardHeight(notification)
            self.udacityImageView.isHidden = false
        }
    }
    
    func keyboardDidHide(_ notification: Notification) {
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
        resignIfIsFirstResponder(usernameTextField)
        resignIfIsFirstResponder(passwordTextField)
    }
    
}


// MARK: Configure UI

private extension LoginViewController {
    
    func setUIEnabled(_ enabled: Bool) {
        usernameTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        loginButton.isEnabled = enabled
        debugTextLabel.text = ""
        debugTextLabel.isEnabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
    
    func configureTextField(_ textField: UITextField, secure: Bool) {
        textField.delegate = self
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor.white
        textField.isSecureTextEntry = secure
    }
    
    func configureUI() {
        configureTextField(usernameTextField, secure: false)
        configureTextField(passwordTextField, secure: true)
    }
}


// MARK: Notifications
private extension LoginViewController {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}
