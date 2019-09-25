//
//  DataViewController.swift
//  Algae Estimator
//
//  Created by MichaelHorning on 10/5/16.
//  Copyright © 2016 Software Engineering. All rights reserved.
//

import UIKit
import CoreData

class DataViewController: UIViewController {
    
    // ID for the target NSManagedObject for datalog.
    var id: NSManagedObjectID?
    
    @IBOutlet weak var tempDiffLabel: UILabel!
    @IBOutlet weak var pavLabel: UILabel!
    @IBOutlet weak var luxLabel: UILabel!
    @IBOutlet weak var chlaLabel: UILabel!
    @IBOutlet weak var cyanoLabel: UILabel!
    @IBOutlet weak var chlanLabel: UILabel!
    @IBOutlet weak var chlarLabel: UILabel!
    @IBOutlet weak var chlakLabel: UILabel!
    @IBOutlet weak var cyanonLabel: UILabel!
    @IBOutlet weak var cyanorLabel: UILabel!
    @IBOutlet weak var cyanokLabel: UILabel!
    
    var chlaDataSet: Array<Float> = [Float]()
    
    var cyanoDataSet:Array<Float> = [Float]()
    
    var logDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let rightButton =  UIBarButtonItem(title: "New Log", style: .plain, target: self, action: #selector (tapped))
        parent?.navigationItem.rightBarButtonItem = rightButton
        
        // Retrieve Managed Context
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Retrieve target datalog based on NSManagedObjectID
        let datalog = managedContext.object(with: self.id!)
        
        var calculation: Calculations
        
        let pbot = datalog.value(forKey: "po4") as! Float
        let tempTop = datalog.value(forKey: "temp_top") as? Float
        let tempBot = datalog.value(forKey: "temp_bot") as? Float
        let depth = datalog.value(forKey: "depth") as? Float
        let brightness = datalog.value(forKey: "brightness") as? Float
        
        if (datalog.value(forKey: "total_chl") != nil) {
            let totalChl = datalog.value(forKey: "total_chl") as! Float
            let cyanoChl = datalog.value(forKey: "cyano_chl") as! Float
            
            calculation = Calculations(total_chla: totalChl, cyano_chla: cyanoChl, Pbot: pbot, surtemp: tempTop!, bottemp: tempBot!, depth: depth!, lux: brightness!)
        } else {
            let secciDepth = datalog.value(forKey: "secci_depth") as! Float
            let disOxygen = datalog.value(forKey: "dissolved_oxygen") as! Float
            
            calculation = Calculations(SD_value: secciDepth, DO_value: disOxygen, Pbot: pbot, surtemp: tempTop!, bottemp: tempBot!, depth: depth!, lux: brightness!, estimate: true)
        }
        
        tempDiffLabel.text = String(describing: calculation.surtemp - calculation.bottemp)
        pavLabel.text = String(describing: calculation.Pbot / calculation.depth)
        luxLabel.text = String(describing: calculation.lux)
        chlaLabel.text = String(describing: calculation.total_chla)
        chlanLabel.text = String(describing: calculation.N0)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.scientific
        numberFormatter.positiveFormat = "0.###E+0"
        numberFormatter.negativeFormat = "-0.###E+0"
        numberFormatter.exponentSymbol = "e"
        
        chlarLabel.text = String(describing: numberFormatter.string(from: NSNumber(value: calculation.getR01()))!)
        chlakLabel.text = String(describing: calculation.getK1())
        cyanoLabel.text = String(describing: calculation.cyano_chla)
        cyanonLabel.text = String(describing: calculation.N0)
        cyanorLabel.text = String(describing: numberFormatter.string(from: NSNumber(value: calculation.getR02()))!)
        cyanokLabel.text = String(describing: calculation.getK2())
        
        chlaDataSet = calculation.getTotalChlaDataSet()
        cyanoDataSet = calculation.getCyanoChlaDataSet()
        
        let graphController = tabBarController?.viewControllers?[1] as! GraphViewController
        graphController.chlaDataSet = chlaDataSet
        graphController.cyanoDataSet = cyanoDataSet
    }
    
    @objc func tapped(sender: AnyObject?) {
        performSegue(withIdentifier: "new", sender: sender)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editLog" {
            let tabbar = segue.destination as! UITabBarController
            let destinationVC = tabbar.viewControllers?[0] as! CalculateViewController
            destinationVC.logID = id
            destinationVC.startEdit = true
            destinationVC.validPO4 = true
            destinationVC.validChl = true
        }
        else if segue.identifier == "dataSet" {
            let destinationVC = segue.destination as! DataSetTableViewController
            destinationVC.data = [chlaDataSet, cyanoDataSet]
            destinationVC.logDate = logDate
        }
        
    }
    
}


