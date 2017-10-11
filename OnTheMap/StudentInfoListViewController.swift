//
//  StudentInfoListViewController.swift
//  OnTheMap
//
//  Created by Yu-Jen Chang on 10/2/17.
//  Copyright © 2017 Yu-Jen Chang. All rights reserved.
//

import UIKit

class StudentInfoListViewController: UIViewController {
    
    var studentInfo: [StudentInformation] = [StudentInformation]()
    
    @IBOutlet weak var studentInfoTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicatorIsOn(false)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        downloadStudentInfo()
    }
    
    // download student info
    func downloadStudentInfo() {
        //self.activityIndicatorIsOn(true)
        
        ParseClient.sharedInstance().getMultipleLocations { (results, error) in
            if let results = results {
                self.studentInfo = results
                performUIUpdatesOnMain {
                    self.studentInfoTableView.reloadData()
                    //self.activityIndicatorIsOn(false)
                }
            } else {
                // when data is not downloaded for table view, need to add alert view here
                //self.activityIndicatorIsOn(false)
                self.presentAlertView(error, title: "Download Failed")
            }
        }
    }
    
    
    
    
}


// MARK: UITableViewDelegate and UITableViewDataSource
extension StudentInfoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellReuseIdentifier = "StudentInfoTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        let singleStudentInfo = studentInfo[(indexPath as NSIndexPath).row]
        
        // display empty string if posted info is blank in name & url
        cell.textLabel?.text = (singleStudentInfo.firstName ?? "") + " " + (singleStudentInfo.lastName ?? "")
        cell.detailTextLabel?.text = (singleStudentInfo.mediaURL ?? "")
        cell.imageView?.image = UIImage(named: "Pin Icon")
        
        cell.imageView?.contentMode = .scaleAspectFit
        cell.textLabel?.contentMode = .scaleAspectFill
        cell.detailTextLabel?.contentMode = .scaleAspectFill
        cell.detailTextLabel?.textColor = UIColor.lightGray
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentInfo.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleStudentInfo = studentInfo[(indexPath as NSIndexPath).row]
        
        
        // GURAD: check see if there is any blank URL posted
        guard let postedUrlString = singleStudentInfo.mediaURL else {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}


// MARK: config activity indicator
extension StudentInfoListViewController {
    
    func activityIndicatorIsOn(_ on: Bool) {
        if on {
            activityIndicator.alpha = 1.0
            activityIndicator.startAnimating()
        } else {
            activityIndicator.alpha = 0.0
            activityIndicator.stopAnimating()
        }
    }
}


// MARK: Present alert view when failed to download data or failed to open up url in safari
extension StudentInfoListViewController {
    
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


