//
//  TableViewController.swift
//  Algae Estimator
//
//  Created by Dominique Tipton on 11/13/16.
//  Copyright © 2016 Software Engineering. All rights reserved.
//

import UIKit
import CoreData

class DataSetTableViewController: UITableViewController {
    
    var data: Array<Array<Float>> = []
    
    var logDate = Date()
    
    let headers = ["Total Chl a", "Cyano Chl a"]
    
    let width = Int(UIScreen.main.bounds.width)
    let height: Int = 44 // Default cell height
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.backgroundColor = MyConstants.Colors.purple
        
        self.title = "Data Set"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return headers.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[0].count % 24 - 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DataSetTableViewCell?

        cell?.indexLabel.text = "[" + String(describing: indexPath.row * 24) + "]"
        cell?.indexLabel.frame = CGRect(x: 0, y: 0, width: width / 2, height: height)
        cell?.indexLabel.textAlignment = NSTextAlignment.center
        cell?.indexLabel.textColor = UIColor.white
        
        cell?.colonLabel.text = ":"
        cell?.colonLabel.frame = CGRect(x: 0, y: 0, width: width, height: height)
        cell?.colonLabel.textAlignment = NSTextAlignment.center
        cell?.colonLabel.textColor = UIColor.white
        
        cell?.dataLabel.text = String(describing: data[indexPath.section][indexPath.row * 24])
        cell?.dataLabel.frame = CGRect(x: width / 2, y: 0, width: width / 2, height: height)
        cell?.dataLabel.textAlignment = NSTextAlignment.center
        cell?.dataLabel.textColor = UIColor.white
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as! UITableViewHeaderFooterView
        
        header.tintColor = UIColor(red:0.28, green:0.31, blue:0.58, alpha:1.0)
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.textAlignment = NSTextAlignment.center
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
}
