//
//  PetCardCell.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/5.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit
import Kingfisher

class PetCardCell: UITableViewCell {

    @IBOutlet weak var background: BannerView!
    @IBOutlet weak var petName: UILabel!
    @IBOutlet weak var genderAndOld: UILabel!
    
    var petImage = [String]() {

        didSet {
            if petImage.isEmpty {
                return
            } else {
                DispatchQueue.main.async {
                    self.background.reloadData()
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupShadow()
        
        setupBannerView()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupShadow() {
        
        background?.layer.cornerRadius = 20
        background?.layer.shadowOffset = CGSize(width: 5, height: 5)
        background?.layer.shadowOpacity = 0.5
        background?.layer.shadowRadius = 3
        background?.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1).cgColor
   
    }
    
    func setupBannerView() {
        
        background.dataSource = self
    }
}

extension PetCardCell: BannerViewDataSource {
    
    func numberOfPages(in bannerView: BannerView) -> Int {
        return petImage.count
    }
    
    func viewFor(bannerView: BannerView, at index: Int) -> UIView {
        
        let imageView = UIImageView()
        
        imageView.kf.setImage(with: URL(string: petImage[index]))
        
        imageView.backgroundColor = .blue
        
        imageView.alpha = 0.7
        
        imageView.layer.cornerRadius = 20
        
        imageView.contentMode = .scaleAspectFill
        
        imageView.clipsToBounds = true
        
        return imageView
    }
    
    
}
