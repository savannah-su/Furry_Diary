//
//  NotiCell.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/13.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit

class NotiCell: UITableViewCell {

    @IBOutlet weak var notiSwitch: UISwitch!
    @IBOutlet weak var dateText: UITextField!
    @IBOutlet weak var notiText: UITextField!
    
    var touchHandler: ( (String) -> Void )?
    
    var pickerData: [String] = []
    
    lazy var pickerView: UIPickerView = {
        
        let picker = UIPickerView()
        
        picker.delegate = self
        
        picker.dataSource = self
        
        return picker
    }()
    
    lazy var datePicker: UIDatePicker = {
        
        let picker = UIDatePicker()
        
        picker.datePickerMode = .date
        
        picker.locale = Locale(identifier: "zh_TW")
        
        picker.addTarget(self, action: #selector(didSeletedDate(_:)), for: .valueChanged)
        
        return picker
    }()
    
    var textFieldType: TextFieldType = .normal {
        
        
        didSet {
            
            switch textFieldType {
                
            case .date(let dateString, let format):
                
                dateText.inputView = datePicker
                
                datePicker.date = dateFormatter.date(from: dateString) ?? Date()
                
                dateFormatter.dateFormat = format
                
                dateText.text = dateString
           
            case .normal:
                
                notiText.inputView = nil
            }
        }
    }
    
    lazy var dateFormatter = DateFormatter()
    
    var pickerViewDatas: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateText.delegate = self
        notiText.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func didSeletedDate(_ sender: UIDatePicker) {
           
           dateText.text = dateFormatter.string(from: sender.date)
       }
}

extension NotiCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let text = textField.text else {
            return
        }
        touchHandler?(text)
    }
}

extension NotiCell: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dateText.text = pickerData[row]
    }
}

extension NotiCell: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
}
