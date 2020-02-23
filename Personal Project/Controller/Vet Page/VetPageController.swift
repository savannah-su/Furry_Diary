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
    
    var myLocationManager :CLLocationManager!
    
    let manager = GetDataManager()
    
    var vetPlacemarkInfo: [VetPlacemarkData]?
    
    var placemarks: [CLPlacemark]?
    
    var vetData: [VetData] = [] {
        
        didSet {
            if vetData.isEmpty {
                return
            } else {
                DispatchQueue.main.async {
//                    self.addressToPlacemark()
                    self.getPlacemarker()
                }
            }
        }
    }
    var vetLatitude: Double = 0.0
    var vetLongitude: Double = 0.0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        mapView.delegate = self
        
        setupLocation()
        
        setupMap()

        getVetData()
        
        
  
//        addressToPlacemark()
        // Do any additional setup after loading the view.
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
        
        manager.getData(urlString: "https://data.coa.gov.tw/Service/OpenData/DataFileService.aspx?UnitId=078&$top=1000&$skip=0") { [weak self] result in
            
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
                
                switch result {
                    
                case .success(let vetPlacemarks):
                    
                    self?.vetPlacemarkInfo = vetPlacemarks
                    
                    print(vetPlacemarks)
                    
                case .failure(let error):
                    
                    print(error)
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
    
    func addressToPlacemark() {
        
//        for index in 0 ..< 2 {
//
//            //地址轉經緯度
//            let geoCoder = CLGeocoder()
//            geoCoder.geocodeAddressString(vetData[index].vetAddress, completionHandler: {
//                (placemarks: [AnyObject]?, error: Error!) -> Void in
//
//                if error != nil {
//                    print(error!)
//                    return
//                }
//
//                guard let marks = placemarks else {
//                    return
//                }
//                for count in 0 ..< marks.count  {
//                    guard let placeMarks = marks[count] as? CLPlacemark else {return}
//                    self.placemark?.append(placeMarks)
//                }
//                print(self.placemark ?? ["error"])
//            })
//        }
        self.setupPin()
    }
    
    func setupPin() {
        
//        // 建立一個地點圖示 (圖示預設為圓形紅色泡泡)
//        var objectAnnotation = MKPointAnnotation()
//
//        guard let placemark = placemark else {
//            return }
//
//        for count in 0 ..< vetData.count {
//        objectAnnotation.coordinate = CLLocationCoordinate2D(latitude: placemark.location?.coordinate.latitude ?? 0, longitude: placemark.location?.coordinate.longitude ?? 0)
//        objectAnnotation.title = "AppWorks"
//        objectAnnotation.subtitle =
//          "Coding Coding Coding"
//        }
//
//        mapView.addAnnotation(objectAnnotation)
    }
}

extension VetPageController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // 印出目前所在位置座標
        let currentLocation :CLLocation =
          locations[0] as CLLocation
        print("\(currentLocation.coordinate.latitude)")
        print(", \(currentLocation.coordinate.longitude)")
        
        // 地圖預設顯示的範圍大小 (數字越小越精確)
        let latDelta = 0.001
        let longDelta = 0.001
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
                    // 會以落下釘在地圖上的方式出現
                    pinView?.animatesDrop = true
                    // 大頭針的顏色
                    pinView?.pinTintColor =
                        UIColor.red
                    // 這邊將額外視圖的右邊視圖設為一個按鈕
                    pinView?.rightCalloutAccessoryView =
                      UIButton(type: .detailDisclosure)
                } else {
                    pinView?.annotation = annotation
                }

                return pinView
            
    }
}
