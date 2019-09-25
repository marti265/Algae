//
//  DataLogViewController.swift
//  Algae Estimator
//
//  Created by Dominique Tipton on 10/21/16.
//  Copyright © 2016 Software Engineering. All rights reserved.
//

import UIKit
import CoreData

class DataLogViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Contains an array of dates
    var objects: NSMutableArray! = NSMutableArray()
    
    // Current Date
    var currDate = ""
    
    // Contains log information
    var datalogs: [NSManagedObject]?
    var datalogIDs: [NSManagedObjectID]?
    var datalogIDsIndex: Int?
    
    override func viewWillAppear(_ animated: Bool) {
        parent?.navigationItem.rightBarButtonItem = nil
    }
    
    override func viewDidLoad() {
        
        // Retrieve Managed Context
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let dataLogFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Datalog")
        
        do {
            let datalogs = try managedContext.fetch(dataLogFetch) as? [NSManagedObject]
            
            for datalog in datalogs! {
                
                // Retrieve date for current log
                // Date in format YYYY-MM-DD HH:MM:SS in UTC time zone
                let logDate = datalog.value(forKey: "date")
                
                // Checks for dates in full Optional(NSDate) format
                if (logDate != nil) {
                    
                    // Format used for displaying dates
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let date = dateFormatter.string(from: logDate as! Date)
                    
                    // Set current date if not already set and different
                    if date != currDate {
                        currDate = date
                        
                        // If the date is found then add date to array
                        if currDate.contains(date) {
                            self.objects.add(currDate)
                        }
                        
                        // Retrieve Record ID for current log
                        let logID = datalog.objectID
                        if datalogIDs?.append(logID) == nil {
                            datalogIDs = [logID]
                        }
                    }
                }
            }
        } catch {print("Error")}
        self.tableView.reloadData()
    }
    
    
    // MARK: - Table View
    // Creates number of cells equal to number of objects in array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objects.count
    }
    
    // Set cells title labels for indices
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! DataLogTableViewCell
        
        cell.titleLabel.text = self.objects.object(at: indexPath.row) as? String
        
        return cell
    }
    
    // Pass our titleString to next UITableViewController containing date in format yyyy-MM-dd
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showView") {
            let upcoming: DataLog2ViewController = segue.destination as! DataLog2ViewController
            let indexPath = self.tableView.indexPathForSelectedRow!
            let titleString = self.objects.object(at: indexPath.row) as? String
            upcoming.titleString = titleString
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
