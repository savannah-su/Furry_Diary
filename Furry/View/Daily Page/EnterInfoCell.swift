//
//  EnterInfoCell.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/13.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit

enum TextFieldType {
    
    case date(String, String)
    
    case normal
}

class EnterInfoCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentText: UITextField!
    
    var dateUpdateHandler: ( (String) -> Void )?
    
    var contentUpdateHandler: ( (String) -> Void )?
    
    var pickerData: [String] = []
    
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
                
            case .date(let dateString, let format):
                
                contentText.inputView = datePicker
                
                datePicker.date = dateFormatter.date(from: dateString) ?? Date()
                
                dateFormatter.dateFormat = format
                
                contentText.text = dateString
           
            case .normal:
                
                contentText.inputView = nil
            }
        }
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentText.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func didSelectedDate(_ sender: UIDatePicker) {
           
        contentText.text = dateFormatter.string(from: sender.date)
        
        dateUpdateHandler?(contentText.text!)
    }

}

extension EnterInfoCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let text = textField.text else {
            return
        }
        
        contentUpdateHandler?(text)
    }
}
    
