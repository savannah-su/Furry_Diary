//
//  WeightViewController.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/12.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit
import PNChart

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
    @IBAction func saveButton(_ sender: Any) {
    }
    
    @IBOutlet weak var dateTextfield: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    
    let date = Date()
    let xLabels = ["Step 1", "Step 2", "Step 3", "Step 4", "Step 5", "Step 6"]
    let data = [60.1, 160.1, 126.4, 262.2, 186.2, 300.8]
    let chartData = PNLineChartData()
    let lineChart = PNLineChart(frame: CGRect(origin: CGPoint(x: 8, y: 300), size: CGSize(width: UIScreen.main.bounds.width, height: 280)))
    
    let datePicker = UIDatePicker()
    let showDateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChart()
        
        setupDatePicker()
        
    }
    
    func setupDatePicker() {
        
        showDateFormatter.dateFormat = "yyyy-MM-dd"
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "zh_TW")
        datePicker.addTarget(self, action: #selector(changeDate), for: .valueChanged)
        dateTextfield.inputView = datePicker
    }
    
    @objc func changeDate() {
        dateTextfield.text = showDateFormatter.string(from: datePicker.date)
    }
    
    func setupChart() {
        
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
