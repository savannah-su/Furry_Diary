//
//  PetInfoViewController.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/1.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage

class PetInfoViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func createButton(_ sender: Any) {
        
        print("---------------")
        print(petInfo)
        
        picUpload()
        
        dismiss(animated: true, completion: nil)
        
    }
    
    var count = 0
    var coOwnerImageURL = ""
    var coOwnerName = ""
    var coOwnerID = ""
    let birthPicker = UIDatePicker()
    let showBirth = DateFormatter()
    let picker = UIImagePickerController()
    //上傳圖片需要先轉png形式，傳到Storage後，拿到URL，才可傳至DB
    var photoURL: [String] = []
    var petID = UUID().uuidString
    var selectedPhoto: [UIImage] = []
    let titleArray = ["名字", "種類", "品種", "特徵", "生日", "晶片號碼", "是否絕育", "個性喜好", "共同飼主"]
    let placeholderArray = ["輸入寵物名字", "選擇寵物種類", "輸入寵物品種", "輸入寵物特徵與毛色", "輸入寵物生日", "輸入寵物晶片號碼", "選擇是否絕育"]
    var petInfo = PetInfo(ownersID: [], ownersName: [], ownersImage: [], petImage: [], petName: "", species: "", breed: "", color: "", birth: "", chip: "", neuter: false, neuterDate: "", memo: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        picker.delegate = self
        
        tableView.separatorColor = .white
        //setBirthPicker()
        
        tableView.sectionHeaderHeight = 140
        
        NotificationCenter.default.addObserver(self, selector: #selector(showAlert), name: Notification.Name("ShowAlert"), object: nil)
    }
    
    @objc func showAlert() {
        
        let controller = UIAlertController(title: "上傳寵物圖片", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "開啟相機", style: .default) { (_) in
            
            self.tapCameraBtn()
        }
        
        let libraryAction = UIAlertAction(title: "相片圖庫", style: .default) { (_) in
            
            self.tapLibraryBtn()
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        controller.addAction(cameraAction)
        controller.addAction(libraryAction)
        controller.addAction(cancelAction)
        
        present(controller, animated: true, completion: nil)
    }
    
    func picUpload() {
        
        
        for index in 0 ..< selectedPhoto.count {
            
            guard let uploadPhoto = selectedPhoto[index].pngData() else { return }
            
            let storageRef = Storage.storage().reference().child("PetPhoto").child("\(petID).png")
            
            storageRef.putData(uploadPhoto, metadata: nil) { (_, error) in
                
                if error != nil {
                    print("To Storage Failed")
                    return
                }
                
                storageRef.downloadURL { (url, error) in
                    
                    if error != nil {
                        print("Get URL Failed")
                        return
                    }
                    
                    guard let backPhotoURL = url else { return }
                    
                    self.photoURL.append("\(backPhotoURL)")
                    self.count += 1
                }
                
            }
        }
        
        if count == selectedPhoto.count {
            
            self.toDataBase()
        }
    }
    
    func toDataBase() {
        
        guard let currentUserID = UserDefaults.standard.value(forKey: "userID") else { return }
        guard let currentUserName = UserDefaults.standard.value(forKey: "userName") else { return }
        guard let currentUserImage = UserDefaults.standard.value(forKey: "userPhoto") else { return }
        
        self.petInfo.ownersID = [currentUserID as! String, coOwnerID]
        self.petInfo.ownersName = [currentUserName as! String, coOwnerName]
        self.petInfo.ownersImage = [currentUserImage as! String, coOwnerImageURL]
        self.petInfo.petImage = photoURL
        
        Firestore.firestore().collection("pets").document(petID).setData(petInfo.toDict, completion: { (error) in
            
            if error == nil {
                print("DB added successfully")
            } else {
                print("DB added failed")
            }
        })
        
    }
    
    //    func setBirthPicker() {
    //
    //        showBirth.dateFormat = "yyyy-MM-dd"
    //        birthPicker.datePickerMode = .date
    //        birthPicker.locale = Locale(identifier: "zh_TW")
    //        birthPicker.addTarget(self, action: #selector(changeBirth), for: .valueChanged)
    //
    //    }
    //
    //    @objc func changeBirth() {
    //
    //        if let firstResponder = view.window?.firstResponder {
    //            // do something with `firstResponder`
    //
    //            print(firstResponder)
    //
    //            guard let textField = firstResponder as? UITextField else { return }
    //
    //            let dateFormatter = DateFormatter()
    //
    //            dateFormatter.dateFormat = "yyyy/MM/dd"
    //
    //            textField.text = dateFormatter.string(from: birthPicker.date)
    //        }
    //
    //    }
}

//extension UIView {
//
//    var firstResponder: UIView? {
//        guard !isFirstResponder else { return self }
//
//        for subview in subviews {
//            if let firstResponder = subview.firstResponder {
//                return firstResponder
//            }
//        }
//
//        return nil
//    }
//}

extension PetInfoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Text Field Cell", for: indexPath) as? TextFieldCell else {
            return UITableViewCell()
        }
        
        switch indexPath.row {
            
        case 0:
            cell.titleLabel.text = titleArray[0]
            cell.contentField.placeholder = placeholderArray[0]
            cell.keyboardType = .normal
            cell.touchHandler = { [weak self] text in
                
                self?.petInfo.petName = text
            }
            return cell
            
        case 1:
            cell.titleLabel.text = titleArray[1]
            cell.contentField.placeholder = placeholderArray[1]
            cell.keyboardType = .picker(["狗狗", "貓咪", "其他"])
            cell.touchHandler = { [weak self] text in
                
                self?.petInfo.species = text
            }
            return cell
            
        case 2:
            cell.titleLabel.text = titleArray[2]
            cell.contentField.placeholder = placeholderArray[2]
            cell.keyboardType = .normal
            cell.touchHandler = { [weak self] text in
                
                self?.petInfo.breed = text
            }
            return cell
            
        case 3:
            cell.titleLabel.text = titleArray[3]
            cell.contentField.placeholder = placeholderArray[3]
            cell.keyboardType = .normal
            cell.touchHandler = { [weak self] text in
                
                self?.petInfo.color = text
            }
            return cell
            
        case 4:
            cell.titleLabel.text = titleArray[4]
            cell.contentField.placeholder = placeholderArray[4]
            cell.keyboardType = .date(Date(), "yyyy-MM-dd")
            cell.touchHandler = { [weak self] text in
                
                self?.petInfo.birth = text
            }
            return cell
            
        case 5:
            cell.titleLabel.text = titleArray[5]
            cell.contentField.placeholder = placeholderArray[5]
            cell.keyboardType = .normal
            cell.touchHandler = { [weak self] text in
                
                self?.petInfo.chip = text
            }
            return cell
            
        case 6:
            cell.titleLabel.text = titleArray[6]
            cell.contentField.placeholder = placeholderArray[6]
            cell.keyboardType = .picker(["已絕育", "尚未絕育"])
            cell.touchHandler = { [weak self] text in
                
                if text == "已絕育" {
                    self?.petInfo.neuter = true
                } else {
                    self?.petInfo.neuter = false
                }
            }
            return cell
            
        case 7:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Text View Cell", for: indexPath) as? TextViewCell else {
                return UITableViewCell()
            }
            
            cell.titleLabel.text = titleArray[7]
            cell.contentTextView.layer.borderColor = UIColor(red: 199/255.0, green: 199/255.0, blue: 199/255.0, alpha: 1).cgColor
            cell.touchHandler = { [weak self] text in
                
                self?.petInfo.memo = text
            }
            
            return cell
            
        default:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Co Owner Cell", for: indexPath) as? CoOwnerCell else { return UITableViewCell() }
            
            cell.titleLabel.text = titleArray[8]
            
            if coOwnerImageURL != "" {
                
                cell.searchButton.isHidden = true
                cell.ownerImage.isHidden = false
                
                let url = URL(string: coOwnerImageURL)
                let data = try! Data(contentsOf: url!)
                cell.ownerImage?.image = UIImage(data: data)
                cell.ownerImage?.layer.cornerRadius = 15
                
            } else {
                
                cell.searchButton.isHidden = false
                cell.ownerImage.isHidden = true
            }
            
            return cell
            
        }
    }
}

extension PetInfoViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if selectedPhoto.count == 0 {
            
            return 2
            
        } else {
            
            return selectedPhoto.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Image Cell", for: indexPath) as? UploadIamgeCell else { return UICollectionViewCell() }
        
        cell.layer.borderColor = UIColor(red: 199/255.0, green: 199/255.0, blue: 199/255.0, alpha: 1).cgColor
        
        
        
        if indexPath.row >= selectedPhoto.count {
            cell.imageButton.isHidden = false
            cell.uplodaImage.isHidden = true
        } else {
            cell.imageButton.isHidden = true
            cell.uplodaImage.isHidden = false
            cell.uplodaImage.image = selectedPhoto[indexPath.row]
        }
        
        return cell
        
    }
}

extension PetInfoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
}

extension PetInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func getPhotoWay(type: Int) {
        
        switch type {
        case 1:
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                picker.sourceType = .camera
                self.present(picker, animated: true, completion: nil)
            } else {
                alert(message: "無鏡頭可使用", title: "Oops!")
            }
        default:
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                picker.sourceType = .photoLibrary
                self.present(picker, animated: true, completion: nil)
            }
        }
    }
    
    func tapCameraBtn() {
        self.getPhotoWay(type: 1)
    }
    
    func tapLibraryBtn() {
        self.getPhotoWay(type: 2)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        if let pickedImage = info[.originalImage] as? UIImage {
            selectedImageFromPicker = pickedImage
            selectedPhoto.append(selectedImageFromPicker!)
        }
        // 可以自動產生一組獨一無二的 ID 號碼，方便等一下上傳圖片的命名
        let uniqueString = NSUUID().uuidString
        
        // 當判斷有 selectedImage 時，我們會在 if 判斷式裡將圖片上傳
        if let selectedImage = selectedImageFromPicker {
            print("\(uniqueString), \(selectedImage)")
        }
        
        collectionView.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
    
    // 圖片picker控制器任務結束回呼
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
