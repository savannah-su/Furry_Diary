//
//  UpdateIamgeCell.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/3.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit

class UploadIamgeCell: UICollectionViewCell {
  
    @IBOutlet weak var uplodaImage: UIImageView!
    @IBOutlet weak var imageButton: UIButton!
    @IBAction func imageButton(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name("ShowAlert"), object: nil)
    }
    
}




