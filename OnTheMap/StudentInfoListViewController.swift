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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // logout button
        parent!.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // download student info
        ParseClient.sharedInstance().getMultipleLocations { (results, error) in
            if let results = results {
                self.studentInfo = results
                performUIUpdatesOnMain {
                    self.studentInfoTableView.reloadData()
                }
            } else {
                // when data is not downloaded for table view
                print(error ?? "empty error")
            }
        }
    }
    
    
    // logout by deleting a session id
    @objc func logout() {
        UdacityClient.sharedInstance().logOutAndDeleteSession { (success, error) in
            if success {
                performUIUpdatesOnMain {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                print(error ?? "Failed to logout!")
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
        
        cell.textLabel?.text = singleStudentInfo.firstName! + " " + singleStudentInfo.lastName!
        cell.imageView?.image = UIImage(named: "Pin Icon")
        
        cell.imageView?.contentMode = .scaleAspectFit
        cell.textLabel?.contentMode = .scaleAspectFill
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentInfo.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleStudentInfo = studentInfo[(indexPath as NSIndexPath).row]
        
        // open the link posted by the student when tapping a cell
        if let url = URL(string: singleStudentInfo.mediaURL!) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

