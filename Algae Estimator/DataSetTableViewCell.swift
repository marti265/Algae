//
//  TableViewCell.swift
//  Algae Estimator
//
//  Created by Dominique Tipton on 11/13/16.
//  Copyright © 2016 Software Engineering. All rights reserved.
//

import UIKit

class DataSetTableViewCell: UITableViewCell {

    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var colonLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
