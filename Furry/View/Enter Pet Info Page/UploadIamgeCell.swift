//
//  UpdateIamgeCell.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/3.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit

class UploadIamgeCell: UICollectionViewCell {
  
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var uplodaImage: UIImageView!
    @IBOutlet weak var imageButton: UIButton!
    @IBAction func imageButton(_ sender: Any) {
        print(123)
        NotificationCenter.default.post(name: NSNotification.Name("ShowAlert"), object: nil)
    }
    @IBOutlet weak var removeButton: UIButton!
    @IBAction func removeButton(_ sender: Any) {
        removeHandler?()
    }
    
    var removeHandler: ( () -> Void )?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        background.layer.borderWidth = 1
        background.layer.borderColor = UIColor(red: 199/255.0, green: 199/255.0, blue: 199/255.0, alpha: 1).cgColor
    }
    
}
