//
//  WeekTableViewCell.swift
//  API Demo
//
//  Created by Aaron Elijah on 19/07/2017.
//  Copyright © 2017 Aaron Elijah. All rights reserved.
//

import UIKit

class WeekTableViewCell: UITableViewCell {

    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var tempLabel: UILabel!
    
    @IBOutlet var desLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
