//
//  CoOwnerCell.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/5.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit

class CoOwnerCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        
//        collectionView.delegate = self
//        collectionView.dataSource = self
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//extension CoOwnerCell: UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//
//
//}
//
//extension CoOwnerCell: UICollectionViewDelegate {
//
//}
