//
//  ViewController.swift
//  Algae Estimator
//
//  Created by App Factory on 9/30/16.
//  Copyright © 2016 Software Engineering. All rights reserved.
//

import UIKit
import CoreData
import SwiftCharts

class CalculateViewController: DataEntryViewControllerBase {
    
    var logDate: NSDate?
    var startEdit: Bool?
    
    @IBOutlet weak var po4SetButton: UIButton!
    
    @IBOutlet weak var tempSurface: UITextField!
    @IBOutlet weak var tempBottom: UITextField!
    @IBOutlet weak var brightBox: UITextField!
    @IBOutlet weak var lakeDepthBox: UITextField!

    @IBOutlet weak var chlSetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tempSurface.inputAccessoryView = self.uiToolbar
        self.tempBottom.inputAccessoryView = self.uiToolbar
        self.brightBox.inputAccessoryView = self.uiToolbar
        self.lakeDepthBox.inputAccessoryView = self.uiToolbar
        
        tempSurface.delegate = self
        tempBottom.delegate = self
        brightBox.delegate = self
        lakeDepthBox.delegate = self
        
        registerForKeyboardNotifications()
//        deregisterFromKeyboardNotifications()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
     
        
        let rightButton =  UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector (clear))
        parent?.navigationItem.rightBarButtonItem = rightButton
        
        // If current instance of CalculateViewController isnt only view controller then make it the olny one
        if (navigationController?.viewControllers.count)! > 1 {
            
            // The user does not see the hiding and showing of the navbar, but it is necessary to update it. Without it the nabvar will show non-functional back buttons
            navigationController?.isNavigationBarHidden = true
            
            // Make a new UIViewController Array and add only current instance of CalculateViewController and replace original array
            navigationController?.viewControllers = [(navigationController?.topViewController)!]
            
            navigationController?.isNavigationBarHidden = false
        }

        if self.logID != nil && startEdit! {
            // Retrieve Managed Context
            let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            // Retrieve target datalog based on NSManagedObjectID
            let datalog = managedContext.object(with: self.logID!)
            
            dataEntryVals["po4"] = datalog.value(forKey: "po4") as? Float
            dataEntryVals["temp_top"] = datalog.value(forKey: "temp_top") as? Float
            dataEntryVals["temp_bot"] = datalog.value(forKey: "temp_bot") as? Float
            dataEntryVals["depth"] = datalog.value(forKey: "depth") as? Float
            dataEntryVals["brightness"] = datalog.value(forKey: "brightness") as? Float
            logDate = datalog.value(forKey: "date") as? NSDate
            
            if (datalog.value(forKey: "total_chl") != nil) {
                dataEntryVals["totalChl"] = datalog.value(forKey: "total_chl") as? Float
                dataEntryVals["cyanoChl"] = datalog.value(forKey: "cyano_chl") as? Float
            } else {
                dataEntryVals["secciDepth"] = datalog.value(forKey: "secci_depth") as? Float
                dataEntryVals["dissolvedOxygen"] = datalog.value(forKey: "dissolved_oxygen") as? Float
            }
            self.startEdit = false
        }
        
        if dataEntryVals["temp_top"] != nil {
            tempSurface.text = String(describing: dataEntryVals["temp_top"]!)
        }
        if dataEntryVals["temp_bot"] != nil {
            tempBottom.text = String(describing: dataEntryVals["temp_bot"]!)
        }
        if dataEntryVals["brightness"] != nil {
            brightBox.text = String(describing: dataEntryVals["brightness"]!)
        }
        if dataEntryVals["depth"] != nil {
            lakeDepthBox.text = String(describing: dataEntryVals["depth"]!)
        }
        
        changeButtonColor(button: po4SetButton, changeColor: validPO4)
        changeButtonColor(button: chlSetButton, changeColor: validChl)
        
    }
    
    private func changeButtonColor(button: UIButton, changeColor: Bool) {
        if changeColor {
            button.backgroundColor = MyConstants.Colors.green
            button.setTitle("\u{2713}", for: UIControl.State.normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        } else {
            button.backgroundColor = UIColor.lightGray
            button.setTitle("SET", for: UIControl.State.normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        }
    }
    
    @objc func clear(sender: AnyObject?) {
        
        dataEntryVals = [:]
        logID = nil
        logDate = NSDate()
        startEdit = false
        tempSurface.text = ""
        tempBottom.text = ""
        brightBox.text = ""
        lakeDepthBox.text = ""
        validPO4 = false
        validChl = false
        
        viewWillAppear(false)
        viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        _updateDataEntryVals()
        
        if identifier == "toDataPage" {
            
            var formValid = true
            var msg = ""
            
            if dataEntryVals["po4"] == nil {
                formValid = false
                msg = "Missing value for P04 Concentration."
            }
            
            if formValid && (dataEntryVals["cyanoChl"] == nil || dataEntryVals["totalChl"] == nil) {
                if dataEntryVals["secciDepth"] == nil || dataEntryVals["dissolvedOxygen"] == nil {
                    formValid = false
                    msg = "Missing value for Chl a."
                }
            }
            
            if formValid && dataEntryVals["brightness"] == nil {
                formValid = false
                msg = "Missing value for Brightness."
            }
            
            if formValid && dataEntryVals["depth"] == nil {
                formValid = false
                msg = "Missing value for Lake Depth."
            }
            
            if formValid && dataEntryVals["temp_bot"] == nil {
                formValid = false
                msg = "Missing value for Bottom Temperature."
            }
            
            if formValid && dataEntryVals["temp_top"] == nil {
                formValid = false
                msg = "Missing value for Surface Temperature."
            }
            
            if formValid && (dataEntryVals["temp_top"]! > 40.0 || dataEntryVals["temp_top"]! < Float(0.0)) {
                formValid = false
                msg = "Please input Surface Temperature between 0 and 40."
            }

            if formValid && (dataEntryVals["temp_bot"]! > 40.0 || dataEntryVals["temp_bot"]! < Float(0.0)) {
                formValid = false
                msg = "Please input Bottom Temperature between 0 and 40."
            }
            
            if formValid && dataEntryVals["temp_bot"]! > dataEntryVals["temp_top"]! {
                formValid = false
                msg = "Bottom Temperature cannot be greater than Surface Temperature."
            }
            
            if formValid && dataEntryVals["depth"]! > 5.0 {
                formValid = false
                msg = "Algae bloom will not happen if lake depth > 5."
            }
            
            if formValid && dataEntryVals["totalChl"] != nil {
                if dataEntryVals["totalChl"]! < 0.0 || dataEntryVals["totalChl"]! > 300.0 {
                    formValid = false
                    msg = "Please input Total Chl a value between 0 and 300."
                }
            }
            
            if formValid && dataEntryVals["cyanoChl"] != nil {
                if dataEntryVals["cyanoChl"]! < 0.0 || dataEntryVals["cyanoChl"]! > 300.0 {
                    formValid = false
                    msg = "Please input Cyano Chl a value between 0 and 300."
                }
            }
            
            if formValid && dataEntryVals["secciDepth"] != nil {
                if dataEntryVals["secciDepth"]! < 0.0 || dataEntryVals["secciDepth"]! > 1.0 {
                    formValid = false
                    msg = "Please input Secchi Depth value between 0 and 1."
                }
            }
            
            if formValid && dataEntryVals["dissolvedOxygen"] != nil {
                if dataEntryVals["dissolvedOxygen"]! < 1.0 || dataEntryVals["dissolvedOxygen"]! > 100.0 {
                    formValid = false
                    msg = "Please input Oxygen Dissolved value between 1 and 100."
                }
            }
            
            if formValid && dataEntryVals["po4"] != nil {
                if dataEntryVals["po4"]! < 0.0001 || dataEntryVals["po4"]! > 7.0 {
                    formValid = false
                    msg = "Please input PO4 concentation between 0.0001 and 7."
                }
            }
            
            
            if !formValid {
                let alert = UIAlertController(title: "Whoops!", message: msg, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }

            return formValid
        }
        
        return true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if (segue.identifier == "po4TabBar") {
            
            // Obtain destVC controller instance.
            let tabbar = segue.destination as! UITabBarController
            let destinationVC = tabbar.viewControllers?[0] as! PO4ViewController
            let otherTabVC = tabbar.viewControllers?[1] as! PO4EstimatesViewController
            
            destinationVC.dataEntryVals = dataEntryVals
            otherTabVC.dataEntryVals = dataEntryVals
            
            destinationVC.validChl = validChl
            otherTabVC.validChl = validChl
            
            if logID != nil {
                destinationVC.logID = logID
            }
            
        } else if (segue.identifier == "toChl") {
            
            // Obtain destVC controller instance.
            let tabbar = segue.destination as! UITabBarController
            let destinationVC = tabbar.viewControllers?[0] as! ChlViewController
            let otherTabVC = tabbar.viewControllers?[1] as! ChlEstimateViewController
            
            destinationVC.dataEntryVals = dataEntryVals
            otherTabVC.dataEntryVals = dataEntryVals
            
            destinationVC.validPO4 = validPO4
            otherTabVC.validPO4 = validPO4
            
            if logID != nil {
                destinationVC.logID = logID
                otherTabVC.logID = logID
            }
            
        } else if (segue.identifier == "toDataPage") {
            
            let date = NSDate()
            
            // Retrieve PersistentContainer managed Context...
            let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let datalog: NSManagedObject
            if logID != nil {
                // Retrieve target datalog based on NSManagedObjectID
                datalog = managedContext.object(with: self.logID!)
            } else {
                // Retrieve Datalog entity from CoreData model.
                let entity = NSEntityDescription.entity(forEntityName: "Datalog", in: managedContext)
                datalog = NSManagedObject(entity: entity!, insertInto: managedContext)
            }
            
            // Insert form data into CoreData model
            datalog.setValue(dataEntryVals["temp_top"], forKey: "temp_top")
            datalog.setValue(dataEntryVals["temp_bot"], forKey: "temp_bot")
            datalog.setValue(dataEntryVals["brightness"], forKey: "brightness")
            datalog.setValue(dataEntryVals["po4"], forKey: "po4")
            
            if dataEntryVals["totalChl"] != nil && dataEntryVals["cyanoChl"] != nil {
                datalog.setValue(dataEntryVals["totalChl"], forKey: "total_chl")
                datalog.setValue(dataEntryVals["cyanoChl"], forKey: "cyano_chl")
            } else {
                datalog.setValue(dataEntryVals["secciDepth"], forKey: "secci_depth")
                datalog.setValue(dataEntryVals["dissolvedOxygen"], forKey: "dissolved_oxygen")
                datalog.setValue(nil, forKey: "total_chl")
            }
            
            datalog.setValue(dataEntryVals["depth"], forKey: "depth")
            
            if logID == nil {
                datalog.setValue(date, forKey: "date")
            }

            
            do {
                // Commit Changes to database.
                try managedContext.save()
                
                // Get the NSManagedObjectID for the record just inserted.
                let id = datalog.objectID
                
                // Obtain destVC controller instance.
                let tabbar = segue.destination as! UITabBarController
                let destinationVC = tabbar.viewControllers?[0] as! DataViewController
                
                // Pass ObjectID to the destVC
                destinationVC.id = id
            } catch let error as NSError {
                print ("Could not save \(error), \(error.userInfo)")
            }

        }

    }
    
    private func _updateDataEntryVals() {
        
        if tempBottom.text != "" && Float(tempBottom.text!) != nil {
            dataEntryVals["temp_bot"] = Float(tempBottom.text!)!
        }
        if tempSurface.text != "" && Float(tempSurface.text!) != nil {
            dataEntryVals["temp_top"] = Float(tempSurface.text!)!
        }
        if brightBox.text != "" && Float(brightBox.text!) != nil {
            dataEntryVals["brightness"] = Float(brightBox.text!)!
        }
        if lakeDepthBox.text != "" && Float(lakeDepthBox.text!) != nil {
            dataEntryVals["depth"] = Float(lakeDepthBox.text!)!
        }
        
    }

}
