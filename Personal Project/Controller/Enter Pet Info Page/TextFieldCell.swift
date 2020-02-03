//
//  textFieldTableViewCell.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/2.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit

enum DateType {
    
}

enum generalType{
    
    case optionOne
    case optionTwo
    case optionThree
    
//    var species: String {
//        switch self {
//        case .optionOne: return "狗狗"
//        case .optionTwo: return "貓咪"
//        case .optionThree: return "其他"
//        }
//    }
}

//var neuter: String {
//    switch self {
//    case .optionOne: return "尚未絕育"
//    case .optionTwo: return "已絕育"
//    }
//}

class TextFieldCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentField: UITextField!
    
    var datePiker = UIDatePicker()
    var pickerView = UIPickerView()
    var speciesArray = ["狗狗", "貓咪", "其他"]
    var neuterArray = ["尚未絕育", "已絕育"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentField.delegate = self
        pickerView.dataSource = self
        pickerView.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension TextFieldCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension TextFieldCell: UIPickerViewDelegate {
    
}

extension TextFieldCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return speciesArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return speciesArray[row]
    }
}
