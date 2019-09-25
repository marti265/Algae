//
//  DataLog2ViewController.swift
//  Algae Estimator
//
//  Created by Andrew Barrett on 11/5/16.
//  Copyright © 2016 Software Engineering. All rights reserved.
//
import UIKit
import CoreData

class DataLog2ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Date that is being passed over in format yyyy-MM-dd
    var titleString: String!
    
    // Contains an array of hours
    var objects: NSMutableArray! = NSMutableArray()
    
    // Contains log information
    var datalogs: [NSManagedObject]?
    var datalogIDs: [NSManagedObjectID]?
    var datalogIDsIndex: Int?
    
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
                if logDate != nil {
                    
                    // Format used for displaying dates and hours
                    let dateFormatter = DateFormatter()
                    let hourFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    hourFormatter.dateFormat = "HH:mm:ss"
                    let date = dateFormatter.string(from: logDate as! Date)
                    let hour = hourFormatter.string(from: logDate as! Date)
                    
                    // Checks for duplicate hours
                    if (titleString == String(describing: date)) {
                        
                        self.objects.add(hour)
                    }
                    
                    //Retrieve Record ID for current log
                    let logID = datalog.objectID
                    
                    if datalogIDs?.append(logID) == nil {
                        datalogIDs = [logID]
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
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath as IndexPath) as! DataLog2TableViewCell
        
        cell.titleLabel.text = self.objects.object(at: indexPath.row) as? String
        
        return cell
    }
    
    // MARK: - Navigation
    // Go to dataLog view when selected cell index
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showLog") {
            // Obtain destVC controller instance.
            let tabbar = segue.destination as! UITabBarController
            let destinationVC = tabbar.viewControllers?[0] as! DataViewController
            
            let indexPath = self.tableView.indexPathForSelectedRow!
            datalogIDsIndex = indexPath.row
            
            // Pass ObjectID to the destVC
            destinationVC.id = datalogIDs?[datalogIDsIndex!]
        }
    }
}
