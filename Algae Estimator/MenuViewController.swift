//
//  MenuViewController.swift
//  Algae Estimator
//
//  Created by Jose on 10/4/19.
//  Copyright © 2019 Software Engineering. All rights reserved.
//

import UIKit

protocol SlideMenuDelagate {
    func slideMenuItemsSelectedAtIndex(_ index : Int32)
}

class MenuViewController: UIViewController {

    var btnMenu : UIButton!
    var delagate : SlideMenuDelagate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
