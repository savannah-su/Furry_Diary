//
//  PetDetailViewController.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/6.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit

class PetDetailViewController: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var bannerView: BannerView! {
        didSet {
            self.bannerView.dataSource = self
            self.bannerView.delegate = self
        }
    }
    @IBOutlet weak var tableView: PetTableView! {
        didSet {
            self.tableView.dataSource = self
            self.tableView.delegate = self
        }
    }
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBAction func backButton(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
        NotificationCenter.default.post(name: Notification.Name("Create New Pet"), object: nil)
    }
    
    @IBAction func editButton(_ sender: Any) {
        
        guard let viewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(identifier: "Create Pet Page") as? CreatePetViewController else { return }
        
        viewController.petInfo = petData
        
        present(viewController, animated: true, completion: nil)
    }
    
    let titleArray = ["名字", "種類", "性別", "品種", "特徵", "生日", "晶片號碼", "是否絕育", "個性喜好", "毛孩飼主"]
    
    var petData: PetInfo?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 200, left: 0, bottom: 0, right: 0)
        
        setupPageControl()
    }
    
    func setupPageControl() {
        
        pageControl.numberOfPages = petData?.petImage.count ?? 0
        pageControl.currentPageIndicatorTintColor = .white
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
        return titleArray.count
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Owner Cell", for: indexPath) as? OwnerCell else { return UITableViewCell() }
            
            cell.titleLabel.text = titleArray[indexPath.row]
            
            cell.collectionView.dataSource = self
            cell.collectionView.delegate = self
            
            return cell
            
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

extension PetDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return petData?.ownersImage.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoOwner CollectionCell", for: indexPath) as? CoOwnerCollectionCell else {
            return UICollectionViewCell()
        }
        
        //        guard let urlString = petData?.ownersImage[indexPath.item] else {
        //            return UICollectionViewCell()
        //        }
        //        guard let url = URL(string: urlString) else {
        //             return UICollectionViewCell()
        //        }
        cell.ownerPhoto.loadImage(petData?.ownersImage[indexPath.item], placeHolder: UIImage(named: "icon-selected"))
        cell.ownerPhoto.layer.cornerRadius = 15
        
        return cell
    }
}

extension PetDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
}

extension PetDetailViewController: BannerViewDelegate {
    
    func didScrollToPage(_ bannerView: BannerView, page: Int) {
        
        pageControl.currentPage = page
    }
}
