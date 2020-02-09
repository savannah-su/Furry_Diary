//
//  textFieldTableViewCell.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/2.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit

enum KeyBoardType {
    
    case date(Date, String)
    
    case picker([String])
    
    case normal
}

class TextFieldCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentField: UITextField!
    
    var touchHandler: ( (String) -> Void )?
    
    lazy var datePiker: UIDatePicker = {
        
        let picker = UIDatePicker()
        
        picker.locale = Locale(identifier: "zh_TW")
        
        picker.datePickerMode = .date
        
        picker.addTarget(self, action: #selector(didSeletedDate(_:)), for: .valueChanged)
        
        return picker
    }()
    
    lazy var pickerView: UIPickerView = {
        
        let picker = UIPickerView()
    
        picker.dataSource = self
        
        picker.delegate = self
        
        return picker
    }()
        
    lazy var dateFormatter = DateFormatter()
    
    var pickerViewDatas: [String] = []
    
    var keyboardType: KeyBoardType = .normal {
        
        didSet {
            
            switch keyboardType {
            
            case .date(let date, let format):
                
                contentField.inputView = datePiker
                
                datePiker.date = date
                
                dateFormatter.dateFormat = format
                
                contentField.text = dateFormatter.string(from: date)
                
            case .picker(let datas):
                
                contentField.inputView = pickerView
                
                pickerViewDatas = datas
                
            case .normal:
                
                contentField.inputView = nil
            
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func didSeletedDate(_ sender: UIDatePicker) {
        
        contentField.text = dateFormatter.string(from: sender.date)
    }

}

extension TextFieldCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
        textField.resignFirstResponder()
        
        print("456")
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let text = textField.text else { return }
        
        touchHandler?(text)
        
        print("123")
    }
}

extension TextFieldCell: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        contentField.text = pickerViewDatas[row]
    }
}

extension TextFieldCell: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
    
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return pickerViewDatas.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerViewDatas[row]
    }
}
