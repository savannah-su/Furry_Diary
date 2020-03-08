//
//  CoOwnerCell.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/25.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit

class CoOwnerCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var removeBtnView: UIView!
    @IBOutlet weak var ownerPhoto: UIImageView!
    @IBOutlet weak var removeButton: UIButton!
    @IBAction func removeButton(_ sender: Any) {
        removeHandler?()
    }
    
    var removeHandler: ( () -> Void )?
}
