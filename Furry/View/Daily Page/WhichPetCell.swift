//
//  ChoosePetCell.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/18.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit

class WhichPetCell: UICollectionViewCell {
    
    @IBOutlet weak var petPhoto: UIImageView!
    @IBOutlet weak var petName: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        petPhoto.layer.cornerRadius = petPhoto.bounds.width / 2
        petPhoto.contentMode = .scaleToFill
    }
}
