//
//  EnterInfoCell.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/13.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit

enum TextFieldType {
    
    case date(Date, String)
    
    case normal
}

class EnterInfoCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentText: UITextField!
    
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
        
        picker.addTarget(self, action: #selector(didSelectedDate(_:)), for: .valueChanged)
        
        return picker
    }()
    
    lazy var dateFormatter = DateFormatter()
    
    var textFieldType: TextFieldType = .normal {
        
        didSet {
            
            switch textFieldType {
                
            case .date(let date, let format):
                
                contentText.inputView = datePicker
                
                datePicker.date = date
                
                dateFormatter.dateFormat = format
                
                contentText.text = dateFormatter.string(from: date)
           
            case .normal:
                
                contentText.inputView = nil
            }
        }
    }
    
    
    
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func didSelectedDate(_ sender: UIDatePicker) {
           
           contentText.text = dateFormatter.string(from: sender.date)
       }

}

extension EnterInfoCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let text = textField.text else {
            return
        }
        
        touchHandler?(text)
    }
}

extension EnterInfoCell: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        contentText.text = pickerData[row]
    }
}

extension EnterInfoCell: UIPickerViewDataSource {
    
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
