//
//  BehavItemCell.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/11.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit

class ReuseItemCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    
    func setCell(model: CellModel) {
        self.image.image = UIImage(named: model.imageName)
        self.itemLabel.text = model.labelName
    }
}
