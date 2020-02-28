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
import FirebaseFirestoreSwift

class CreatePetViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func createButton(_ sender: Any) {
        
        picUpload()
        
        dismiss(animated: true, completion: nil)
        
    }
    
    var count = 0
    
    let picker = UIImagePickerController()
    //上傳圖片需要先轉jpeg形式，傳到Storage後，拿到URL，才可傳至DB
    var petPhotoURL: [String] = []
    var petID = UUID().uuidString
    var selectedPhoto: [UIImage] = []
    
    let titleArray = ["名字", "種類", "性別", "品種", "特徵", "生日", "晶片號碼", "是否絕育", "個性喜好", "毛孩飼主"]
    let placeholderArray = ["輸入毛孩名字", "選擇毛孩種類", "選擇毛孩性別", "輸入毛孩品種", "輸入毛孩特徵與毛色", "輸入毛孩生日", "輸入毛孩晶片號碼", "選擇是否絕育"]
    var petInfo = PetInfo(petID: "", ownersID: [], ownersName: [], ownersImage: [], petImage: [], petName: "", species: "", gender: "", breed: "", color: "", birth: "", chip: "", neuter: false, neuterDate: "", memo: "") {
        
        didSet {
            tableView.reloadData()
        }
    }
    
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
        
        addCurrentUser()
    }
    
    func addCurrentUser() {
        
        guard let currentUserID = UserDefaults.standard.value(forKey: "userID") as? String else { return }
        guard let currentUserName = UserDefaults.standard.value(forKey: "userName") as? String else { return }
        guard let currentUserImage = UserDefaults.standard.value(forKey: "userPhoto") as? String else { return }
        
        self.petInfo.ownersID.append(currentUserID)
        self.petInfo.ownersName.append(currentUserName)
        self.petInfo.ownersImage.append(currentUserImage)
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
            
            guard let uploadPhoto = selectedPhoto[index].jpegData(compressionQuality: 0.5) else { return }
            
            let storageRef = Storage.storage().reference().child("PetPhoto").child("\(petID)-\(index).jpeg")
            
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
                    
                    self.petPhotoURL.append("\(backPhotoURL)")
                    
                    if self.count == self.selectedPhoto.count - 1 {
                        
                        self.petInfo.petImage = self.petPhotoURL
                        self.toDataBase()
                        
                    } else {
                        
                          self.count += 1
                    }
                }
            }
        }
    }
    
    func toDataBase() {
        
        guard UserDefaults.standard.value(forKey: "userID") != nil else { return }
        guard UserDefaults.standard.value(forKey: "userName") != nil else { return }
        guard UserDefaults.standard.value(forKey: "userPhoto") != nil else { return }

        self.petInfo.petID = petID
        
        Firestore.firestore().collection("pets").document(petID).setData(petInfo.toDict, completion: { (error) in
            
            if error == nil {
                print("DB added successfully")
            } else {
                print("DB added failed")
            }
        })
        
    }
}

extension CreatePetViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Text Field Cell", for: indexPath) as? TextFieldCell else {
            return UITableViewCell()
        }
        
        cell.titleLabel.text = titleArray[indexPath.row]
        
        switch indexPath.row {
            
        case 0:
            cell.contentField.placeholder = placeholderArray[0]
            cell.keyboardType = .normal
            cell.touchHandler = { [weak self] text in
                
                self?.petInfo.petName = text
            }
            return cell
            
        case 1:
            cell.contentField.placeholder = placeholderArray[1]
            cell.keyboardType = .picker(["汪汪", "喵嗚", "其他"])
            cell.touchHandler = { [weak self] text in
                
                self?.petInfo.species = text
            }
            return cell
            
            
        case 2:
            cell.contentField.placeholder = placeholderArray[2]
            cell.keyboardType = .picker(["男生", "女生"])
            cell.touchHandler = { [weak self] text in
                
                self?.petInfo.gender = text
            }
            return cell
            
        case 3:
            cell.contentField.placeholder = placeholderArray[3]
            cell.keyboardType = .normal
            cell.touchHandler = { [weak self] text in
                
                self?.petInfo.breed = text
            }
            return cell
            
        case 4:
            cell.contentField.placeholder = placeholderArray[4]
            cell.keyboardType = .normal
            cell.touchHandler = { [weak self] text in
                
                self?.petInfo.color = text
            }
            return cell
            
        case 5:
            cell.contentField.placeholder = placeholderArray[5]
            cell.keyboardType = .date(Date(), "yyyy-MM-dd")
            cell.touchHandler = { [weak self] text in
                
                self?.petInfo.birth = text
            }
            
            cell.contentField.text = petInfo.birth
            return cell
            
        case 6:
            cell.contentField.placeholder = placeholderArray[6]
            cell.keyboardType = .normal
            cell.touchHandler = { [weak self] text in
                
                self?.petInfo.chip = text
            }
            return cell
            
        case 7:
            cell.contentField.placeholder = placeholderArray[7]
            cell.keyboardType = .picker(["已絕育", "尚未絕育"])
            cell.touchHandler = { [weak self] text in
                
                if text == "已絕育" {
                    self?.petInfo.neuter = true
                } else {
                    self?.petInfo.neuter = false
                }
            }
            return cell
            
        case 8:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Text View Cell", for: indexPath) as? TextViewCell else {
                return UITableViewCell()
            }
            
            cell.titleLabel.text = titleArray[indexPath.row]
            cell.contentTextView.layer.borderColor = UIColor(red: 199/255.0, green: 199/255.0, blue: 199/255.0, alpha: 1).cgColor
            cell.touchHandler = { [weak self] text in
                
                self?.petInfo.memo = text
            }
            
            return cell
            
        default:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Co Owner Cell", for: indexPath) as? CoOwnerCell else { return UITableViewCell() }
            
            cell.titleLabel.text = titleArray[indexPath.row]
            
            cell.searchButton.isHidden = false
            
            cell.searchButton.addTarget(self, action: #selector(searchOwner), for: .touchUpInside)
            
            cell.data = petInfo
            
            cell.collectionView.reloadData()
            
            if cell.data.ownersImage.count > 1 {
                cell.searchButton.isHidden = true
            }
            
            return cell
            
        }
    }
    
    @objc func searchOwner() {
        
        guard let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(identifier: "Search Owner Page") as? SearchOwnerViewController else { return }
        
        vc.selectHandler = { data in
            
            self.petInfo.ownersID.append(contentsOf: data.map{ $0.id })
            self.petInfo.ownersName.append(contentsOf: data.map{ $0.name })
            self.petInfo.ownersImage.append(contentsOf: data.map{ $0.image })
            
            print(self.petInfo.ownersID)
            print(self.petInfo.ownersName)
            print(self.petInfo.ownersImage)
        }
        
        show(vc, sender: self)
    }
}

extension CreatePetViewController: UICollectionViewDataSource {
    
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

extension CreatePetViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
}

extension CreatePetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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