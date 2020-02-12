//
//  PreventPageViewController.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/12.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit

class PreventPageViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func saveButton(_ sender: Any) {
    }
    
    let itemLabel = ["疫苗施打", "體內驅蟲", "體外驅蟲"]
    let itemImage = ["疫苗施打", "體內驅蟲", "體外驅蟲"]
    let selectedImage = ["疫苗施打-selected", "體內驅蟲-selected", "體外驅蟲-selected"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.isMultipleTouchEnabled = false

        // Do any additional setup after loading the view.
    }
}

extension PreventPageViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 34
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 98, left: 51, bottom: 98, right: 51)
    }
}

extension PreventPageViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Item Cell", for: indexPath) as? ReuseItemCell else { return UICollectionViewCell() }
        
        for index in 0 ... 2 {
            
            let index = indexPath.row
            cell.itemLabel.text = itemLabel[index]
            cell.image.image = UIImage(named: itemImage[index])
        }
        return cell
    }
}

extension PreventPageViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ReuseItemCell
        let index = indexPath.row
        cell.image.image = UIImage(named: selectedImage[index])
    }
}
