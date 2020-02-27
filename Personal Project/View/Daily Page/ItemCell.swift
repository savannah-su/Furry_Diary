//
//  ItemCell.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/7.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var background: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupShadow()
    }
    
    func setupShadow() {
        background.backgroundColor = .white
        background.layer.borderWidth = 1
        background.layer.cornerRadius = 10
        background.layer.shadowOffset = CGSize(width: 5, height: 5)
        background.layer.shadowOpacity = 0.5
        background.layer.shadowRadius = 3
        background.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1).cgColor
    }
}
