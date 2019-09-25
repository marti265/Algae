//
//  ChlViewController.swift
//  Algae Estimator
//
//  Created by Derek Riley on 10/28/16.
//  Copyright © 2016 Software Engineering. All rights reserved.
//

import UIKit
import CoreData

class ChlViewController: DataEntryViewControllerBase {
    
    @IBOutlet weak var totalChlTextfield: UITextField!
    @IBOutlet weak var cyanoChlTextfield: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.totalChlTextfield.inputAccessoryView = self.uiToolbar
        self.cyanoChlTextfield.inputAccessoryView = self.uiToolbar
        
        totalChlTextfield.delegate = self
        cyanoChlTextfield.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if dataEntryVals["totalChl"] != nil {
            totalChlTextfield.text = String(describing: dataEntryVals["totalChl"]!)
        }
        if dataEntryVals["cyanoChl"] != nil {
            cyanoChlTextfield.text = String(describing: dataEntryVals["cyanoChl"]!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        _updateDataEntryVals()
        
        var formValid = true
        var msg = ""
        
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
        
        if !formValid {
            let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        return formValid
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        _updateDataEntryVals()
        
        if (segue.identifier == "submit") {
            
            let tabbar = segue.destination as! UITabBarController
            let dest = tabbar.viewControllers?[0] as! CalculateViewController
            
            dest.dataEntryVals = dataEntryVals
            dest.startEdit = false
            if logID != nil {
                dest.logID = logID
            }
            
            if (self.dataEntryVals["totalChl"] != nil && self.dataEntryVals["cyanoChl"] != nil) {
                dest.validChl = true
            }
            
            dest.validPO4 = validPO4
        }
    }
    
    private func _updateDataEntryVals() {
        if totalChlTextfield.text != "" && Float(totalChlTextfield.text!) != nil {
            dataEntryVals["totalChl"] = Float(totalChlTextfield.text!)!
        } else {
            dataEntryVals["totalChl"] = nil
        }
        if cyanoChlTextfield.text! != "" && Float(cyanoChlTextfield.text!) != nil {
            dataEntryVals["cyanoChl"] = Float(cyanoChlTextfield.text!)!
        } else {
            dataEntryVals["cyanoChl"] = nil
        }
        
        dataEntryVals["secciDepth"] = nil
        dataEntryVals["dissolvedOxygen"] = nil
    }
    
}
