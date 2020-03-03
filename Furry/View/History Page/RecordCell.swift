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
    
    case diagnosis
    
    case medicine
}

class RecordCell: UITableViewCell {
    
    @IBOutlet weak var background: UIView! {
        
        didSet{
            background.backgroundColor = .white
            background.layer.borderWidth = 1
            background.layer.borderColor = UIColor.black.cgColor
            background.layer.cornerRadius = 10
            background.layer.shadowOffset = CGSize(width: 5, height: 5)
            background.layer.shadowOpacity = 0.5
            background.layer.shadowRadius = 3
            background.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1).cgColor
        }
    }
    @IBOutlet weak var recordDate: UILabel!
    
    @IBOutlet weak var subitemCollection: UICollectionView! {
        
        didSet {
        
            subitemCollection.dataSource = self
            
            subitemCollection.delegate = self
        }
    }
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var nextDateLabel: UILabel!
    
    var datas: [String] = [] {
        
        didSet {
            
            subitemCollection.reloadData()
        }
    }
    
    var cellColor: UIColor? = .clear {
        
        didSet {
        
            subitemCollection.reloadData()
        }
    }
    
    var cellType: CellType = .clean {
        
        didSet {
            
            switch cellType {
                
            case .clean:
                recordDate.isHidden = false
                subitemCollection.isHidden = false
                contentLabel.isHidden = false
                nextDateLabel.isHidden = true
                
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
                
            case .diagnosis:
                recordDate.isHidden = false
                subitemCollection.isHidden = false
                contentLabel.isHidden = false
                nextDateLabel.isHidden = false
                
            case .medicine:
                recordDate.isHidden = false
                subitemCollection.isHidden = false
                contentLabel.isHidden = false
                nextDateLabel.isHidden = false
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

extension RecordCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Subitem Cell", for: indexPath) as? SubitemCell else {
            return UICollectionViewCell()
        }
        
        cell.backgroundColor = cellColor
    
        cell.subitemLabel.text = datas[indexPath.row]
        
        return cell
    }
}

extension RecordCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 100, height: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayot: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let itemCount = datas.count
        
        return UIEdgeInsets(
            top: 0,
            left: (UIScreen.main.bounds.width - 100 * CGFloat(itemCount) - 20 * CGFloat(itemCount - 1) - 40) / 2,
            bottom: 0,
            right: (UIScreen.main.bounds.width - 100 * CGFloat(itemCount) - 20 * CGFloat(itemCount - 1) - 40) / 2
        )
    }
    
}
