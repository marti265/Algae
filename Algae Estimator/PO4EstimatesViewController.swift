//
//  PO4EstimatesViewController.swift
//  Algae Estimator
//
//  Created by App Factory on 10/26/16.
//  Copyright © 2016 Software Engineering. All rights reserved.
//

import UIKit
import CoreData

class PO4EstimatesViewController: UIViewController {
    
    var dataEntryVals: [String:Float] = [:]
    var logID: NSManagedObjectID?
    var validChl: Bool?

    // MAKE:Properties
    @IBOutlet weak var po4Val: UILabel!
    @IBOutlet weak var farmButton: UISegmentedControl!
    @IBOutlet weak var naturalButton: UISegmentedControl!
    @IBOutlet weak var plantSeek: UISlider!
    @IBOutlet weak var bloomSeek: UISlider!
    
    
    var location:Float = 0.065
    var landVegetation:Float = 0.002
    var waterVegetation:Float = 0.034
    var recurringBlooms:Float = 0.002
    var scaleBloom:Float = (0.065-0.002)/100
    var scalePlant:Float = (0.065-0.034)/100

    
    @IBAction func landIndexChanged(sender: UISegmentedControl) {
        switch farmButton.selectedSegmentIndex
        {
        case 0:
            // Farm land segment
            location = 0.065
            calculatePO4()
        case 1:
            // Urban segment
            location = 0.034
            calculatePO4()
        default:
            break;
        }
    }
    
    @IBAction func vegIndexChanged(sender: UISegmentedControl) {
        switch naturalButton.selectedSegmentIndex
        {
        case 0:
            // Natural segment
            landVegetation = 0.002
            calculatePO4()
        case 1:
            // Land segment
            landVegetation = 0.065
            calculatePO4()
        case 2:
            // Sand segment
            landVegetation = 0.002
            calculatePO4()
        default:
            break;
        }
    }
    
    @IBAction func plantSliderValueChanged(sender: UISlider) {
        let selectedValue = Float(sender.value)
        
        waterVegetation = 0.034+(selectedValue*scalePlant)
        calculatePO4()
    }
    
    @IBAction func freqSliderValueChanged(sender: UISlider) {
        let selectedValue = Float(sender.value)
        
        recurringBlooms = 0.002+(selectedValue*scaleBloom)
        calculatePO4()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueSend2") {
            
            let tabbar = segue.destination as! UITabBarController
            let destinationVC = tabbar.viewControllers?[0] as! CalculateViewController
            
            dataEntryVals["po4"] = Float(po4Val.text!)!
            destinationVC.dataEntryVals = dataEntryVals
            destinationVC.startEdit = false
            if logID != nil {
                destinationVC.logID = logID
            }
            
            // Estimate will always return valid PO4 level
            destinationVC.validPO4 = true
            destinationVC.validChl = validChl!
        }
    }
    
    func calculatePO4(){
        let value:Float = 0.1*location + 0.4*landVegetation + 0.1*waterVegetation + 0.4*recurringBlooms;
        let finalVal:  Float = 44.2222*value - 0.36
        po4Val.text = String(format: "%.4f",(round(10000*finalVal)/10000))
        
    }
    
}
