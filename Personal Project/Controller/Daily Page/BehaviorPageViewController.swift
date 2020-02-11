//
//  BehaviorPageViewController.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/11.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit

class BehaviorPageViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var memoTextView: UITextView!
    let datePiker = UIDatePicker()
    let showDateFormatter = DateFormatter()
    
    let itemLabel = ["嘔吐", "嗆咳", "外傷", "搔癢", "流眼淚", "打噴嚏", "呼吸不順", "拉肚子", "食慾不佳", "精神不佳"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupTextView()
        
        setupDatePiker()

        // Do any additional setup after loading the view.
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
        
        memoTextView.delegate = self
        memoTextView.text = "輸入寵物喜好及個性"
        memoTextView.textColor = UIColor(red: 211/255.0, green: 211/255.0, blue: 212/255.0, alpha: 1)
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
        return UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
}

extension BehaviorPageViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Item Cell", for: indexPath) as? BehavItemCell else { return UICollectionViewCell() }
        
        for index in 0 ... 9 {
            
            let index = indexPath.row
            cell.itemLabel.text = itemLabel[index]
            
        }
        return cell
    }
}

extension BehaviorPageViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if memoTextView.textColor == UIColor.lightGray {
            memoTextView.text = nil
            memoTextView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if memoTextView.text.isEmpty {
            memoTextView.text = "輸入相關敘述或其他事件"
            memoTextView.textColor = UIColor.lightGray
        }
    }
}
