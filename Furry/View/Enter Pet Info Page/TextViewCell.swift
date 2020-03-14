//
//  TextViewTableViewCell.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/2.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit

class TextViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView! {
        didSet {
            self.contentTextView.delegate = self
            contentTextView.text = "輸入寵物喜好及個性"
        }
    }
    
    var touchHandler: ( (String) -> Void )?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentTextView.textColor = UIColor(red: 199/255.0, green: 199/255.0, blue: 199/255.0, alpha: 1)
        contentTextView.layer.borderColor = UIColor(red: 199/255.0, green: 199/255.0, blue: 199/255.0, alpha: 1).cgColor
    }
}

extension TextViewCell: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if contentTextView.textColor == UIColor.lightGray {
            contentTextView.text = nil
            contentTextView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if contentTextView.text.isEmpty {
            contentTextView.text = "輸入寵物喜好及個性"
            contentTextView.textColor = UIColor.lightGray
        }
        
        guard let text = contentTextView.text else {
            return
        }
        touchHandler?(text)
    }
}
