//
//  DiagnosisViewController.swift
//  Furry
//
//  Created by Savannah Su on 2020/2/29.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit

class DiagnosisViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var saveButton: VerticalAlignedButton!
    @IBAction func saveButton(_ sender: Any) {
        toDatabase()
    }
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
    
    var item = [DailyPageContent(lbl: "就診", image: "就診", selectedImage: "就診-selected"),
                DailyPageContent(lbl: "手術", image: "手術", selectedImage: "手術-selected"),
                DailyPageContent(lbl: "例行檢查", image: "例行檢查", selectedImage: "例行檢查-selected")]
    
    var petID = ""
    var subItemType = [""]
    var desc = ""
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

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        topView.layer.cornerRadius = topView.bounds.height / 2
        bottomView.layer.cornerRadius = bottomView.bounds.height / 2
        
        tableView.separatorColor = .clear
    }
    
    func toDatabase() {
        
        guard let doneDate = dateFormatter.date(from: doneDate) else {
            return
        }
        
        let data = Record(
            categoryType: "醫療紀錄",
            subitem: subItemType,
            medicineName: desc,
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
        LocalNotiManager.shared.setupNoti(notiDate: notiDate.timeIntervalSinceNow, type: "毛孩的\(self.subItemType[0])醫療通知", meaasge: notiMemo == "" ? "記得追蹤毛孩的醫療況狀唷！" : notiMemo)
        }
    }
    
    func checkUpdateStatus() {
        
        if isSwitchOn {
            saveButton.isEnabled = notiDate > doneDate && notiDate != dateFormatter.string(from: Date()) && petID != ""
            saveButton.setTitleColor(UIColor.G4, for: .normal)
        } else {
            saveButton.isEnabled = desc != "" && petID != ""
            saveButton.setTitleColor(UIColor.G4, for: .normal)
        }
        saveButton.setTitleColor(UIColor.lightGray, for: .disabled)
    }
}

extension DiagnosisViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return item.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Item Cell", for: indexPath) as? ReuseItemCell else {
            return UICollectionViewCell()
        }
        
        cell.setCell(model: item[indexPath.item])
        
        cell.image.image = item[indexPath.item].status ? UIImage(named: item[indexPath.item].selectedImage) : UIImage(named: item[indexPath.item].image)

        return cell
    }
    
}

extension DiagnosisViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        guard let cell = collectionView.cellForItem(at: indexPath) as?
//        ReuseItemCell else { return }
//        toggle狀態改變
//        itemStatus[indexPath.row].toggle()
//        let isSelected = itemStatus[indexPath.row]
//        cell.image.image = isSelected
//            ? UIImage(named: itemSelected[indexPath.row])
//            : UIImage(named: itemImage[indexPath.row])
        
        for index in 0 ..< item.count {

        if index == indexPath.item {
            
            item[index].status = true
            subItemType = [item[index].titel]
            
        } else {
            item[index].status = false
            }
        }
        collectionView.reloadData()
        
        bottomLabel.isHidden = true
        tableView.isHidden = false
    }
}

extension DiagnosisViewController: UICollectionViewDelegateFlowLayout {
    
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

extension DiagnosisViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 2 && isSwitchOn == true {
            return 140
        }
        return 40
    }
}

extension DiagnosisViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Enter Cell", for: indexPath) as? EnterInfoCell else {
                return UITableViewCell()
            }
            
            cell.titleLabel.text = "施作時間"
            cell.contentText.placeholder = "選擇本次施作時間"
            cell.textFieldType = .date(doneDate, "yyyy-MM-dd")
            cell.dateUpdateHandler = { [weak self] text in
                self?.doneDate = text
            }
            
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Enter Cell", for: indexPath) as? EnterInfoCell else {
                return UITableViewCell()
            }
            cell.titleLabel.text = "內容簡述"
            cell.contentText.placeholder = "例：結紮手術、抽血等"
            cell.contentText.text = desc
            cell.textFieldType = .normal
            cell.contentUpdateHandler = { [weak self] text in
                self?.desc = text
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
