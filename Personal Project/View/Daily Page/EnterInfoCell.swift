//
//  EnterInfoCell.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/13.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit

class EnterInfoCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentText: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
