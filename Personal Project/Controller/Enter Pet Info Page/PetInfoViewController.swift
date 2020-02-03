//
//  PetInfoViewController.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/1.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit

class PetInfoViewController: UIViewController {
    
    @IBOutlet weak var coOwnerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func createButton(_ sender: Any) {
    }
    
    let titleArray = ["名字", "種類", "品種", "特徵", "生日", "晶片號碼", "是否絕育", "備註"]
    let placeholderArray = ["輸入寵物名字", "選擇寵物種類", "輸入寵物品種", "輸入寵物特徵與毛色", "輸入寵物生日", "輸入寵物晶片號碼", "選擇是否絕育及絕育日期"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorColor = .white
        
        // Do any additional setup after loading the view.
    }
    
}

extension PetInfoViewController: UITableViewDelegate {
    
}

extension PetInfoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Text Field Cell", for: indexPath) as? TextFieldCell else {
            return UITableViewCell()
        }
        
        switch indexPath.row {
            
        case 0:
            cell.titleLabel.text = titleArray[0]
            cell.contentField.placeholder = placeholderArray[0]
            return cell
            
        case 1:
            cell.titleLabel.text = titleArray[1]
            cell.contentField.placeholder = placeholderArray[1]
            return cell
            
        case 2:
            cell.titleLabel.text = titleArray[2]
            cell.contentField.placeholder = placeholderArray[2]
            return cell
            
        case 3:
            cell.titleLabel.text = titleArray[3]
            cell.contentField.placeholder = placeholderArray[3]
            return cell
            
        case 4:
            cell.titleLabel.text = titleArray[4]
            cell.contentField.placeholder = placeholderArray[4]
            return cell
            
        case 5:
            cell.titleLabel.text = titleArray[5]
            cell.contentField.placeholder = placeholderArray[5]
            return cell
            
        case 6:
            cell.titleLabel.text = titleArray[6]
            cell.contentField.placeholder = placeholderArray[6]
            return cell
            
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Text View Cell", for: indexPath) as? TextViewCell else {
                return UITableViewCell()
            }
            
            cell.titleLabel.text = titleArray[7]
            cell.contentTextView.layer.borderColor = UIColor(red: 199/255.0, green: 199/255.0, blue: 199/255.0, alpha: 1).cgColor
            return cell
        }
        
        //        if indexPath.row == 0 {
        //
        //        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Text Field Cell", for: indexPath) as? TextFieldCell else {
        //            return UITableViewCell()
        //        }
        //
        //        cell.titleLabel.text = "名字"
        //        cell.contentField.placeholder = "輸入寵物名字"
        //
        //        return cell
        //
        //        } else if indexPath.row == 1 {
        //
        //            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Text View Cell", for: indexPath) as? TextViewCell else {
        //                return UITableViewCell()
        //            }
        //
        //            cell.titleLabel.text = "備註"
        //            cell.contentTextView.layer.borderColor = UIColor(red: 199/255.0, green: 199/255.0, blue: 199/255.0, alpha: 1).cgColor
        //
        //            return cell
        //        }
        
        return UITableViewCell()
    }
    
}


