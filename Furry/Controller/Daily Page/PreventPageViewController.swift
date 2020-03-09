//
//  PreventPageViewController.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/12.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit
import JGProgressHUD

class PreventPageViewController: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var buttomViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewButton: VerticalAlignedButton!
    @IBAction func bottomViewButton(_ sender: Any) {}
    @IBOutlet weak var bottomViewLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var saveButton: VerticalAlignedButton!
    @IBAction func saveButton(_ sender: Any) {
        toDataBase()
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
    let itemLabel = ["疫苗施打", "體內驅蟲", "體外驅蟲"]
    let itemImage = ["疫苗施打", "體內驅蟲", "體外驅蟲"]
    let selectedImage = ["疫苗施打-selected", "體內驅蟲-selected", "體外驅蟲-selected"]
    var itemCellStatus = [false, false, false]
    
    var petID = ""
    
    var subItemType = [""]
    
    var medicineName = ""
    
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
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = .clear
        tableView.isHidden = true
        
        collectionView.allowsMultipleSelection = false
        
        bottomViewButton.isHidden = true
        
        saveButton.isEnabled = false
        saveButton.setTitleColor(UIColor.lightGray, for: .disabled)
        
//        LocalNotiManager.shared.setupNoti(notiDate: 30 , type: "毛孩的清潔通知", meaasge: "Really")
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        topView.layer.cornerRadius = topView.bounds.height / 2
        bottomView.layer.cornerRadius = bottomView.bounds.height / 2
        
    }
    
    func uploadSuccess() {
           let hud = JGProgressHUD(style: .dark)
           hud.textLabel.text = "Success!"
           hud.show(in: self.view)
           hud.dismiss(afterDelay: 3.0)
           hud.indicatorView = JGProgressHUDSuccessIndicatorView()
       }
    
    func toDataBase() {
        
        guard let doneDate = dateFormatter.date(from: doneDate) else { return }
        
        let data = Record(
            categoryType: "預防計畫",
            subitem: subItemType,
            medicineName: medicineName,
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
        LocalNotiManager.shared.setupNoti(notiDate: notiDate.timeIntervalSinceNow, type: "毛孩的\(self.subItemType[0])通知", meaasge: notiMemo == "" ? "記得毛孩的預防計畫唷！" : notiMemo)
        }
    }
    
    func checkUpdateStatus() {
        
        if isSwitchOn {
            saveButton.isEnabled = notiDate > doneDate
            saveButton.setTitleColor(UIColor.G4, for: .normal)
            
        } else {
            saveButton.isEnabled = medicineName != ""
            saveButton.setTitleColor(UIColor.G4, for: .normal)
        }
        saveButton.setTitleColor(UIColor.lightGray, for: .disabled)
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
            cell.contentText.text = medicineName
            cell.textFieldType = .normal
            cell.contentUpdateHandler = { [weak self] text in
                
                self?.medicineName = text
                
                self?.checkUpdateStatus()
            }
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Enter Cell", for: indexPath) as? EnterInfoCell else {
                return UITableViewCell()
            }
            cell.titleLabel.text = "施作時間"
            cell.contentText.placeholder = "選擇本次施作時間"
            cell.textFieldType = .date(doneDate, "yyyy-MM-dd")
            cell.dateUpdateHandler = { [weak self] text in
                
                self?.doneDate = text
                
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

extension PreventPageViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 70, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return (UIScreen.main.bounds.width - 310) / 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let inset = (UIScreen.main.bounds.height - topView.bounds.height - 100) / 2
        
            return UIEdgeInsets(top: inset, left: 50, bottom: inset, right: 50)
    }
}

extension PreventPageViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Item Cell", for: indexPath) as? ReuseItemCell else { return UICollectionViewCell() }
        
        let index = indexPath.row
        cell.itemLabel.text = itemLabel[index]
        
        if itemCellStatus[index] == true {
            cell.image.image = UIImage(named: selectedImage[index])
        } else {
            cell.image.image = UIImage(named: itemImage[index])
        }
        return cell
    }
}

extension PreventPageViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
            for index in 0 ..< itemCellStatus.count {
                
                if index == indexPath.row {
                    
                    itemCellStatus[index] = true
                    
                    subItemType = [itemLabel[index]]
                } else {
                    itemCellStatus[index] = false
                }
            }
            collectionView.reloadData()
            
            bottomViewLabel.isHidden = true
            tableView.isHidden = false
            
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
