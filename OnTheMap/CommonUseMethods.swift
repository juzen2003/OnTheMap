//
//  CommonUseMethods.swift
//  OnTheMap
//
//  Created by Yu-Jen Chang on 10/14/17.
//  Copyright © 2017 Yu-Jen Chang. All rights reserved.
//

import Foundation
import UIKit


// MARK: Present alert view
func presentAlertView(_ alertMessages: String?, title: String, targetViewController: UIViewController) {
    var alertString: String?
    // add a more detailed description when network has problem
    if alertMessages!.contains("request timed out") {
        alertString = "Network connection failed. " + alertMessages!
    } else {
        alertString = alertMessages!
    }
    
    let alertVC = UIAlertController(title: title, message: alertString!, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
        alertVC.dismiss(animated: true, completion: nil)
    }
    
    alertVC.addAction(okAction)
    targetViewController.present(alertVC, animated: true, completion: nil)
}


// MARK: add navigation bar buttons
func addNavigationBarButton(_ targetViewController: UIViewController, logoutAction: Selector?, refreshAction: Selector?, addAction: Selector?) {
    
    let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: targetViewController, action: logoutAction)
    let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: targetViewController, action: refreshAction)
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: targetViewController, action: addAction)
    targetViewController.parent!.navigationItem.leftBarButtonItem = logoutButton
    targetViewController.parent!.navigationItem.rightBarButtonItems = [addButton, refreshButton]
}


// MARK: disable/enable navigation bar buttons
func setUIEnabled(_ enable: Bool, targetViewController: UIViewController) {
    targetViewController.parent!.navigationItem.leftBarButtonItem?.isEnabled = enable
    targetViewController.parent!.navigationItem.rightBarButtonItems?[0].isEnabled = enable
    targetViewController.parent!.navigationItem.rightBarButtonItems?[1].isEnabled = enable
}


// MARK: subscribe/unsubscribe notifications to inform view controller
func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector, observer: Any) {
    NotificationCenter.default.addObserver(observer, selector: selector, name: notification, object: nil)
}

func unsubscribeFromAllNotifications(_ observer: Any) {
    NotificationCenter.default.removeObserver(observer)
}
