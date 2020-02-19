//
//  DetailPageViewController.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/7.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit

class DailyPageViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var choosePetCollectionView: UICollectionView!
    @IBOutlet weak var chooseView: UIView!
    
    let item = ["衛生清潔", "預防計畫", "體重紀錄", "行為症狀"]
    let itemImage = ["dog-treat", "shield", "libra-2", "pet"]
    var recordPetID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isHidden = true
        
        choosePetCollectionView.delegate = self
        choosePetCollectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        collectionView.isHidden = true
        chooseView.isHidden = false
        choosePetCollectionView.reloadData()
    }
}

extension DailyPageViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            return CGSize(width: 169, height: 200)
        }
        return CGSize(width: 150, height: 200)
    }
    
    //space of item
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.collectionView {
            return CGFloat(26)
        }
        return CGFloat()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.collectionView {
            return 26
        }
        return (UIScreen.main.bounds.width - 150 * CGFloat(UploadManager.shared.simplePetInfo.count)) / CGFloat(UploadManager.shared.simplePetInfo.count + 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == self.collectionView {
            return UIEdgeInsets(top: 26, left: 0, bottom: 0, right: 0)
        }
        return UIEdgeInsets(top: 0, left: (UIScreen.main.bounds.width - 150 * CGFloat(UploadManager.shared.simplePetInfo.count)) / CGFloat(UploadManager.shared.simplePetInfo.count + 2), bottom: 0, right: (UIScreen.main.bounds.width - 150 * CGFloat(UploadManager.shared.simplePetInfo.count)) / CGFloat(UploadManager.shared.simplePetInfo.count + 2))
    }
    
}

extension DailyPageViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.collectionView {
            return 4
        }
        return UploadManager.shared.simplePetInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionView {
            
            guard let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: "Item Cell", for: indexPath) as? ItemCell else { return UICollectionViewCell() }
            
            for index in 0 ... 3 {
                
                let index = indexPath.row
                cellA.itemLabel.text = item[index]
                cellA.image.image = UIImage(named: itemImage[index])
                
                
            }
            return cellA
            
        } else {
            
            guard let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: "Pet Cell", for: indexPath) as? WhichPetCell else { return UICollectionViewCell() }
            
            cellB.petName.text = UploadManager.shared.simplePetInfo[indexPath.row].petName
            
            let url = URL(string: UploadManager.shared.simplePetInfo[indexPath.row].petPhoto.randomElement()!)
            cellB.petPhoto.kf.setImage(with: url)
            cellB.petPhoto.contentMode = .scaleToFill
            
            return cellB
        }
    }
}

extension DailyPageViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.collectionView {
            
            if indexPath.row == 0 {
                
                guard let vc = UIStoryboard(name: "Daily", bundle: nil).instantiateViewController(identifier: "Clean Page") as? CleanPageViewController else { return }
                
                vc.petID = recordPetID
                show(vc, sender: nil)
                
            } else if indexPath.row == 1 {
                
                guard let vc = UIStoryboard(name: "Daily", bundle: nil).instantiateViewController(identifier: "Prevent Page") as? PreventPageViewController else { return }
                
                vc.petID = recordPetID
                show(vc, sender: nil)
                
            } else if indexPath.row == 2 {
                
                guard let vc = UIStoryboard(name: "Daily", bundle: nil).instantiateViewController(identifier: "Weight Page") as? WeightPageViewController else { return }
                
                vc.petID = recordPetID
                show(vc, sender: nil)
                
            } else if indexPath.row == 3 {
                
                guard let vc = UIStoryboard(name: "Daily", bundle: nil).instantiateViewController(identifier: "Behavior Page") as? BehaviorPageViewController else { return }
                
                vc.petID = recordPetID
                show(vc, sender: nil)
                
            }
            
        } else if collectionView == self.choosePetCollectionView {
            
            chooseView.isHidden = true
            self.collectionView.isHidden = false
            
            recordPetID = UploadManager.shared.simplePetInfo[indexPath.item].petID
        }
    }
}
