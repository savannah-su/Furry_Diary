//
//  CoOwnerCell.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/5.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit

class CoOwnerCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ownerImage: UIImageView!
    @IBOutlet weak var searchButton: UIButton!
    @IBAction func searchButton(_ sender: Any) {
        
        guard let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(identifier: "PetInfoPage") as? SearchOwnerViewController else { return }
        
        vc.isModalInPresentation = true
    }
}
