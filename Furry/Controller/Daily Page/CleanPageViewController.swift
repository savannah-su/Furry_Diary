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
    @IBOutlet weak var bottomViewButton: VerticalAlignedButton!
    @IBAction func bottomViewButton(_ sender: Any) {}
    @IBOutlet weak var bottomViewLabel: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.dataSource = self
            self.tableView.delegate = self
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            self.collectionView.dataSource = self
            self.collectionView.delegate = self
        }
    }
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var saveButton: VerticalAlignedButton!
    @IBAction func saveButton(_ sender: Any) {
        
        toDataBase()
    }
    
    var sectionOne = [DailyPageContent(lbl: "洗澡", image: "洗澡", selectedImage: "洗澡-selected"),
                      DailyPageContent(lbl: "毛髮", image: "毛髮", selectedImage: "毛髮-selected"),
                      DailyPageContent(lbl: "指甲", image: "指甲", selectedImage: "指甲-selected"),
                      DailyPageContent(lbl: "耳朵", image: "耳朵", selectedImage: "耳朵-selected"),
                      DailyPageContent(lbl: "牙齒", image: "牙齒", selectedImage: "牙齒-selected")]
    
    var sectionTwo = [DailyPageContent(lbl: "碗盤", image: "碗盤", selectedImage: "碗盤-selected"),
                      DailyPageContent(lbl: "小窩", image: "小窩", selectedImage: "小窩-selected"),
                      DailyPageContent(lbl: "玩具", image: "玩具", selectedImage: "玩具-selected"),
                      DailyPageContent(lbl: "衣物", image: "衣物", selectedImage: "衣物-selected"),
                      DailyPageContent(lbl: "外出用品", image: "外出用品", selectedImage: "外出用品-selected")]
    
    var petID = ""
    
    var subItemType = [""]
    
    lazy var doneDate = self.dateFormatter.string(from: Date())
    
    var isSwitchOn: Bool = false {
        didSet {
            checkUpdateStatus()
        }
    }
    
    lazy var notiDate = self.dateFormatter.string(from: Date()) 
    
    var notiMemo = ""
    
    var dateFormatter: DateFormatter = {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.isHidden = true
        tableView.separatorColor = .clear

        saveButton.isEnabled = false
        saveButton.setTitleColor(UIColor.lightGray, for: .disabled)
        
        bottomViewButton.isHidden = true
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        topView.layer.cornerRadius = topView.bounds.height / 2
        bottomView.layer.cornerRadius = bottomView.bounds.height / 2
    }
    
    func toDataBase() {
        
        guard let doneDate = dateFormatter.date(from: doneDate) else {
            return
        }
        
        let data = Record(
            categoryType: "衛生清潔",
            subitem: subItemType,
            medicineName: "",
            kilo: "",
            memo: "",
            date: doneDate,
            notiOrNot: isSwitchOn ? "true" : "false",
            notiDate: notiDate == dateFormatter.string(from: doneDate) ? "" : notiDate,
            notiText: notiMemo
        )
        
        UploadManager.shared.uploadData(petID: petID, data: data) { result in
            
            switch result {
            case .success(let success):
                UploadManager.shared.uploadSuccess(text: "上傳成功！")
                print(success)
            case .failure(let error):
                UploadManager.shared.uploadFail(text: "上傳失敗！")
                print(error.localizedDescription)
            }
        }
        
        guard let notiDate = dateFormatter.date(from: notiDate) else {
            return
        }
        
        if isSwitchOn {
            LocalNotiManager.shared.setupNoti(notiDate: 5, type: "毛孩的\(self.subItemType[0])清潔通知", meaasge: notiMemo == "" ? "記得協助毛孩用藥唷！" : notiMemo)
        }
    }
    
    func checkUpdateStatus() {
        
        if isSwitchOn {
            saveButton.isEnabled = notiDate > doneDate && notiDate != dateFormatter.string(from: Date())
            saveButton.setTitleColor(UIColor.G4, for: .normal)
            
        } else {
            saveButton.isEnabled = true
            saveButton.setTitleColor(UIColor.G4, for: .normal)
        }
        saveButton.setTitleColor(UIColor.lightGray, for: .disabled)
    }
}

extension CleanPageViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
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
        return sectionOne.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: "Item Cell", for: indexPath) as? ReuseItemCell else {
            return UICollectionViewCell()
        }
        
        cellA.image.backgroundColor = .white
        
        if indexPath.section == 0 {
            
            cellA.setCell(model: sectionOne[indexPath.row])
            
            let index = indexPath.row
            cellA.image.image = sectionOne[index].status ? UIImage(named: sectionOne[index].selectedImage) : UIImage(named: sectionOne[index].image)
            
        } else if indexPath.section == 1 {
            
            cellA.setCell(model: sectionTwo[indexPath.row])
            
            let index = indexPath.row
            cellA.image.image = sectionTwo[index].status ? UIImage(named: sectionTwo[index].selectedImage) : UIImage(named: sectionTwo[index].image)
        }
        return cellA
    }
}

extension CleanPageViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 85)
    }
    
}

extension CleanPageViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            for index in 0 ..< 5 {
                
                if index == indexPath.row {
                    
                    sectionOne[index].status = true
                    sectionTwo[index].status = false
                    subItemType = [sectionOne[index].titel]
                    
                } else {
                    
                    sectionOne[index].status = false
                    sectionTwo[index].status = false
                }
            }
            
        } else {
            
            for index in 0 ..< 5 {
                
                if index == indexPath.row {
                    
                    sectionOne[index].status = false
                    sectionTwo[index].status = true
                    subItemType = [sectionOne[index].titel]
                    
                } else {
                    
                    sectionOne[index].status = false
                    sectionTwo[index].status = false
                }
            }
        }
        
        collectionView.reloadData()
        
        tableView.isHidden = false
        bottomViewLabel.isHidden = true
        
        self.checkUpdateStatus()
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
            cell.textFieldType = .date(doneDate, "yyyy-MM-dd")
            cell.dateUpdateHandler = { [weak self] text in
                
                self?.doneDate = text
                self?.checkUpdateStatus()
            }
            
            return cell
            
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Noti Cell", for: indexPath) as? NotiCell else {
                return UITableViewCell()
            }

            cell.notiSwitch.addTarget(self, action: #selector(changeSwitch), for: .valueChanged)
            
            cell.textFieldType = .date(notiDate, "yyyy-MM-dd")
            
            cell.dateUpdateHandler = { [weak self] text in
                self?.notiDate = text
                self?.checkUpdateStatus()
            }
            
            cell.contentUpdateHandler = { [weak self] text in
                
                self?.notiMemo = text
            }
            
//            cell.touchHandler = { [weak self] text in
//                
//                //用"-"切開String，2020-01-01的count是3
//                let date = text.components(separatedBy: "-")
//                
//                if date.count == 3 {
//                    self?.notiDate = text
//                } else {
//                    self?.notiMemo = text
//                }
//            }
            return cell
        }
    }
    
    @objc func changeSwitch() {
        
        saveButton.isEnabled = false
        
        isSwitchOn = !isSwitchOn
        
        tableView.reloadData()
    }
}
