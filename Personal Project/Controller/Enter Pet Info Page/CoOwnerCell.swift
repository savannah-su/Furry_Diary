//
//  CoOwnerCell.swift
//  
//
//  Created by Savannah Su on 2020/2/3.
//

import UIKit

class CoOwnerCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ownerImage: UIImageView!
    
    var touchHandler: ( (String) -> Void )?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
