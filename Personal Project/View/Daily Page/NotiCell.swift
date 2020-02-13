//
//  NotiCell.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/13.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit

class NotiCell: UITableViewCell {

    @IBOutlet weak var notiSwitch: UISwitch!
    @IBOutlet weak var dateText: UITextField!
    @IBOutlet weak var notiText: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
