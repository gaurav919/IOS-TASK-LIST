//
//  ItemTableViewCell.swift
//  TO_Do_App
//
//  Created by Gaurav Aryal on 2/17/20.
//  Copyright © 2020 Gaurav Aryal. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
//MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  

}
