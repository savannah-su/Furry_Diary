//
//  VetPageController.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/22.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class VetPageController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private lazy var geoCoder: CLGeocoder = {
        return CLGeocoder()
    }()
     
    var myLocationManager :CLLocationManager!
    
    let manager = GetDataManager()
    
    var vetPlacemarkInfo: [VetPlacemarkData] = []
    
    var placemarks: [CLPlacemark]?
    
    var vetData: [VetData] = [] {
        
        didSet {
            if vetData.isEmpty {
                return
            } else {
                DispatchQueue.main.async {
//                    self.getPlacemarker()
                }
            }
        }
    }
    var vetLatitude: Double = 0.0
    var vetLongitude: Double = 0.0
    
    var touchedVet = ""
    var currentPlaceMarker: CLPlacemark?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        mapView.delegate = self
        
        setupLocation()
        
        setupMap()
        
        downloadVetData()
        
        navigationController?.navigationBar.barStyle = .black
        
//        getVetData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        locationAuth()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        myLocationManager.stopUpdatingLocation()
    }
    
    func getVetData() {
        
        manager.getData(urlString: "https://data.coa.gov.tw/Service/OpenData/DataFileService.aspx?UnitId=078&$top=27&$skip=1600") { [weak self] result in
            
            switch result {
                
            case .success(let vetData):
                
                self?.vetData = vetData
                
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    func getPlacemarker() {
        
        for index in 0 ..< vetData.count {
            
            let withoutWhitespace = vetData[index].vetAddress.trimmingCharacters(in: .whitespaces)
            
            manager.getVetPlacemark(addressString: withoutWhitespace) { [weak self] result in
                
                guard let strongSelf = self else { return }
                
                switch result {
                    
                case .success(let vetPlacemarks):
                    
                    strongSelf.vetPlacemarkInfo.append(vetPlacemarks)
                    
                    if index == strongSelf.vetData.count - 1 {
                        strongSelf.toFireBase()
                    }
                    
                case .failure(let error):
                    
                    print(error)
                }
            }
        }
    }
    
    func downloadVetData() {
        
        DownloadManager.shared.downloadVetPlacemark { [weak self] result in
            
            switch result {
                
            case .success(let apple):
                
                print(apple.count)
                
                self?.setupPin()
                
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    func toFireBase() {
        
         for index in 0 ..< vetPlacemarkInfo.count {
            
            if vetPlacemarkInfo[index].results.count == 0 {
                continue
                
            } else {
                
                UploadManager.shared.uploadVet(vetName: vetData[index].vetName, vetPhone: vetData[index].vetPhone, vetAddress: vetData[index].vetAddress, vetLatitude: vetPlacemarkInfo[index].results[0].geometry.location.lat, vetLongitude: vetPlacemarkInfo[index].results[0].geometry.location.lng) { result in
                    
                    switch result {
                    case .success(let uploadVetData):
                        print("To Firebase Success")
                        print(uploadVetData)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func setupLocation() {
        
        // 建立一個 CLLocationManager
        myLocationManager = CLLocationManager()
        
        // 設置委任對象
        myLocationManager.delegate = self
        
        // 距離篩選器 用來設置移動多遠距離才觸發委任方法更新位置
        myLocationManager.distanceFilter =
        kCLLocationAccuracyNearestTenMeters
        
        // 取得自身定位位置的精確度
        myLocationManager.desiredAccuracy =
        kCLLocationAccuracyBest
    }
    
    func locationAuth() {
        
        // 首次使用 向使用者詢問定位自身位置權限
        if CLLocationManager.authorizationStatus()
            == .notDetermined {
            // 取得定位服務授權
            myLocationManager.requestWhenInUseAuthorization()
            
            // 開始定位自身位置
            myLocationManager.startUpdatingLocation()
        }
            // 使用者已經拒絕定位自身位置權限
        else if CLLocationManager.authorizationStatus()
            == .denied {
            // 提示可至[設定]中開啟權限
            let alertController = UIAlertController(
                title: "定位權限已關閉",
                message:
                "如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟",
                preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "確認", style: .default, handler:nil)
            alertController.addAction(okAction)
            self.present(
                alertController,
                animated: true, completion: nil)
        }
            // 使用者已經同意定位自身位置權限
        else if CLLocationManager.authorizationStatus()
            == .authorizedWhenInUse {
            // 開始定位自身位置
            myLocationManager.startUpdatingLocation()
        }
    }
    
    func setupMap() {
        
        // 地圖樣式
        mapView.mapType = .standard
        
        // 顯示自身定位位置
        mapView.showsUserLocation = true
        
        // 允許縮放地圖
        mapView.isZoomEnabled = true
        
        // 加入到畫面中
        self.view.addSubview(mapView)
    }
    
    func setupPin() {
        
        // 建立一個地點圖示 (圖示預設為圓形紅色泡泡)
        
        let vetPlacemark = DownloadManager.shared.vetPlacemark
        
        for count in 0 ..< vetPlacemark.count {
            
            let objectAnnotation = MKPointAnnotation()
            
            objectAnnotation.coordinate = CLLocationCoordinate2D(latitude: vetPlacemark[count].vetLatitude, longitude: vetPlacemark[count].vetLongitude)
            
            objectAnnotation.title = "\(vetPlacemark[count].vetName)(\(vetPlacemark[count].vetPhone))"
            objectAnnotation.subtitle = vetPlacemark[count].vetAddress
            
            mapView.addAnnotation(objectAnnotation)
        }
    }
}

extension VetPageController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // 印出目前所在位置座標
        let currentLocation :CLLocation =
            locations[0] as CLLocation
        print("\(currentLocation.coordinate.latitude)")
        print(" \(currentLocation.coordinate.longitude)")
        
        geoCoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) -> Void in
            
            self.currentPlaceMarker = placemarks?.first
            
//            guard let address = placeMark.thoroughfare else {
//                return
//            }
//
//            guard let city = placeMark.subAdministrativeArea else {
//                return
//            }
//
//            guard let counrty = placeMark.country else {
//                return
//            }
//
//            self.currentAddress = "\(counrty) \(city) \(address)"
//
//            print("============")
//            print(self.currentAddress)
        }
        
        // 地圖預設顯示的範圍大小 (數字越小越精確)
        let latDelta = 0.005
        let longDelta = 0.005
        let currentLocationSpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        
        // 設置地圖顯示的範圍與中心點座標
        let center: CLLocation = CLLocation(
            latitude: myLocationManager.location!.coordinate.latitude, longitude: myLocationManager.location!.coordinate.longitude)
        
        let currentRegion: MKCoordinateRegion = MKCoordinateRegion(
            center: center.coordinate,
            span: currentLocationSpan)
        
        mapView.setRegion(currentRegion, animated: true)
    }
}

extension VetPageController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
           return nil
        }
        
        // 建立可重複使用的 MKPinAnnotationView
        let reuseId = "Pin"
        var pinView =
            mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            // 建立一個大頭針視圖
            pinView = MKPinAnnotationView(
                annotation: annotation,
                reuseIdentifier: reuseId)
            // 設置點擊大頭針後額外的視圖
            pinView?.canShowCallout = true
            //視窗右方資訊鍵
            //pinView?.rightCalloutAccessoryView = nil
            // 會以落下釘在地圖上的方式出現
            pinView?.animatesDrop = false
            // 大頭針的顏色
            pinView?.pinTintColor =
                UIColor.red
            // 將視圖右邊資訊鍵設為一個按鈕
            let infoBtn = UIButton(type: .detailDisclosure)
            infoBtn.addTarget(self, action: #selector(infoDetail), for: .touchUpInside)
            pinView?.rightCalloutAccessoryView = infoBtn
            
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    @objc func infoDetail() {
        let alertController = UIAlertController(title: "選擇功能", message: nil, preferredStyle: .actionSheet)
        let guideAction = UIAlertAction(title: "導航路線", style: .default) { (_) in
            self.guideToVet(destination: self.touchedVet)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(guideAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        touchedVet = (view.annotation?.subtitle ?? "") ?? ""
        
    }
    
    func guideToVet(destination: String) {
        
        self.geoCoder.geocodeAddressString(destination) { (place: [CLPlacemark]?, _) -> Void in
            
            
            guard let currentPlaceMarker = self.currentPlaceMarker,
                  let destination = place?.first
            else {
                    return
            }
            
            self.beginGuide(currentPlaceMarker, endPLCL: destination)
        }
    }
    
    // - 導航 -
    func beginGuide(_ startPLCL: CLPlacemark, endPLCL: CLPlacemark) {
        let startplMK: MKPlacemark = MKPlacemark(placemark: startPLCL)
        let startItem: MKMapItem = MKMapItem(placemark: startplMK)
        let endplMK: MKPlacemark = MKPlacemark(placemark: endPLCL)
        let endItem: MKMapItem = MKMapItem(placemark: endplMK)
        let mapItems: [MKMapItem] = [startItem, endItem]
        let dic: [String: AnyObject] = [
            // 导航模式:驾驶
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving as AnyObject,
            // 地图样式：标准样式
            MKLaunchOptionsMapTypeKey: MKMapType.standard.rawValue as AnyObject,
            // 显示交通：显示
            MKLaunchOptionsShowsTrafficKey: true as AnyObject]
        // 根据 MKMapItem 的起点和终点组成数组, 通过导航地图启动项参数字典, 调用系统的地图APP进行导航
        MKMapItem.openMaps(with: mapItems, launchOptions: dic)
    }
}
