//
//  ResultViewController.swift
//  Algae Estimator
//
//  Created by App Factory on 10/28/16.
//  Copyright © 2016 Software Engineering. All rights reserved.
//

import UIKit
import CoreData

class ResultViewController : UIViewController {
    
    var number: Int = 0
    var dataEntryVals: [String:Float] = [:]
    var logID: NSManagedObjectID?
    

    @IBOutlet weak var TextResult: UITextField!
    
    
    @IBOutlet weak var myImage: UIImageView!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        switch number {
            
        case 1:
            myImage.image = UIImage(named: "dialog_chla")
            TextResult.text = "Chlorophyll is the green pigment in plants that allow them to create energy from light by photosynthesis." + "By measuring chlorophyll, you are indirectly measuring the amount of phtosynthesizing plants found in a sample. In a lake water sample, these plants would be algae or phytoplankton." + "Chlorophyll a is a measure of the portion of the pigment that is still active; that is, the portion that was still actively respiring and photosynthesizing at the time of sampling." + "Therefore, the amount of chlorophyll a in a water sample can determine the amounts of algae and cyanobacteria in the water source."
        case 2:
            myImage.image = UIImage(named: "dialog_luxmeter")
            TextResult.text = "Lux is the unit of luminance and luminous emittance, measuring luminous flux per unit area." + " For best accuracy, user should measure lux value directly by a lux meter and enter the value in." + " This app will automatically measure the lux value using the phone sensor. However, you can also enter a number if you want to calculate with a different number."
        case 3:
            myImage.image = UIImage(named: "dialog_secchi_disk")
            TextResult.text = "It is poosible to measure the total depth with a Secchi Disk. Lower the disk until it reaches the bottom of the water source."
        case 4:
            myImage.image = UIImage(named: "dialog_bottemp")
            TextResult.text = "A thermometer with rope is needed for this part." + "How to use: " + " Put thermometer into the water and slowly lower it down. Wait for some time and then lift the rope up and record the temperature. "
        case 5:
            myImage.image = UIImage(named: "dialog_surtemp")
            TextResult.text = "A thermometer is needed for this part. Place the bulb of the thermometer under water at a depth of about 15 to 20 cm. Wait a short time until the column comes to a standstill. Without lifting the thermometer out of the water, read the temperature."
        case 6:
            myImage.image = UIImage(named: "")
            TextResult.text = "Phosphorus is an important nutrient element. Many important molecules within a cell contain phosphorus. ATP is an example of a molecule that uses phosophorus. ATP is essential to all living organisms since it is used for energy. However, too much phosphorus in a system could cause an algae bloom. So to predict algae bloom one needs to measure the phosphate concentration at the bottom. Two options for inputting P04 concentration value: 1. Directly input after measuring phosphate value by yourself. 2. Estimate phosphate concentration basedo n the condition of the examining lake."
        case 7:
            myImage.image = UIImage(named: "dialog_direct")
            TextResult.text = "You will need an algae torch for this part. This allows direct measurement at the water source, helping to reduce failures due to transporting the sample to the lab. 1. Place torch in water and wait for analysis to complete. 2. The values shown on the torch are your results. 3. The torch can measure both total chlorophyll a (all types of algae) and cyano chlorophyll a (blue-green algae)"
        case 8:
            myImage.image = UIImage(named: "dialog_secchi_disk")
            TextResult.text = "Secchi depth is to determine the turbidity. You will need: a secchi disk A gadget to measure water transparency. Usage: 1. Put the secchi disk slowly into the water until the disk is no longer visible. 2. Measure the length of the line that is dipped into the water. "
        case 9:
            myImage.image = UIImage(named: "dialog_do")
            TextResult.text = "You will need a dissolved oxygen meter or oxygen test string. Usage: 1. Collect water sample from different depths 2. place the electrode into the sample container and gently stir 3. Once the display on the meter has settled on a number, this is your result. "
        case 10:
            myImage.image = UIImage(named: "dialog_podirect")
            TextResult.text = "Collection of bottom phosphate can be done using affordable PO4 test strips on the spot, but the test water has to come from the bottom. - Preperations: a. A narrow-mouthed glass bottle containing less than 500 ml of water. b. A stopper that fits tight into the mouth of the bottle. c. Firmly attach a weight (stone or a heavy piece of metal) to the lower part of the bottle so that the bottle will easily sink. d. Attach a string to the neck of the bottle. e. Attach the stopper securely to the same piece of string, just obove the opening of the bottle, at a distance eual to  at least twice the length of the stopper. - Sampling procedure: 1. Put the stopper firmly in place to close the water sampler. 2. Lower the sampler into the water ito the desired depth. 3. Jerk the string sharply to pull the stopper out and open the sampler. It should now start filling with water, while air bubbles appear on the surface of the pond. 4. When air bubbles no longer appear, carefully pull the full water sampler out of the pond."
        default:
            myImage.image = UIImage(named: "")
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        
        if((self.presentingViewController) != nil){
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tabbar = segue.destination as! UITabBarController
        let destinationVC = tabbar.viewControllers?[0] as! CalculateViewController
        
        destinationVC.dataEntryVals = dataEntryVals
        if logID != nil {
            destinationVC.logID = logID
        }
    }
}
