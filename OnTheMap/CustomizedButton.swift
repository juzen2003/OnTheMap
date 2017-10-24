//
//  CustomizedButton.swift
//  OnTheMap
//
//  Created by Yu-Jen Chang on 9/28/17.
//  Copyright © 2017 Yu-Jen Chang. All rights reserved.
//

import UIKit

class CustomizedButton: UIButton {
    
    //let darkerOrange = UIColor(red: 0.961, green: 0.368, blue: 0.0, alpha:1.0)
    //let lighterOrange = UIColor(red: 0.985, green:0.490, blue:0.0, alpha: 1.0)
    let darkerBlue = UIColor(red: 0.0, green: 0.675214, blue: 1.0, alpha: 1.0)
    let lighterBlue = UIColor(red: 0.0, green: 0.85755, blue: 1.0, alpha: 1.0)
    
    var backingColor: UIColor? = nil
    var highlightedBackingColor: UIColor? = nil
    
    
    // MARK: Initialization
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        theLoginButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        theLoginButton()
    }
    
    private func theLoginButton() {
        layer.masksToBounds = true
        layer.cornerRadius = 8.0
        highlightedBackingColor = lighterBlue
        backingColor = darkerBlue
        backgroundColor = darkerBlue
        setTitleColor(.white, for: UIControlState())
        //setTitle("Login", for: .normal)
    }
    
    
    // MARK: Tracking
    override func beginTracking(_ touch: UITouch, with withEvent: UIEvent?) -> Bool {
        backgroundColor = highlightedBackingColor
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        backgroundColor = backingColor
    }
    
    override func cancelTracking(with event: UIEvent?) {
        backgroundColor = backingColor
    }
    
}

