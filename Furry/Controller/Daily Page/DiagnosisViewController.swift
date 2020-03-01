//
//  DiagnosisViewController.swift
//  Furry
//
//  Created by Savannah Su on 2020/2/29.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit

class DiagnosisViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var saveButton: VerticalAlignedButton!
    @IBAction func saveButton(_ sender: Any) {
    }
    @IBAction func backButton(_ sender: Any) {
    }
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }

}

//extension DiagnosisViewController: UICollectionViewDataSource {
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//    }
    
//}

extension DiagnosisViewController: UICollectionViewDelegate {
    
}

extension DiagnosisViewController: UICollectionViewDelegateFlowLayout {
    
}
