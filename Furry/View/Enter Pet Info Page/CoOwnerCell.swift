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
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
        }
    }
    @IBOutlet weak var searchButton: UIButton!
    
    var data = PetInfo(petID: "", ownersID: [], ownersName: [], ownersImage: [], petImage: [], petName: "", species: "", gender: "", breed: "", color: "", birth: "", chip: "", neuter: false, neuterDate: "", memo: "")
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension CoOwnerCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.ownersImage.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoOwner Collection Cell", for: indexPath) as? CoOwnerCollectionCell else {
            return UICollectionViewCell()
        }
        
        cell.ownerPhoto.loadImage(data.ownersImage[indexPath.item], placeHolder: UIImage(named: "FurryLogo"))
        
        guard let currentUserImage = UserDefaults.standard.value(forKey: "userPhoto") as? String else {
            return UICollectionViewCell()
        }
        
        if data.ownersImage[indexPath.item] != currentUserImage {
            
            cell.removeBtnView.isHidden = false
            
            cell.removeHandler = { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.data.ownersImage.remove(at: indexPath.item)
                collectionView.reloadData()
            }
            
        } else {
            cell.removeBtnView.isHidden = true
        }
        
        return cell
    }
}

extension CoOwnerCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 35, height: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}
