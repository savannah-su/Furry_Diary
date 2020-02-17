//
//  PreventPageViewController.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/12.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit

class PreventPageViewController: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var buttomViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewButton: VerticalAlignedButton!
    @IBAction func bottomViewButton(_ sender: Any) {
        //        downButtomView()
    }
    @IBOutlet weak var bottomViewLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var petNameCollectionView: UICollectionView!
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func saveButton(_ sender: Any) {
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
    let itemLabel = ["疫苗施打", "體內驅蟲", "體外驅蟲"]
    let itemImage = ["疫苗施打", "體內驅蟲", "體外驅蟲"]
    let selectedImage = ["疫苗施打-selected", "體內驅蟲-selected", "體外驅蟲-selected"]
    var itemCellStatus = [false, false, false]
    var isSwitchOn: Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        tableView.dataSource = self
        tableView.delegate = self
        
        petNameCollectionView.dataSource = self
        petNameCollectionView.delegate = self
        petNameCollectionView.isHidden = true
        
        collectionView.allowsMultipleSelection = false
        
        bottomViewButton.isHidden = true
        
        tableView.separatorColor = .clear
        tableView.isHidden = true
        
        // Do any additional setup after loading the view.
    }
}

extension PreventPageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if indexPath.row == 2 && isSwitchOn == true {
            return 140
        }
        
        return 40
        
    }
}

extension PreventPageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Enter Cell", for: indexPath) as? EnterInfoCell else {
                return UITableViewCell()
            }
            cell.titleLabel.text = "藥劑名稱"
            cell.contentText.placeholder = "例：三合一疫苗、蚤不到"
            cell.textFieldType = .normal
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Enter Cell", for: indexPath) as? EnterInfoCell else {
                return UITableViewCell()
            }
            cell.titleLabel.text = "施作時間"
            cell.contentText.placeholder = "選擇本次施作時間"
            cell.textFieldType = .date(Date(), "yyyy-MM-dd")
            return cell
            
            
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Noti Cell", for: indexPath) as? NotiCell else {
                return UITableViewCell()
            }
            cell.notiSwitch.addTarget(self, action: #selector(changeSwitch), for: .valueChanged)
            cell.textFieldType = .date(Date(), "yyyy-MM-dd")
            cell.textFieldType = .normal
            return cell
        }
    }
    
    @objc func changeSwitch() {
        
        isSwitchOn = !isSwitchOn
        tableView.reloadData()
    }
}

extension PreventPageViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.collectionView {
            return CGSize(width: 70, height: 100)
        }
        return CGSize(width: 80, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == self.collectionView {
            return 34
        }
        return CGFloat()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == self.collectionView {
            return UIEdgeInsets(top: 98, left: 51, bottom: 98, right: 51)
        }
        return UIEdgeInsets()
    }
}

extension PreventPageViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return 3
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionView {
            
            guard let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: "Item Cell", for: indexPath) as? ReuseItemCell else { return UICollectionViewCell() }
            
            for index in 0 ... 2 {
                
                let index = indexPath.row
                cellA.itemLabel.text = itemLabel[index]
                
                if itemCellStatus[index] == true {
                    cellA.image.image = UIImage(named: selectedImage[index])
                } else {
                    cellA.image.image = UIImage(named: itemImage[index])
                }
            }
            return cellA
            
        } else {
            
            guard let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: "Pet Name Cell", for: indexPath) as? ChoosePetCell else {
                return UICollectionViewCell()
            }
            
            return cellB
        }
    }
}

extension PreventPageViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.collectionView {
            
            for index in 0 ..< itemCellStatus.count {
                
                if index == indexPath.row {
                    itemCellStatus[index] = true
                } else {
                    itemCellStatus[index] = false
                }
            }
            collectionView.reloadData()
            tableView.reloadData()
            
            //        upButtomView()
            
            bottomViewLabel.isHidden = false
            bottomViewLabel.text = "要幫哪個毛孩紀錄呢？"
            tableView.isHidden = true
            petNameCollectionView.isHidden = false
            
        } else if collectionView == self.petNameCollectionView {
            
            bottomViewLabel.isHidden = true
            tableView.isHidden = false
            self.petNameCollectionView.isHidden = true
        }
    }
    
    func upButtomView() {
        
        let move = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
            
            self.buttomViewConstraint.isActive = false
            self.buttomViewConstraint = self.bottomView.topAnchor.constraint(equalTo: self.topView.bottomAnchor, constant: 200)
            self.buttomViewConstraint.isActive = true
            self.view.layoutIfNeeded()
        }
        move.startAnimation()
        
        bottomViewButton.isHidden = false
    }
    
    func downButtomView() {
        
        let move = UIViewPropertyAnimator(duration: 1, curve: .easeInOut) {
            
            self.buttomViewConstraint.isActive = false
            self.buttomViewConstraint = self.bottomView.topAnchor.constraint(equalTo: self.topView.bottomAnchor, constant: 304)
            self.buttomViewConstraint.isActive = true
            self.view.layoutIfNeeded()
        }
        move.startAnimation()
        
        bottomViewButton.isHidden = true
        
    }
}
