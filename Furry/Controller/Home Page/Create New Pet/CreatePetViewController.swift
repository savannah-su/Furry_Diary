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
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var createButton: UIButton!
    @IBAction func createButton(_ sender: Any) {
        
        picUpload()
        
        petDataHandler?(petInfo)
    }
    
    var backURLCount = 1
    
    let picker = UIImagePickerController()
    
    //上傳圖片需要先轉jpeg形式，傳到Storage後，拿到URL，才可傳至DB
    var petPhotoURL: [String] = []
    var petID = ""
    var selectedPhoto: [UIImage] = []
    
    let titleArray = ["名字", "種類", "性別", "品種", "特徵", "生日", "晶片號碼", "是否絕育", "個性喜好", "毛孩飼主"]
    let placeholderArray = ["輸入毛孩名字", "選擇毛孩種類", "選擇毛孩性別", "輸入毛孩品種", "輸入毛孩特徵與毛色", "輸入毛孩生日", "輸入毛孩晶片號碼", "選擇是否絕育"]
    var petInfo: PetInfo!
    
    var petDataHandler: ( (PetInfo) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if petInfo != nil {
            createButton.setTitle("更新寵物日誌", for: .normal)
        } else {
            petInfo = PetInfo(petID: UUID().uuidString, ownersID: [], ownersName: [], ownersImage: [], petImage: [], petName: "", species: "", gender: "", breed: "", color: "", birth: "", chip: "", neuter: nil, neuterDate: "", memo: "")
            addCurrentUser() 
        }
        
        picker.delegate = self
        
        tableView.separatorColor = .clear
        
        NotificationCenter.default.addObserver(self, selector: #selector(showAlert), name: Notification.Name("ShowAlert"), object: nil)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.sectionHeaderHeight = 120
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
        
        if selectedPhoto.count > 0 {
            
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
                        
                        if self.backURLCount == self.selectedPhoto.count {
                            
                            self.petInfo.petImage = self.petPhotoURL
                            self.toDataBase()
                            
                        } else {
                            self.backURLCount += 1
                        }
                    }
                }
            }
            
        } else {
            toDataBase()
        }
    }
    
    func toDataBase() {
        
        guard UserDefaults.standard.value(forKey: "userID") != nil else { return }
        guard UserDefaults.standard.value(forKey: "userName") != nil else { return }
        guard UserDefaults.standard.value(forKey: "userPhoto") != nil else { return }
        
        petID = self.petInfo.petID
        
        if petInfo.petImage.isEmpty {
            petInfo.petImage = [""]
        }
        
//        Firestore.firestore().collection("pets").document(petID).setData(petInfo.toDict, merge: true)
//        Firestore.firestore().collection("pets").document(petID).removeObserver(<#T##observer: NSObject##NSObject#>, forKeyPath: <#T##String#>)
        
        Firestore.firestore().collection("pets").document(petID).setData(petInfo.toDict, completion: { (error) in
            
            if error == nil {
                
                UploadManager.shared.uploadSuccess(text: "上傳成功！")
                
                NotificationCenter.default.post(name: Notification.Name("Create New Pet"), object: nil)
                
                self.dismiss(animated: true, completion: nil)
                
                print("DB added successfully")
                
            } else {
                
                UploadManager.shared.uploadFail(text: "上傳失敗！")
                
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
            cell.contentField.text = petInfo.petName
            cell.keyboardType = .normal
            cell.touchHandler = { [weak self] text in
                
                self?.petInfo.petName = text
            }
            return cell
            
        case 1:
            cell.contentField.placeholder = placeholderArray[1]
            cell.contentField.text = petInfo.species
            cell.keyboardType = .picker(["汪汪", "喵嗚", "其他"])
            cell.touchHandler = { [weak self] text in
                
                self?.petInfo.species = text
            }
            return cell
            
        case 2:
            cell.contentField.placeholder = placeholderArray[2]
            cell.contentField.text = petInfo.gender
            cell.keyboardType = .picker(["男生", "女生"])
            cell.touchHandler = { [weak self] text in
                
                self?.petInfo.gender = text
            }
            return cell
            
        case 3:
            cell.contentField.placeholder = placeholderArray[3]
            cell.contentField.text = petInfo.breed
            cell.keyboardType = .normal
            cell.touchHandler = { [weak self] text in
                
                self?.petInfo.breed = text
            }
            return cell
            
        case 4:
            cell.contentField.placeholder = placeholderArray[4]
            cell.contentField.text = petInfo.color
            cell.keyboardType = .normal
            cell.touchHandler = { [weak self] text in
                
                self?.petInfo.color = text
            }
            return cell
            
        case 5:
            cell.contentField.placeholder = placeholderArray[5]
            cell.contentField.text = petInfo.birth
            cell.keyboardType = .date(Date(), "yyyy-MM-dd")
            cell.touchHandler = { [weak self] text in
                
                self?.petInfo.birth = text
            }
            return cell
            
        case 6:
            cell.contentField.placeholder = placeholderArray[6]
            cell.contentField.text = petInfo.chip
            cell.keyboardType = .normal
            cell.touchHandler = { [weak self] text in
                
                self?.petInfo.chip = text
            }
            return cell
            
        case 7:
            cell.contentField.placeholder = placeholderArray[7]
            
            if petInfo.neuter != nil {
                cell.contentField.text = petInfo.neuter! ? "已經結紮嘍！" : "還沒結紮唷！"
            } else {
                cell.contentField.text = ""
            }
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
            
            if petInfo.memo != "" {
                cell.contentTextView.text = petInfo.memo
                cell.contentTextView.textColor = .black
            }
            
            cell.touchHandler = { [weak self] text in
                
                self?.petInfo.memo = text
            }
            
            return cell
            
        default:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Co Owner Cell", for: indexPath) as? CoOwnerCell else { return UITableViewCell() }
            
            cell.data = petInfo
            cell.titleLabel.text = titleArray[indexPath.row]
            cell.delegate = self
            cell.searchButton.isHidden = false
            cell.searchButton.addTarget(self, action: #selector(searchOwner), for: .touchUpInside)
            cell.collectionView.reloadData()
            
            return cell
        }
    }
    
    @objc func searchOwner() {
        
        guard let viewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(identifier: "Search Owner Page") as? SearchOwnerViewController else {
            return
        }
        
        petInfo.ownersID.removeAll()
        petInfo.ownersName.removeAll()
        petInfo.ownersImage.removeAll()
        
        addCurrentUser()
        
        viewController.selectHandler = { data in
            
            self.petInfo.ownersID.append(contentsOf: data.map { $0.id })
            self.petInfo.ownersName.append(contentsOf: data.map { $0.name })
            self.petInfo.ownersImage.append(contentsOf: data.map { $0.image })
            
            self.tableView.reloadData()
        }
        show(viewController, sender: self)
    }
}

extension CreatePetViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if petInfo.petImage.count > 0 {
            return petInfo.petImage.count + 1
        } else {
            if selectedPhoto.count == 0 {
                return 2
            } else {
                return selectedPhoto.count + 1
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Image Cell", for: indexPath) as? UploadIamgeCell else { return UICollectionViewCell() }
        
        if petInfo.petImage.count > 0 && petInfo.petImage[0] != "" {
            
            if indexPath.row >= petInfo.petImage.count {
                
                cell.removeButton.isHidden = true
                cell.imageButton.isHidden = false
                cell.uplodaImage.isHidden = true
                
            } else {
                
                cell.imageButton.isHidden = true
                cell.uplodaImage.isHidden = false
                
                let url = URL(string: petInfo.petImage[indexPath.item])
                cell.uplodaImage.kf.setImage(with: url)
                
                cell.removeButton.isHidden = false
                cell.removeHandler = { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.petInfo.petImage.remove(at: indexPath.item)
                    collectionView.reloadData()
                }
            }
            
        } else {
            
            if indexPath.row >= selectedPhoto.count {
                
                cell.imageButton.isHidden = false
                cell.uplodaImage.isHidden = true
                
            } else {
                
                cell.imageButton.isHidden = true
                cell.uplodaImage.isHidden = false
                cell.uplodaImage.image = selectedPhoto[indexPath.item]
                
            }
            
            cell.removeButton.isHidden = true
        }
        
        return cell
        
    }
}

extension CreatePetViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 120)
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        var selectedImageFromPicker: UIImage?
        if let pickedImage = info[.originalImage] as? UIImage {
            selectedImageFromPicker = pickedImage
            selectedPhoto.append(selectedImageFromPicker!)
        }
        // 產生一組獨一無二的ID ，方便等一下上傳圖片的命名
        let uniqueString = NSUUID().uuidString
        
        // 當判斷有selectedImage時，在 if 判斷式裡將圖片上傳
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

extension CreatePetViewController: RemoveOwnerDelegate {
    
    func removeOwner(index: Int) {
        petInfo.ownersImage.remove(at: index)
        petInfo.ownersID.remove(at: index)
        petInfo.ownersName.remove(at: index)
    }
}
