//
//  WeightViewController.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/12.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit
import PNChart

class WeightPageViewController: UIViewController {
    
    @IBAction func backButton(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var saveButton: VerticalAlignedButton!
    @IBAction func saveButton(_ sender: Any) {

        toDataBase()
    }
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var firstBar: UIView!
    @IBOutlet weak var dateTextfield: UITextField!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var secondBar: UIView!
    @IBOutlet weak var weightTextField: UITextField! {
        didSet {
            self.weightTextField.delegate = self
        }
    }
    
    @IBOutlet weak var kgLabel: UILabel!
    
    let date = Date()
    var xLabels: [String] = []
    var data: [Double] = []
    let chartData = PNLineChartData()
    var lineChart = PNLineChart()
    
    let datePicker = UIDatePicker()
    let showDateFormatter = DateFormatter()
    
    var enterDate = Date()
    var petID = ""
    var doneDate = ""
    var weight = ""
    
    var weightData = [WeightData]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        petID == "" ? setupChart() : toGetRecord()
        
        setupDatePicker()
        
        saveButton.isEnabled = false
        saveButton.setTitleColor(UIColor.lightGray, for: .disabled)
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        topView.layer.cornerRadius = topView.bounds.height / 2
        bottomView.layer.cornerRadius = bottomView.bounds.height / 2
        
    }
    
    func toGetRecord() {
        
        DownloadManager.shared.petRecord.removeAll()
        
        self.xLabels.removeAll()
                           
        self.data.removeAll()
        
        DownloadManager.shared.downloadRecordData(categoryType: 2, petID: petID) { result in
            
            switch result {
                
            case .success(let downloadWeightData):
                
                //(map, filet, reduce)給Array用的for in, 組成左邊新的array; filter是把右邊true的情況，組成左邊新的array
                downloadWeightData.sorted { return $0.date > $1.date }.prefix(5).reversed().forEach { info in
                    
                    guard let kiloString = info.kilo else { return }
                    
                    let kiloDouble = Double(kiloString)
                    
                    guard let dataKilo = kiloDouble else { return }
                    
                    let data = WeightData(date: info.date, weight: dataKilo)
                    
                    self.weightData.append(data)
                    
                    let showDateFormatter = DateFormatter()
                    
                    showDateFormatter.dateFormat = "yyyy/MM"
                    
                    let sortedDateString = showDateFormatter.string(from: info.date)
                    
                    let sortedKiloDouble = dataKilo
                    
                    self.xLabels.append(sortedDateString)
                    
                    self.data.append(sortedKiloDouble)
                    
                    self.setupChart()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func toDataBase() {
        
        getInfo()
        
        let data = Record(categoryType: "體重紀錄", subitem: ["體重紀錄"], medicineName: "", kilo: weight, memo: "", date: datePicker.date, notiOrNot: "", notiDate: "", notiText: "")
        
        UploadManager.shared.uploadData(petID: petID, data: data) { result in
            
            switch result {
            case .success(let success):
                UploadManager.shared.uploadSuccess(text: "上傳成功！")
                print(success)
                self.toGetRecord()
            case .failure(let error):
                UploadManager.shared.uploadFail(text: "上傳失敗！")
                print(error.localizedDescription)
            }
        }
    }
    
    func getInfo() {
        
        guard let enterDate = dateTextfield.text else {
            return
        }
        doneDate = enterDate
        
        guard let enterWeight = weightTextField.text else {
            return
        }
        weight = enterWeight
    }
    
    func setupDatePicker() {
        
        showDateFormatter.dateFormat = "yyyy-MM-dd"
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "zh_TW")
        datePicker.addTarget(self, action: #selector(changeDate), for: .valueChanged)
        dateTextfield.inputView = datePicker
        changeDate()
    }
    
    @objc func changeDate() {
        dateTextfield.text = showDateFormatter.string(from: datePicker.date)
    }
    
    @objc func setupChart() {
        
        lineChart = PNLineChart(frame: CGRect(origin: CGPoint(x: 0, y: topView.bounds.height / 2), size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - topView.bounds.height)))
        
        lineChart.setXLabels(xLabels, withWidth: UIScreen.main.bounds.width / CGFloat(xLabels.count + 2))
        
        //        lineChart.xLabelFont = UIFont(name: "System Bold", size: 20)
        
        lineChart.showYGridLines = true
        
        lineChart.isShowCoordinateAxis = true
        
        //        lineChart.yLabelFont = UIFont(name: "System Bold", size: 50)
        //
        //        lineChart.yLabelHeight = 50
        
        lineChart.showSmoothLines = true
        
        chartData.color = UIColor(red: 245.0 / 255.0, green: 172.0 / 255.0, blue: 26.0 / 255.0, alpha: 1.0)
        
        chartData.itemCount = UInt(exactly: Double(lineChart.xLabels.count))!
        
        chartData.lineWidth = 4
        
        chartData.getData = { item in
            
            let lineChart = PNLineChartDataItem(y: CGFloat(self.data[Int(item)]))
            
            return lineChart
        }
        
        lineChart.chartData = [chartData]
        
        lineChart.stroke()
        
        view.addSubview(lineChart)
        
    }
}

extension WeightPageViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if weightTextField.text != "" || petID != "" {
            saveButton.isEnabled = true
            saveButton.setTitleColor(UIColor.G4, for: .normal)
        }
        saveButton.setTitleColor(UIColor.lightGray, for: .disabled)
    }
}
