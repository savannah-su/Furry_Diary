//
//  HomePageViewController.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/5.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {

    @IBAction func createButton(_ sender: Any) {
       
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(identifier: "Create Pet Page") as? PetInfoViewController
        
        vc?.isModalInPresentation = true
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorColor = .none

        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = .G2
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
               
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        // Do any additional setup after loading the view.
    }

}

extension HomePageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 232
    }
    
}

extension HomePageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Pet Card Cell", for: indexPath) as? PetCardCell else { return UITableViewCell() }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(toDetailPage))
        cell.scrollView.addGestureRecognizer(tap)

        return cell
    }
    
    @objc func toDetailPage() {
        
        guard let vc = UIStoryboard(name: "PetDetail", bundle: nil).instantiateViewController(identifier: "Pet Detail Page") as? PetDetailViewController else { return }
        show(vc, sender: nil)
    }
    
}
