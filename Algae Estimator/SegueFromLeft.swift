//
//  SegueFromLeft.swift
//  Algae Estimator
//
//  Created by Dominique Tipton on 11/17/16.
//  Copyright © 2016 Software Engineering. All rights reserved.
//

import UIKit
import QuartzCore

class SegueFromLeft: UIStoryboardSegue {
    
    
    override func perform() {
        let source: UIViewController = self.source
        let destination: UIViewController = self.destination
        
        let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        transition.duration = 0.35
        transition.timingFunction = timeFunc
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        
        source.navigationController!.view.layer.add(transition, forKey: kCATransition)
        source.navigationController!.pushViewController(destination, animated: false)
    }
    
}
