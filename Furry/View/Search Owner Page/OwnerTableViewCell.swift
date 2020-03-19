//
//  OwnerTableViewCell.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/1/31.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit

class OwnerTableViewCell: UITableViewCell {

    @IBOutlet weak var ownerImage: UIImageView!
    @IBOutlet weak var ownerName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
