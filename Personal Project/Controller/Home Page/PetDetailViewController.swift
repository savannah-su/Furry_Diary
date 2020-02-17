//
//  PetDetailViewController.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/6.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit

class PetDetailViewController: UIViewController {
    
    
    @IBOutlet weak var bannerView: BannerView!
    @IBOutlet weak var tableView: PetTableView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBAction func backButton(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
        NotificationCenter.default.post(name: Notification.Name("Create New Pet"), object: nil)
    }
    
    @IBAction func editButton(_ sender: Any) {
    }
    
    let titleArray = ["名字", "種類", "性別", "品種", "特徵", "生日", "晶片號碼", "是否絕育", "個性喜好", "共同飼主"]
    
    var petData: PetInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.contentInset = UIEdgeInsets(top: 200, left: 0, bottom: 0, right: 0)
        
        setupBannerView()
        
    }
    
    func setupBannerView() {
        
        bannerView.dataSource = self
    }
    
}

class PetTableView: UITableView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if point.y < 0 {
            
            return nil
            
        } else {
            
            return super.hitTest(point, with: event)
        }
    }
}

extension PetDetailViewController: BannerViewDataSource {
    
    func numberOfPages(in bannerView: BannerView) -> Int {
        
        return petData?.petImage.count ?? 0
        
    }
    
    func viewFor(bannerView: BannerView, at index: Int) -> UIView {
        
        let imageView = UIImageView()
        
        imageView.kf.setImage(with: URL(string: petData?.petImage[index] ?? ""))
        
        imageView.contentMode = .scaleAspectFill
        
        imageView.clipsToBounds = true
        
        return imageView
    }
}

extension PetDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Detail Cell", for: indexPath) as? DetailCell else { return UITableViewCell() }
        
        cell.titleLabel.text = titleArray[indexPath.row]
        
        switch indexPath.row {
            
        case 0:
            cell.contentLabel.text = petData?.petName
            
        case 1:
            cell.contentLabel.text = petData?.species
            
        case 2:
            cell.contentLabel.text = petData?.gender
            
        case 3:
            cell.contentLabel.text = petData?.breed
            
        case 4:
            cell.contentLabel.text = petData?.color
            
        case 5:
            cell.contentLabel.text = petData?.birth
            
        case 6:
            cell.contentLabel.text = petData?.chip
            
        case 7:
            
            var status = ""
            
            if petData?.neuter == true {
                status = "已經結紮嘍！"
            } else {
                status = "還沒結紮唷！"
            }
            cell.contentLabel.text = status
            
        case 8:
            cell.contentLabel.text = petData?.memo
            
        default:
            cell.contentLabel.text = petData?.ownersImage[0]
   
        }
        
        
        if indexPath.row == 0 {
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cell.layer.cornerRadius = 20
        } else {
            cell.layer.cornerRadius = 0
        }
        
        return cell
    }
}

extension PetDetailViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if tableView.contentOffset.y <= 0 &&  tableView.contentOffset.y >= -200 {
            
            topConstraint.constant = -(tableView.contentOffset.y - (-200)) / 3
            
            bannerView.manipulateWidthConstraints(with: tableView.contentOffset.y - (-200))
        }
        
        if tableView.contentOffset.y <= -200 {
            
            heightConstraint.constant = 530 - (tableView.contentOffset.y - (-200))
        }
    }
    
}


