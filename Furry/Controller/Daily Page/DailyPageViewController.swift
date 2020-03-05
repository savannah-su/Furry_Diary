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
    @IBOutlet weak var navigationTitle: UILabel!
    
    let item = ["衛生清潔", "預防計畫", "體重紀錄", "行為症狀", "醫療紀錄", "用藥紀錄"]
    let itemImage = ["dog-treat", "shield", "libra-2", "pet", "report", "medicine"]
    var recordPetID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        choosePetCollectionView.delegate = self
        choosePetCollectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        navigationTitle.text = "要幫哪個毛孩紀錄呢？"
        collectionView.isHidden = true
        chooseView.isHidden = false
        choosePetCollectionView.reloadData()
    }
}

extension DailyPageViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.collectionView {
            return CGSize(width: 158, height: 200)
        }
        return CGSize(width: 150, height: 200)
    }
    
    //space of item
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.collectionView {
            return (UIScreen.main.bounds.width - 316) / 3
        }
        return (UIScreen.main.bounds.width - 340) / 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.collectionView {
            return 26
        }
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == self.collectionView {
            return UIEdgeInsets(top: 26, left: (UIScreen.main.bounds.width - 316) / 3, bottom: 26, right: (UIScreen.main.bounds.width - 316) / 3)
        }
        return UIEdgeInsets(top: 0, left: (UIScreen.main.bounds.width - 300) / 3, bottom: 0, right: (UIScreen.main.bounds.width - 300) / 3)
    }
}

extension DailyPageViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.collectionView {
            return item.count
        }
        return UploadManager.shared.simplePetInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionView {
            
            guard let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: "Item Cell", for: indexPath) as? ItemCell else { return UICollectionViewCell() }
                
                let index = indexPath.row
                cellA.itemLabel.text = item[index]
                cellA.image.image = UIImage(named: itemImage[index])

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
                
                guard let viewController = UIStoryboard(name: "Daily", bundle: nil).instantiateViewController(identifier: "Clean Page") as? CleanPageViewController else {
                    return
                }
                
                viewController.petID = recordPetID
                show(viewController, sender: nil)
                
            } else if indexPath.row == 1 {
                
                guard let viewController = UIStoryboard(name: "Daily", bundle: nil).instantiateViewController(identifier: "Prevent Page") as? PreventPageViewController else {
                    return
                }
                
                viewController.petID = recordPetID
                show(viewController, sender: nil)
                
            } else if indexPath.row == 2 {
                
                guard let viewController = UIStoryboard(name: "Daily", bundle: nil).instantiateViewController(identifier: "Weight Page") as? WeightPageViewController else {
                    return
                }
                
                viewController.petID = recordPetID
                show(viewController, sender: nil)
                
            } else if indexPath.row == 3 {
                
                guard let viewController = UIStoryboard(name: "Daily", bundle: nil).instantiateViewController(identifier: "Behavior Page") as? BehaviorPageViewController else {
                    return
                }
                
                viewController.petID = recordPetID
                show(viewController, sender: nil)
                
            } else if indexPath.row == 4 {
            
                guard let viewController = UIStoryboard(name: "Medical", bundle: nil).instantiateViewController(identifier: "Diagnosis Page") as? DiagnosisViewController else {
                    return
                }
                
                viewController.petID = recordPetID
                show(viewController, sender: nil)
                
            } else if indexPath.row == 5 {
                
                guard let viewController = UIStoryboard(name: "Medical", bundle: nil).instantiateViewController(identifier: "Medicine Page") as? MedicineViewController else {
                    return
                }
                
                viewController.petID = recordPetID
                show(viewController, sender: nil)
                
            }
            
        } else if collectionView == self.choosePetCollectionView {
            
            navigationTitle.text = "撰寫紀錄"
            chooseView.isHidden = true
            self.collectionView.isHidden = false
            
            recordPetID = UploadManager.shared.simplePetInfo[indexPath.item].petID
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let spring = UISpringTimingParameters(dampingRatio: 0.7, initialVelocity: CGVector(dx: 1.0, dy: 0.2))
        let animator = UIViewPropertyAnimator(duration: 0.5, timingParameters: spring)
               cell.alpha = 0
               cell.transform = CGAffineTransform(translationX: 0, y: 100 * 0.6)
               animator.addAnimations {
                   cell.alpha = 1
                   cell.transform = .identity
                 self.collectionView.layoutIfNeeded()
               }
               animator.startAnimation(afterDelay: 0.1 * Double(indexPath.item))
    }
}
