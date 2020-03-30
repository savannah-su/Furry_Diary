//
//  OwnerCell.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/26.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit

class OwnerCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollection), name: Notification.Name("reloadCollection"), object: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @objc func reloadCollection() {
        collectionView.reloadData()
    }
}
