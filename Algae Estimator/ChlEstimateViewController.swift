//
//  ChlViewController.swift
//  Algae Estimator
//
//  Created by Derek Riley on 10/28/16.
//  Copyright © 2016 Software Engineering. All rights reserved.
//

import UIKit
import CoreData

class ChlEstimateViewController: DataEntryViewControllerBase {
    
    @IBOutlet weak var dissolvedOxygenTextfield: UITextField!
    @IBOutlet weak var secciDepthTextfield: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dissolvedOxygenTextfield.inputAccessoryView = self.uiToolbar
        self.secciDepthTextfield.inputAccessoryView = self.uiToolbar
        
        dissolvedOxygenTextfield.delegate = self
        secciDepthTextfield.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if dataEntryVals["secciDepth"] != nil {
            secciDepthTextfield.text = String(describing: dataEntryVals["secciDepth"]!)
        }
        if dataEntryVals["dissolvedOxygen"] != nil {
            dissolvedOxygenTextfield.text = String(describing: dataEntryVals["dissolvedOxygen"]!)
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
        
        print(String(describing: dataEntryVals["secciDepth"]))
        
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
            
            if (self.dataEntryVals["secciDepth"] != nil && self.dataEntryVals["dissolvedOxygen"] != nil) {
                dest.validChl = true
            }
            
            dest.validPO4 = validPO4
        }
    }
    
    private func _updateDataEntryVals() {
        if secciDepthTextfield.text != "" && Float(secciDepthTextfield.text!) != nil {
            dataEntryVals["secciDepth"] = Float(secciDepthTextfield.text!)!
        } else {
            dataEntryVals["secciDepth"] = nil
        }
        if dissolvedOxygenTextfield.text != "" && Float(dissolvedOxygenTextfield.text!) != nil {
            dataEntryVals["dissolvedOxygen"] = Float(dissolvedOxygenTextfield.text!)!
        } else {
            dataEntryVals["dissolvedOxygen"] = nil
        }
        
        dataEntryVals["totalChl"] = nil
        dataEntryVals["cyanoChl"] = nil
        
    }
    
}
