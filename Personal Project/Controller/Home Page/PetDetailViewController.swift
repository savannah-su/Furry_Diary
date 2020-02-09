//
//  PetDetailViewController.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/6.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit

class PetDetailViewController: UIViewController {

    @IBAction func backButton(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editButton(_ sender: Any) {
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var exceedView: UIView!
    let firstImage: UIImageView = UIImageView()
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var thirdImage: UIImageView!
    @IBOutlet weak var fourImage: UIImageView!
    @IBOutlet weak var fifthImage: UIImageView!
    var widthConstraint: NSLayoutConstraint?
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.contentInset = UIEdgeInsets(top: 200, left: 0, bottom: 0, right: 0)

        setupScrollView()
    }
    
    func setupScrollView() {
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .red
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: exceedView.centerXAnchor),
            scrollView.topAnchor.constraint(equalTo: exceedView.topAnchor),
            scrollView.heightAnchor.constraint(equalTo: exceedView.heightAnchor),
            scrollView.widthAnchor.constraint(equalTo: exceedView.widthAnchor)
        ])
        
        firstImage.image = UIImage(named: "圖片 27")
        scrollView.addSubview(firstImage)
        firstImage.translatesAutoresizingMaskIntoConstraints = false
        firstImage.contentMode = .scaleAspectFill
        firstImage.backgroundColor = .green
        firstImage.clipsToBounds = true
        
        widthConstraint = firstImage.widthAnchor.constraint(equalTo: exceedView.widthAnchor)
        NSLayoutConstraint.activate([
            widthConstraint!,
            firstImage.heightAnchor.constraint(equalTo: exceedView.heightAnchor),
            firstImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            firstImage.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            firstImage.topAnchor.constraint(equalTo: scrollView.topAnchor),
            firstImage.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print(scrollView)
        print(firstImage)
    }

}

extension PetDetailViewController: UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Detail Cell", for: indexPath) as? DetailCell else { return UITableViewCell() }
        

        if indexPath.row == 0 {
            
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cell.layer.cornerRadius = 20
            return cell
            
        } else {
            
            cell.layer.cornerRadius = 0
            return cell
        }
    }
}

extension PetDetailViewController: UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
//        guard var widthConstraint = widthConstraint else { return }
//
//        topConstraint?.constant = -(tableView.contentOffset.y - (-200)) / 3
//
//        print("---", -(tableView.contentOffset.y - (-200)) / 3)
//
////        firstImage.transform = CGAffineTransform(scaleX: (tableView.contentOffset.y - (-200)) / 200 * 0.5 + 1, y: (tableView.contentOffset.y - (-200)) / 200 * 0.5 + 1)
//        
//        widthConstraint.isActive = false
//
//        widthConstraint = firstImage.widthAnchor.constraint(
//            equalTo: view.widthAnchor,
//            multiplier: (tableView.contentOffset.y - (-200)) / 200 * 0.5 + 1,
//            constant: 0
//        )
//
//        widthConstraint.isActive = true
    }
    
}
