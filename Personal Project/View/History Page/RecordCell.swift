//
//  RecordCell.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/19.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit

enum CellType {
    
    case clean
    
    case prevent
    
    case weight
    
    case behavior
}

class RecordCell: UITableViewCell {
    
    @IBOutlet weak var background: UIView! {
        
        didSet{
            background.backgroundColor = .white
            background.layer.borderWidth = 0
            background.layer.cornerRadius = 10
            background.layer.shadowOffset = CGSize(width: 5, height: 5)
            background.layer.shadowOpacity = 0.5
            background.layer.shadowRadius = 3
            background.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1).cgColor
        }
    }
    @IBOutlet weak var recordDate: UILabel!
    
    @IBOutlet weak var subitemCollection: UICollectionView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var nextDateLabel: UILabel!
    
    var cellType: CellType = .clean {
        
        didSet {
            
            switch cellType {
                
            case .clean:
                recordDate.isHidden = false
                subitemCollection.isHidden = false
                contentLabel.isHidden = true
                nextDateLabel.isHidden = false
                
            case .prevent:
                recordDate.isHidden = false
                subitemCollection.isHidden = false
                contentLabel.isHidden = false
                nextDateLabel.isHidden = false
                
            case .weight:
                recordDate.isHidden = false
                subitemCollection.isHidden = false
                contentLabel.isHidden = false
                nextDateLabel.isHidden = true
                
            case .behavior:
                recordDate.isHidden = false
                subitemCollection.isHidden = false
                contentLabel.isHidden = false
                nextDateLabel.isHidden = true
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
