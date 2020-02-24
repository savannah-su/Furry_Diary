//
//  BehaviorPageViewController.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/11.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit
import JGProgressHUD

class BehaviorPageViewController: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        toDataBase()
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomViewLabel: UILabel!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var firstBar: UIView!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var secondBar: UIView!
    @IBOutlet weak var memoTextView: UITextView!
    
    let datePiker = UIDatePicker()
    let showDateFormatter = DateFormatter()
    
    let itemLabel = ["嘔吐", "拉肚子", "嗆咳", "打噴嚏", "搔癢", "外傷", "焦躁", "食慾不佳", "精神不佳", "其他"]
    
    var subItemType = [""]
    var petID = ""
    var doneDate = ""
    var memo = ""
    var selectDisease: [String] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        topView.layer.cornerRadius = topView.bounds.height / 2
        bottomView.layer.cornerRadius = bottomView.bounds.height / 2
        
        memoTextView.delegate = self
        collectionView.allowsMultipleSelection = true
        setupTextView()
        
        setupDatePiker()
        
        hideEnterBox()
        // Do any additional setup after loading the view.
    }
    
    func uploadSuccess() {
           let hud = JGProgressHUD(style: .dark)
           hud.textLabel.text = "Success!"
           hud.show(in: self.view)
           hud.dismiss(afterDelay: 3.0)
           hud.indicatorView = JGProgressHUDSuccessIndicatorView()
       }
    
    func toDataBase() {
        
        getInfo()
        
        print(petID)
        print(subItemType)
        print(doneDate)
        print(memo)
        
        UploadManager.shared.uploadData(petID: petID, categoryType: "行為症狀", date: datePiker.date, subitem: subItemType, medicineName: "", kilo: "", memo: memo, notiOrNot: "", notiDate: "", notiText: "") { result in
            
            switch result {
            case .success(let success):
                print(success)
                self.uploadSuccess()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getInfo() {
        
        guard let enterDate = timeTextField.text else {
            return
        }
        
        doneDate = enterDate
        
        guard let enterMemo = memoTextView.text else {
            return
        }
        
        memo = enterMemo
    }
    
    func showEnterBox() {
        
        dateLabel.isHidden = false
        firstBar.isHidden = false
        timeTextField.isHidden = false
        memoLabel.isHidden = false
        secondBar.isHidden = false
        memoTextView.isHidden = false
    }
    
    func hideEnterBox() {
        
        dateLabel.isHidden = true
        firstBar.isHidden = true
        timeTextField.isHidden = true
        memoLabel.isHidden = true
        secondBar.isHidden = true
        memoTextView.isHidden = true
    }
    
    func setupDatePiker() {
        
        showDateFormatter.dateFormat = "yyyy-MM-dd"
        datePiker.datePickerMode = .date
        datePiker.locale = Locale(identifier: "zh_TW")
        datePiker.addTarget(self, action: #selector(changeDate), for: .valueChanged)
        timeTextField.inputView = datePiker
        changeDate()
    }
    
    @objc func changeDate() {
        timeTextField.text = showDateFormatter.string(from: datePiker.date)
    }
    
    func setupTextView() {
        memoTextView.text = "輸入相關敘述或其他事件"
        memoTextView.textColor = UIColor(red: 211/255.0, green: 211/255.0, blue: 212/255.0, alpha: 1)
    }
    
}

extension BehaviorPageViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as?
            ReuseItemCell else { return }
        
        guard let disease = cell.itemLabel.text else { return }
        
        if selectDisease.contains(disease) {
            cell.image.image = UIImage(named: "icon")
            guard let order = selectDisease.firstIndex(of: disease) else { return }
            selectDisease.remove(at: order)
            
        } else {
            
            selectDisease.append(disease)
            cell.image.image = UIImage(named: "icon-selected")
        }
        
        subItemType = selectDisease
        
        showEnterBox()
        bottomViewLabel.isHidden = true
    }
}

extension BehaviorPageViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let inset = (UIScreen.main.bounds.height - topView.bounds.height - 208) / 2
        return UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
}

extension BehaviorPageViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemLabel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: "Item Cell", for: indexPath) as? ReuseItemCell else { return UICollectionViewCell() }
        
        cellA.itemLabel.text = itemLabel[indexPath.item]
        cellA.image.image = UIImage(named: "icon")
        return cellA
    }
}

extension BehaviorPageViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if memoTextView.textColor == UIColor(red: 211/255.0, green: 211/255.0, blue: 212/255.0, alpha: 1) {
            memoTextView.text = nil
            memoTextView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if memoTextView.text.isEmpty {
            memoTextView.text = "輸入相關敘述或其他事件"
            memoTextView.textColor = UIColor(red: 211/255.0, green: 211/255.0, blue: 212/255.0, alpha: 1)
        }
    }
}
