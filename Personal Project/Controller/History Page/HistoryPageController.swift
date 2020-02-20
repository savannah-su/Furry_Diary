//
//  HistoryPageController.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/19.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit
import FSCalendar

extension Date {
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}

class HistoryPageController: UIViewController {
    
    @IBOutlet weak var choosePetCollection: UICollectionView!{
        
        didSet {
            choosePetCollection.delegate = self
            choosePetCollection.dataSource = self
        }
    }
    
    @IBOutlet weak var calendar: FSCalendar! {
        
        didSet {
            calendar.delegate = self
            calendar.dataSource = self
        }
    }
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            
            
        }
    }
    
    @IBOutlet weak var subitemCollection: UICollectionView!
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = { [unowned self] in
        
        let panGesture = UIPanGestureRecognizer(
            target: self.calendar,
            action: #selector(self.calendar.handleScopeGesture(_:))
        )
        
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
        }()
    
    var petID = ""
    
    lazy var formatter: DateFormatter = {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy/MM/dd"
        
        return formatter
    }()
    
    // 當月有紀錄有的資料
    var currentMonthlyData: [Record] = [] {
        
        didSet {
            calendar.reloadData()
        }
    }
    
    var selectedDate: Date = Date() {
        
        didSet {
            getCurrentDateData()
        }
    }
    
    var currentDateData: [Record] = [] {
        
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setCalendar()
        
        getMonthlyData()
        
        tableView.separatorColor = .clear
        // Do any additional setup after loading the view.
    }
    
    // 上滑月曆變週曆
    func setCalendar() {
        self.view.addGestureRecognizer(self.scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
    }
    
    func getMonthlyData() {
        
        DownloadManager.shared.monthlyData.removeAll()
        
        DownloadManager.shared.downloadMonthlyData(petID:
        "E4306502-DF94-4BE3-BDF2-36889A8EED59", startOfMonth: calendar.currentPage.startOfMonth(), endOfMonth: calendar.currentPage.endOfMonth()) { [weak self] result in
            
            switch result {
            case .success(let monthlyData):
                print(monthlyData)
                
                self?.currentMonthlyData = monthlyData
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getCurrentDateData() {
        
        for index in 0 ..< currentMonthlyData.count {
            
            let currentDate = currentMonthlyData[index].date
            
            if formatter.string(from: selectedDate) == formatter.string(from: currentDate) {
                
                currentDateData = currentMonthlyData
                
            } else {
                
                return
            }
        }
    }
}

extension HistoryPageController: FSCalendarDelegate {
    
    // 月曆-週曆
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    //滑動月曆後重新去抓月資料
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        getMonthlyData()
    }
    
    //點選日期
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        getCurrentDateData()
    }
}

extension HistoryPageController: FSCalendarDataSource {
    
    //事件點點
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        for index in 0 ..< currentMonthlyData.count {
            
            let eventDate = currentMonthlyData[index].date
            
            if formatter.string(from: eventDate) == formatter.string(from: date) {
                
                return 1
            }
        }
        
        return 0
    }
}

extension HistoryPageController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        let shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top
        
        if shouldBegin {
            
            let velocity = self.scopeGesture.velocity(in: self.view)
            
            switch self.calendar.scope {
                
            case .month:
                return velocity.y < 0
                
            case .week:
                return velocity.y > 0
                
            default:
                return false
            }
        }
        return shouldBegin
    }
}


extension HistoryPageController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 165
    }
}

extension HistoryPageController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if currentDateData.count != 0 {
            return currentDateData.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Record Cell", for: indexPath) as? RecordCell else {
            return UITableViewCell()
        }
        
        cell.subitemCollection.delegate = self
        cell.subitemCollection.dataSource = self
        
        switch currentDateData[indexPath.row].categoryType {
            
        case "衛生清潔":
            cell.cellType = .clean
            cell.recordDate.text = formatter.string(from: currentDateData[indexPath.row].date)
            
            if currentDateData[indexPath.row].notiDate == "" {
                cell.nextDateLabel.text = "下次清潔\(currentDateData[indexPath.row].notiDate)"
            } else {
            cell.nextDateLabel.isHidden = true
            }
            
        case "預防計畫":
            cell.cellType = .prevent
            cell.recordDate.text = formatter.string(from: currentDateData[indexPath.row].date)
            cell.contentLabel.text = currentDateData[indexPath.row].medicineName
            
            if currentDateData[indexPath.row].notiDate == "" {
                cell.nextDateLabel.text = "下次清潔\(currentDateData[indexPath.row].notiDate)"
            } else {
            cell.nextDateLabel.isHidden = true
            }
            
        case "體重紀錄":
            cell.cellType = .weight
            cell.recordDate.text = formatter.string(from: currentDateData[indexPath.row].date)
            cell.contentLabel.text = "\(currentDateData[indexPath.row].kilo)KG"
            
        default:
            cell.cellType = .behavior
            cell.recordDate.text = formatter.string(from: currentDateData[indexPath.row].date)
        }
        
        return cell
    }
    
}

extension HistoryPageController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.choosePetCollection {
            
            petID = UploadManager.shared.simplePetInfo[indexPath.item].petID
        }
    }
}

extension HistoryPageController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.choosePetCollection {
            return UploadManager.shared.simplePetInfo.count
        }
        return currentDateData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.choosePetCollection {
            
            guard let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: "Pet Cell", for: indexPath) as? WhichPetCell else { return UICollectionViewCell() }
            
            cellA.petName.text = UploadManager.shared.simplePetInfo[indexPath.row].petName
            
            let url = URL(string: UploadManager.shared.simplePetInfo[indexPath.row].petPhoto.randomElement()!)
            cellA.petPhoto.kf.setImage(with: url)
            cellA.petPhoto.contentMode = .scaleToFill
            
            return cellA
            
        } else {
            
            guard let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: "Subitem Cell", for: indexPath) as? SubitemCell else {
                return UICollectionViewCell()
            }
            
            guard let subitemData = currentDateData[indexPath.item].subitem else { return UICollectionViewCell() }
            
            for index in 0 ..< subitemData.count {
            cellB.subitemLabel.text = subitemData[index]
            }
            
            return cellB
        }
    }
}

extension HistoryPageController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.choosePetCollection {
            return CGSize(width: 80, height: 100)
        }
        return CGSize(width: 100, height: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == self.choosePetCollection {
            return UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
        }
        return UIEdgeInsets()
    }
}
