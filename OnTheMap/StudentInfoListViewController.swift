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
        downloadStudentInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
    }
    
    // download student info
    @objc func downloadStudentInfo() {
        self.activityIndicatorIsOn(true)
        ParseClient.sharedInstance().getMultipleLocations { (results, error) in
            if let results = results {
                self.studentInfo = results
                performUIUpdatesOnMain {
                    self.studentInfoTableView.reloadData()
                    self.activityIndicatorIsOn(false)
                }
            } else {
                // when data is not downloaded for table view, need to add alert view here
                self.activityIndicatorIsOn(false)
                presentAlertView(error, title: "Download Failed", targetViewController: self)
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
                presentAlertView(error, title: "Logout Failed", targetViewController: self)
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
            presentAlertView("URL does not exist!", title: "Blank URL", targetViewController: self)
            return
        }
        
        // add https:// if posted url has no scheme
        var urlString = ""
        if postedUrlString.contains("https://") || postedUrlString.contains("http://") {
            urlString = postedUrlString
        } else {
            urlString = "https://" + postedUrlString
        }
        //print("POSTED URL: \(postedUrlString)")
        //print("URLSTRING: \(urlString)")
        // open the link posted by the student when tapping a cell
        
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                if !success {
                    presentAlertView("Failed to open posted URL in Safari!", title: "URL Error", targetViewController: self)
                }
            })
        } else {
            presentAlertView("Failed to form URL from posted mediaURL string!", title: "URL Error", targetViewController: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}


// MARK: config UI
extension StudentInfoListViewController {
    
    func configureUI() {
        // logout, refresh and add button
        addNavigationBarButton(self, logoutAction: #selector(logout), refreshAction: #selector(downloadStudentInfo), addAction: nil)
        self.activityIndicatorIsOn(false)
    }
    
    // config activity indicator, this is to inform users that logout or refresh is in process when those buttons are tapped
    func activityIndicatorIsOn(_ on: Bool) {
        if on {
            setUIEnabled(false, targetViewController: self)
            activityIndicator.alpha = 1.0
            activityIndicator.startAnimating()
        } else {
            setUIEnabled(true, targetViewController: self)
            activityIndicator.alpha = 0.0
            activityIndicator.stopAnimating()
        }
    }
}
