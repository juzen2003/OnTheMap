//
//  GCDUIUpdateOnMain.swift
//  OnTheMap
//
//  Created by Yu-Jen Chang on 9/18/17.
//  Copyright © 2017 Yu-Jen Chang. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
