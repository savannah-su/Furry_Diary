//
//  WeightViewController.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/12.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit
import PNChart
import JGProgressHUD

/*
 
 PNLineChart * lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
 [lineChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5"]];
 
 // Line Chart No.1
 NSArray * data01Array = @[@60.1, @160.1, @126.4, @262.2, @186.2];
 PNLineChartData *data01 = [PNLineChartData new];
 data01.color = PNFreshGreen;
 data01.itemCount = lineChart.xLabels.count;
 data01.getData = ^(NSUInteger index) {
 CGFloat yValue = [data01Array[index] floatValue];
 return [PNLineChartDataItem dataItemWithY:yValue];
 };
 // Line Chart No.2
 NSArray * data02Array = @[@20.1, @180.1, @26.4, @202.2, @126.2];
 PNLineChartData *data02 = [PNLineChartData new];
 data02.color = PNTwitterColor;
 data02.itemCount = lineChart.xLabels.count;
 data02.getData = ^(NSUInteger index) {
 CGFloat yValue = [data02Array[index] floatValue];
 return [PNLineChartDataItem dataItemWithY:yValue];
 };
 
 lineChart.chartData = @[data01, data02];
 [lineChart strokeChart];
 You can choose to show smooth lines.
 
 lineChart.showSmoothLines = YES;
 */

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
    @IBOutlet weak var weightTextField: UITextField!
    
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
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        toGetRecord()
        setupDatePicker()
        
        weightTextField.delegate = self
        
        saveButton.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
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
        
        DownloadManager.shared.downloadData(type: 2, petID: petID) { result in
            
            switch result {
                
            case .success(let downloadWeightData):
                
                //(map, filet, reduce)給Array用的for in, 組成左邊新的array; filter是把右邊true的情況，組成左邊新的array
                downloadWeightData.sorted{ return $0.date > $1.date }.prefix(5).reversed().forEach { info in
                    
                    guard let kiloString = info.kilo else { return }
                    
                    let kiloDouble = Double(kiloString)
                    
                    guard let dataKilo = kiloDouble else { return }
                    
                    let data = WeightData(date: info.date, weight: dataKilo)
                    
                    self.weightData.append(data)
                    
                    let showDateFormatter = DateFormatter()
                    
                    showDateFormatter.dateFormat = "yyyy/MM"
                    
                    var sortedDateString = showDateFormatter.string(from: info.date)
                    
                    var sortedKiloDouble = dataKilo
                    
                    self.xLabels.append(sortedDateString)
                    
                    self.data.append(sortedKiloDouble)
                    
                    self.setupChart()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func uploadSuccess() {
           let hud = JGProgressHUD(style: .dark)
           hud.textLabel.text = "Success!"
           hud.show(in: self.view)
           hud.dismiss(afterDelay: 3.0)
           hud.indicatorView = JGProgressHUDSuccessIndicatorView()
       }
    
    func toDataBase() {
        
        getInfo()
        
        UploadManager.shared.uploadData(petID: petID, categoryType: "體重紀錄", date: datePicker.date, subitem: ["體重紀錄"], medicineName: "", kilo: weight, memo: "", notiOrNot: "", notiDate: "", notiText: "") { result in
            
            switch result {
            case .success(let success):
                print(success)
                self.uploadSuccess()
                self.toGetRecord()
            case .failure(let error):
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
        
        chartData.color = UIColor(red:245.0 / 255.0, green:172.0 / 255.0, blue:26.0 / 255.0, alpha:1.0)
        
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
        
        if weightTextField.text != "" {
            saveButton.isEnabled = true
        }
    }
}
