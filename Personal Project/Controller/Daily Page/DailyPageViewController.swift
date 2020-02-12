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
    
    let item = ["衛生清潔", "預防計畫", "體重紀錄", "行為症狀"]
    let itemImage = ["dog-treat", "shield", "libra-2", "pet"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
}

extension DailyPageViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 169, height: 200)
    }
    
    //space of item
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return CGFloat(26)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 26
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 26, left: 0, bottom: 0, right: 0)
    }
    
}

extension DailyPageViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
   
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Item Cell", for: indexPath) as? ItemCell else { return UICollectionViewCell() }
        
        for index in 0 ... 3 {
            
            let index = indexPath.row
            cell.itemLabel.text = item[index]
            cell.image.image = UIImage(named: itemImage[index])

        }
        return cell
    }
   
}

extension DailyPageViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            guard let vc = UIStoryboard(name: "Daily", bundle: nil).instantiateViewController(identifier: "Clean Page") as? CleanPageViewController else { return }
            show(vc, sender: nil)
            
        } else if indexPath.row == 1 {
            
            guard let vc = UIStoryboard(name: "Daily", bundle: nil).instantiateViewController(identifier: "Prevent Page") as? PreventPageViewController else { return }
            show(vc, sender: nil)
            
        } else if indexPath.row == 2 {
            
            guard let vc = UIStoryboard(name: "Daily", bundle: nil).instantiateViewController(identifier: "Weight Page") as? WeightPageViewController else { return }
            show(vc, sender: nil)
            
        } else if indexPath.row == 3 {
            
            guard let vc = UIStoryboard(name: "Daily", bundle: nil).instantiateViewController(identifier: "Behavior Page") as? BehaviorPageViewController else { return }
            show(vc, sender: nil)
            
        }
    }
}
