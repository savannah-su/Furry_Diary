//
//  MedicalViewController.swift
//  Furry
//
//  Created by Savannah Su on 2020/2/29.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit
import JGProgressHUD

class MedicineViewController: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var saveButton: UIButton!
    @IBAction func saveButton(_ sender: Any) {
        toDatabase()
    }
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            self.collectionView.dataSource = self
            self.collectionView.delegate = self
        }
    }
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
        }
    }
    
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    let itemLabel = ["外用藥", "內用藥"]
    let itemImage = ["外用藥", "內用藥"]
    let itemSelected = ["外用藥-selected", "內用藥-selected"]
    var itemStatus = [false, false]
    
    var petID = ""
    var subItemType = [""]
    var medicine = ""
    var notiMemo = ""
    lazy var doneDate = self.dateFormatter.string(from: Date())
    lazy var notiDate = self.dateFormatter.string(from: Date())
    var isSwitchOn: Bool = false {
        didSet {
            checkUpdateStatus()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.isHidden = true
        saveButton.isEnabled = false
        saveButton.setTitleColor(UIColor.lightGray, for: .disabled)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        topView.layer.cornerRadius = topView.bounds.height / 2
        bottomView.layer.cornerRadius = bottomView.bounds.height / 2
        
        tableView.separatorColor = .clear
    }
    
    func uploadSuccess() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Success!"
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 3.0)
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
    }
    
    func toDatabase() {
        
        guard let doneDate = dateFormatter.date(from: doneDate) else { return }
        
        let data = Record(
            categoryType: "用藥紀錄",
            subitem: subItemType,
            medicineName: medicine,
            kilo: "", memo: "",
            date: doneDate,
            notiOrNot: isSwitchOn ? "true" : "false",
            notiDate: notiDate == dateFormatter.string(from: doneDate) ? "" : notiDate,
            notiText: notiMemo
        )
        
        UploadManager.shared.uploadData(petID: petID, data: data) { result in
            
            switch result {
            case .success(let success):
                print(success)
                self.uploadSuccess()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        guard let notiDate = dateFormatter.date(from: notiDate) else {
            return
        }
        
        if isSwitchOn {
            LocalNotiManager.shared.setupNoti(notiDate: notiDate.timeIntervalSinceNow, type: "毛孩的\(self.subItemType[0])通知", meaasge: notiMemo == "" ? "記得協助毛孩用藥唷！" : notiMemo)
        }
    }
    
    func checkUpdateStatus() {
        
        if isSwitchOn {
            saveButton.isEnabled = notiDate > doneDate
            saveButton.setTitleColor(UIColor.G4, for: .normal)
        } else {
            saveButton.isEnabled = medicine != ""
            saveButton.setTitleColor(UIColor.G4, for: .normal)
        }
        saveButton.setTitleColor(UIColor.lightGray, for: .disabled)
    }
}

extension MedicineViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        for index in 0 ..< itemStatus.count {
            
            if index == indexPath.item {
                itemStatus[index] = true
                subItemType = [itemLabel[index]]
            } else {
                itemStatus[index] = false
            }
        }
        collectionView.reloadData()
        
        bottomLabel.isHidden = true
        tableView.isHidden = false
    }
    
}

extension MedicineViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 70, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        let spacing = (UIScreen.main.bounds.width - 140) / 3
        
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let inset = (UIScreen.main.bounds.height - topView.bounds.height - 100) / 2
        let spacing = (UIScreen.main.bounds.width - 140) / 3
        
            return UIEdgeInsets(top: inset, left: spacing, bottom: inset, right: spacing)
    }
}

extension MedicineViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemLabel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Item Cell", for: indexPath) as? ReuseItemCell else {
            return UICollectionViewCell()
        }
        
        cell.itemLabel.text = itemLabel[indexPath.item]
        
        let isCellSelected = itemStatus[indexPath.item]
        
        cell.image.image = isCellSelected
            ? UIImage(named: itemSelected[indexPath.item])
            : UIImage(named: itemImage[indexPath.item])
        
        return cell
    }
}

extension MedicineViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 2 && isSwitchOn == true {
            return 140
        }
        return 40
    }
}

extension MedicineViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Enter Cell", for: indexPath) as? EnterInfoCell else {
                return UITableViewCell()
            }
            
            cell.titleLabel.text = "服藥時間"
            cell.contentText.placeholder = "選擇本次服藥時間"
            cell.textFieldType = .date(doneDate, "yyyy-MM-dd")
            cell.dateUpdateHandler = { [weak self] text in
                self?.doneDate = text
            }
            
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Enter Cell", for: indexPath) as? EnterInfoCell else {
                return UITableViewCell()
            }
            cell.titleLabel.text = "藥物及症狀"
            cell.contentText.placeholder = "例：Tacrolimus/皮膚過敏"
            cell.contentText.text = medicine
            cell.textFieldType = .normal
            cell.contentUpdateHandler = { [weak self] text in
                self?.medicine = text
                self?.checkUpdateStatus()
            }
            
            return cell
            
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Noti Cell", for: indexPath) as? NotiCell else {
                return UITableViewCell()
            }
            cell.notiSwitch.addTarget(self, action: #selector(changeSwitch), for: .valueChanged)
            cell.notiText.text = notiMemo
            cell.textFieldType = .date(notiDate, "yyyy-MM-dd")
            cell.dateUpdateHandler = { [weak self] text in
                self?.notiDate = text
                self?.checkUpdateStatus()
            }

            cell.contentUpdateHandler = { [weak self] text in
                self?.notiMemo = text
            }
            
            return cell
        }
    }
    
    @objc func changeSwitch() {
        
        saveButton.isEnabled = false
        isSwitchOn = !isSwitchOn
        tableView.reloadData()
    }
}
