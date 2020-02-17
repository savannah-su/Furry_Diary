//
//  CleanPageViewController.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/12.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit

class CleanPageViewController: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewButton: VerticalAlignedButton!
    @IBAction func bottomViewButton(_ sender: Any) {}
    @IBOutlet weak var bottomViewLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var petNameCollectionView: UICollectionView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        toDataBase()
    }
    
    let sectionOneLabel = ["洗澡", "毛髮", "指甲", "耳朵", "牙齒"]
    let sectionOneImage = ["洗澡", "毛髮", "指甲", "耳朵", "牙齒"]
    let sectionOneSelected = ["洗澡-selected", "毛髮-selected", "指甲-selected", "耳朵-selected", "牙齒-selected"]
    let sectionTwoLabel = ["碗盤", "小窩", "玩具", "衣物", "外出用品"]
    let sectionTwoImage = ["碗盤", "小窩", "玩具", "衣物", "外出用品"]
    let sectionTwoSelected = ["碗盤-selected", "小窩-selected", "玩具-selected", "衣物-selected", "外出用品-selected"]
    var sectionOneStatus = [false, false, false, false, false]
    var sectionTwoStatus = [false, false, false, false, false]
    
    var enterDate = Date()
    var subItemType = [""]
    var petID = ""
    var doneDate = ""
    var isSwitchOn: Bool = false
    var notiDate = ""
    var notiMemo = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
        
        petNameCollectionView.dataSource = self
        petNameCollectionView.delegate = self
        petNameCollectionView.isHidden = true
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        tableView.separatorColor = .clear
        
        bottomViewButton.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    func toDataBase() {
        
        print(petID)
        print(subItemType)
        print(doneDate)
        print(isSwitchOn)
        print(notiDate)
        print(notiMemo)
        
        UploadManager.shared.uploadData(petID: petID, categoryType: "衛生清潔", date: doneDate, subitem: subItemType, medicineName: "", kilo: "", memo: "", notiOrNot: isSwitchOn ? "true" : "false", notiDate: notiDate, notiText: notiMemo) { result in
            
            switch result {
            case .success(let success):
                print(success)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension CleanPageViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if collectionView == self.collectionView {
            return 2
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if collectionView == self.collectionView {
            
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as? HeaderView else {
                return UICollectionReusableView()
            }
            
            if indexPath.section == 0 {
                header.sectionTitle.text = "關於毛孩"
            } else {
                header.sectionTitle.text = "生活起居"
            }
            return header
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.collectionView {
            return 5
        }
        return UploadManager.shared.simplePetInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionView {
            
            guard let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: "Item Cell", for: indexPath) as? ReuseItemCell else {
                return UICollectionViewCell()
            }
            
            cellA.image.backgroundColor = .white
            
            if indexPath.section == 0 {
                
                cellA.itemLabel.text = sectionOneLabel[indexPath.row]
                
                let index = indexPath.row
                if sectionOneStatus[index] == true {
                    cellA.image.image = UIImage(named: sectionOneSelected[index])
                } else {
                    cellA.image.image = UIImage(named: sectionOneImage[index])
                }
                
            } else if indexPath.section == 1 {
                
                cellA.itemLabel.text = sectionTwoLabel[indexPath.row]
                
                let index = indexPath.row
                if sectionTwoStatus[index] == true {
                    cellA.image.image = UIImage(named: sectionTwoSelected[index])
                } else {
                    cellA.image.image = UIImage(named: sectionTwoImage[index])
                }
            }
            return cellA
            
        } else {
            
            guard let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: "Pet Name Cell", for: indexPath) as? ChoosePetCell else {
                return UICollectionViewCell()
            }
            
            cellB.layer.cornerRadius = 20
            cellB.petName.text = UploadManager.shared.simplePetInfo[indexPath.row].petName
            
            return cellB
        }
    }
}

extension CleanPageViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == self.collectionView {
            return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        } else {
            return UIEdgeInsets()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.collectionView {
            return CGSize(width: 60, height: 85)
        }
        return CGSize(width: 80, height: 50)
    }
}

extension CleanPageViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.collectionView {
            
            if indexPath.section == 0 {
                
                for index in 0 ..< 5 {
                    
                    if index == indexPath.row {
                        
                        sectionOneStatus[index] = true
                        sectionTwoStatus[index] = false
                        
                        subItemType = [sectionOneLabel[index]]
                        
                    } else {
                        sectionOneStatus[index] = false
                        sectionTwoStatus[index] = false
                    }
                }
            } else {
                
                for index in 0 ..< 5 {
                    
                    if index == indexPath.row {
                        
                        sectionOneStatus[index] = false
                        sectionTwoStatus[index] = true
                        
                        subItemType = [sectionTwoLabel[index]]
                        
                    } else {
                        sectionOneStatus[index] = false
                        sectionTwoStatus[index] = false
                    }
                }
            }
            
            collectionView.reloadData()

            tableView.isHidden = true
            bottomViewLabel.isHidden = false
            petNameCollectionView.isHidden = false
            bottomViewLabel.text = "要幫哪個毛孩紀錄呢？"
            
        } else if collectionView == self.petNameCollectionView {
            
            petID = UploadManager.shared.simplePetInfo[indexPath.row].petID
            
            bottomViewLabel.isHidden = true
            tableView.isHidden = false
            self.petNameCollectionView.isHidden = true
        }
    }
    
    func upButtomView() {
        
        let move = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
            
            self.bottomViewConstraint.isActive = false
            self.bottomViewConstraint = self.bottomView.topAnchor.constraint(equalTo: self.topView.bottomAnchor, constant: 250)
            self.bottomViewConstraint.isActive = true
            self.view.layoutIfNeeded()
        }
        move.startAnimation()
        
        bottomViewButton.isHidden = false
    }
    
    func downButtomView() {
        
        let move = UIViewPropertyAnimator(duration: 1, curve: .easeInOut) {
            
            self.bottomViewConstraint.isActive = false
            self.bottomViewConstraint = self.bottomView.topAnchor.constraint(equalTo: self.topView.bottomAnchor, constant: 350)
            self.bottomViewConstraint.isActive = true
            self.view.layoutIfNeeded()
        }
        move.startAnimation()
        
        bottomViewButton.isHidden = true
        
    }
    
}

extension CleanPageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 1 && isSwitchOn == true {
            return 140
        }
        return 40
    }
}

extension CleanPageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Enter Cell", for: indexPath) as? EnterInfoCell else {
                return UITableViewCell()
            }
            cell.titleLabel.text = "清潔日期"
            cell.contentText.placeholder = "選擇本次清洗日期"
            cell.textFieldType = .date(enterDate, "yyyy-MM-dd")
            cell.touchHandler = { [weak self] text in
                
                self?.doneDate = text
            }
            
            return cell
            
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Noti Cell", for: indexPath) as? NotiCell else {
                return UITableViewCell()
            }
            
            cell.notiSwitch.addTarget(self, action: #selector(changeSwitch), for: .valueChanged)
            cell.textFieldType = .normal
            cell.textFieldType = .date(Date(), "yyyy-MM-dd")
            cell.touchHandler = { [weak self] text in
                
                //用"-"切開String，2020-01-01的count是3
                let date = text.components(separatedBy: "-")
                
                if date.count == 3 {
                    self?.notiDate = text
                } else {
                    self?.notiMemo = text
                }
            }
            return cell
        }
    }
    
    @objc func changeSwitch() {
        
        isSwitchOn = !isSwitchOn
        
        tableView.reloadData()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: doneDate) else {
            return
        }
        enterDate = date
    }
}
