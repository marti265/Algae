//
//  PO4ViewController.swift
//  Algae Estimator
//
//  Created by App Factory on 10/19/16.
//  Copyright © 2016 Software Engineering. All rights reserved.
//

import UIKit
import CoreData

class PO4ViewController: DataEntryViewControllerBase {
    
    @IBOutlet weak var po4TextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.po4TextField.inputAccessoryView = self.uiToolbar
        
        po4TextField.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if dataEntryVals["po4"] != nil {
            po4TextField.text = String(describing: dataEntryVals["po4"]!)
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
        
        if formValid && dataEntryVals["po4"] != nil {
            if dataEntryVals["po4"]! < 0.0001 || dataEntryVals["po4"]! > 7.0 {
                formValid = false
                msg = "Please input PO4 concentation between 0.0001 and 7."
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
        if (segue.identifier == "backToDataEntry") {
            _updateDataEntryVals()
            let tabbar = segue.destination as! UITabBarController
            let dest = tabbar.viewControllers?[0] as! CalculateViewController
            dest.dataEntryVals = dataEntryVals
            dest.startEdit = false
            
            if logID != nil {
                dest.logID = logID
            }
            
            if dataEntryVals["po4"] != nil && dataEntryVals["po4"]! >= 0.0001 && dataEntryVals["po4"]! <= 7.0 {
                dest.validPO4 = true
            } else {dest.validPO4 = false}
            dest.validChl = validChl
        }
    }
    
    
    private func _updateDataEntryVals() {
        if po4TextField.text != "" && Float(po4TextField.text!) != nil {
            dataEntryVals["po4"] = Float(po4TextField.text!)!
        } else {
            dataEntryVals["po4"] = nil
        }
    }

}
