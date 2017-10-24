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
    
    // MARK: IBOutlet
    @IBOutlet weak var udacityImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet var signUpTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        configureUI()
        configLabel()
        
        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow))
        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide))
        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow))
        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide))
        */
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // configure UI here to avoid user credential left in textfield
        configureUI()
        configLabel()
        
        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow), observer: self)
        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide), observer: self)
        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow), observer: self)
        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide), observer: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications(self)
    }

    private func completeLogin() {
        self.setUIEnabled(true)
        debugTextLabel.text = "LOGIN COMPLETE!"
        // Go to next view controller
        let controller = storyboard!.instantiateViewController(withIdentifier: "OnTheMapNavigationController") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }
    
    
    // MARK: Login button is pressed
    @IBAction func loginPressed(_ sender: Any) {
        userDidTapView(self)
    
        let username = self.usernameTextField.text!
        let password = self.passwordTextField.text!
        
        if (self.usernameTextField.text!.isEmpty || self.passwordTextField.text!.isEmpty) {
            presentAlertView("Username or Password Empty!", title: "Login Failed", targetViewController: self)
            
        } else {
            
            setUIEnabled(false)
            self.debugTextLabel.text = "LOGIN IN PROCESS..."
            
            UdacityClient.sharedInstance().loginAndGetSessionID(username, password: password) { (success, sessionID, errorString) in
                performUIUpdatesOnMain {
                    if success {
                        self.completeLogin()
                    } else {
                        presentAlertView(errorString, title: "Login Failed", targetViewController: self)
                        self.setUIEnabled(true)
                    }
                }
            }
        }
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
    @objc func keyboardWillShow(_ notification: Notification) {
        if (!keyboardOnScreen) {
            //print("KEYBOARd WILL SHOW")
            //print("Orginal point: \(self.view.frame.origin.y)")
            //print("KEYBOARD HEIGHT: \(getKeyboardHeight(notification))")
            //print("UDACITY IMAGE HEIGHT: \(self.udacityImageView.frame.height)")
            //print("USERNAME TEXT POINT MAX Y: \(self.usernameTextField.frame.maxY)")
            //print("USERNAME TEXT POINT MIN Y: \(self.usernameTextField.frame.minY)")
            self.udacityImageView.isHidden = true
            self.view.frame.origin.y = 0.0
            //self.view.frame.origin.y -= getKeyboardHeight(notification)
            //print("Current point: \(self.view.frame.origin.y)")
        }
    }
    
    @objc func keyboardDidShow(_ notification: Notification) {
        keyboardOnScreen = true
        //print("KEYBOARD DID SHOW")
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if keyboardOnScreen {
            //print("KEYBOARD WILL HIDE")
            //print("Orginal point: \(self.view.frame.origin.y)")
            //print("KEYBOARD HEIGHT: \(getKeyboardHeight(notification))")
            self.udacityImageView.isHidden = false
            self.view.frame.origin.y = 0.0
            //self.view.frame.origin.y += getKeyboardHeight(notification)
            //print("Current point: \(self.view.frame.origin.y)")
        }
    }
    
    @objc func keyboardDidHide(_ notification: Notification) {
        keyboardOnScreen = false
        //print("KEYBOARD DID HIDE")
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
        usernameTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        loginButton.isEnabled = enabled
        signUpLabel.isEnabled = enabled
        debugTextLabel.isEnabled = enabled
        debugTextLabel.text = ""
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
            activityIndicatorIsOn(false)
        } else {
            loginButton.alpha = 0.5
            activityIndicatorIsOn(true)
        }
    }
    
    func displayError(_ errorString: String?) {
        if let errorString = errorString {
            debugTextLabel.text = errorString
        }
    }
    
    func configureTextField(_ textField: UITextField, secure: Bool) {
        textField.delegate = self
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor.white
        textField.isSecureTextEntry = secure
        textField.keyboardType = .default
        textField.autocorrectionType = .no
        textField.text = ""
    }
    
    func configureUI() {
        configureTextField(usernameTextField, secure: false)
        configureTextField(passwordTextField, secure: true)
        debugTextLabel.text = ""
        activityIndicator.alpha = 0.0
        keyboardOnScreen = false
        loginButton.setTitle("Login", for: .normal)
    }
}


/*
// MARK: Notifications
private extension LoginViewController {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}
*/

// MARK: create sign up label to link to Udacity Sign Up page
extension LoginViewController {
    
    // config Sign Up as blue color
    func configLabel() {
        signUpLabel.text = "Don't have an account? Sign Up"
        signUpLabel.isUserInteractionEnabled = true
        let text = signUpLabel.text!
        let clickableString = NSMutableAttributedString(string: text)
        let clickableRange = (text as NSString).range(of: "Sign Up")
        
        clickableString.addAttribute(.foregroundColor, value: UIColor.blue, range: clickableRange)
        signUpLabel.attributedText = clickableString
    }
    
    // get the size of dummy label with wanted string
    func getSizeOfLabel(wantedString: String) -> CGFloat {
        let dummyLabel = UILabel()
        dummyLabel.text = wantedString
        let maxSize = CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT))
        
        return dummyLabel.sizeThatFits(maxSize).width
    }
    
    // get location of Sign Up from center of the frame
    func getLocation() -> (CGFloat, CGFloat) {
        let point1 = signUpLabel.center.x + (getSizeOfLabel(wantedString: "Don't have an account? Sign Up")/2 - getSizeOfLabel(wantedString: "Sign Up"))
        let point2 = signUpLabel.center.x + (getSizeOfLabel(wantedString: "Don't have an account? Sign Up")/2)
        return (point1, point2)
    }
    
    // Tap Sign Up to open url and link to Udacity
    @IBAction func userDidTapLabel(_ sender: AnyObject) {
        let gestureLocation = signUpTapGestureRecognizer.location(in: signUpTapGestureRecognizer.view)
        
        if gestureLocation.x > getLocation().0 && gestureLocation.x < getLocation().1 {
            if let url = URL(string: "https://www.udacity.com/account/auth#!/signup") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
}

