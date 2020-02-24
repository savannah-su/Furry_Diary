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
    @IBOutlet weak var alertLabel: UILabel!
    
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
        
        formatter.dateFormat = "yyyy-MM-dd"
        
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
            if currentDateData.isEmpty {
            } else {
                tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setCalendar()
        
        tableView.separatorColor = .clear
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        selectedDate = Date()
        
        currentDateData.removeAll()
        
        alertLabel.isHidden = false
        
        calendar.allowsSelection = false
        calendar.scrollEnabled = false
        calendar.reloadData()
        
        choosePetCollection.reloadData()
        tableView.reloadData()
    }
    
    // 上滑月曆變週曆
    func setCalendar() {
        self.view.addGestureRecognizer(self.scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
    }
    
    func getMonthlyData() {
        
        DownloadManager.shared.monthlyData.removeAll()
        
        DownloadManager.shared.downloadMonthlyData(petID:
        petID, startOfMonth: calendar.currentPage.startOfMonth(), endOfMonth: calendar.currentPage.endOfMonth()) { [weak self] result in
            
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
        
        var data: [Record] = []
        
        for index in 0 ..< currentMonthlyData.count {
            
            let currentDate = currentMonthlyData[index].date
            
            if formatter.string(from: selectedDate) == formatter.string(from: currentDate) {
                
                data.append(currentMonthlyData[index])
            }
        }
        
        self.currentDateData = data
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
        
        switch currentDateData[indexPath.section].categoryType {
            
        case "衛生清潔":
            return 161
        case "預防計畫":
            return 192
        case "體重紀錄":
            return 161
        default:
            return 161
        }
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
        cell.subitemCollection.reloadData()
        
        switch currentDateData[indexPath.row].categoryType {
            
        case "衛生清潔":
            cell.cellType = .clean
            cell.recordDate.text = formatter.string(from: currentDateData[indexPath.row].date)
            
            if currentDateData[indexPath.row].notiDate != "" {
                cell.contentLabel.text = "下次清潔\(currentDateData[indexPath.row].notiDate ?? "")"
            } else {
            cell.contentLabel.isHidden = true
            }
            
        case "預防計畫":
            cell.cellType = .prevent
            cell.recordDate.text = formatter.string(from: currentDateData[indexPath.row].date)
            cell.contentLabel.text = currentDateData[indexPath.row].medicineName
            
            if currentDateData[indexPath.row].notiDate != "" {
                cell.nextDateLabel.text = "下次施作是\(currentDateData[indexPath.row].notiDate ?? "")"
            } else {
            cell.nextDateLabel.isHidden = true
            }
            
        case "體重紀錄":
            cell.cellType = .weight
            cell.recordDate.text = formatter.string(from: currentDateData[indexPath.row].date)
            cell.contentLabel.text = "\(currentDateData[indexPath.row].kilo ?? "") KG"
            
        default:
            cell.cellType = .behavior
            cell.recordDate.text = formatter.string(from: currentDateData[indexPath.row].date)
            
            if currentDateData[indexPath.row].memo == "" || currentDateData[indexPath.row].memo == "輸入相關敘述或其他事件" {
                cell.contentLabel.isHidden = true
            } else {
                cell.contentLabel.text = currentDateData[indexPath.row].memo ?? ""
            }
        }
        
        return cell
    }
    
}

extension HistoryPageController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.choosePetCollection {
            
            alertLabel.isHidden = true
            
            petID = UploadManager.shared.simplePetInfo[indexPath.item].petID
            
            getMonthlyData()
            
            calendar.allowsSelection = true
            
            calendar.scrollEnabled = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let spring = UISpringTimingParameters(dampingRatio: 0.7, initialVelocity: CGVector(dx: 1.0, dy: 0.2))
        let animator = UIViewPropertyAnimator(duration: 0.5, timingParameters: spring)
               cell.alpha = 0
               cell.transform = CGAffineTransform(translationX: 0, y: 100 * 0.6)
               animator.addAnimations {
                   cell.alpha = 1
                   cell.transform = .identity
                 self.choosePetCollection.layoutIfNeeded()
               }
               animator.startAnimation(afterDelay: 0.1 * Double(indexPath.item))
    }
}

extension HistoryPageController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.choosePetCollection {
            return UploadManager.shared.simplePetInfo.count
        }
        return currentDateData[section].subitem?.count ?? 0
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
            
            guard let subitemData = currentDateData[indexPath.section].subitem else { return UICollectionViewCell() }
            
            switch currentDateData[indexPath.section].categoryType {
                
            case "衛生清潔":
                cellB.layer.backgroundColor = UIColor.R0?.cgColor
            case "預防計畫":
                cellB.layer.backgroundColor = UIColor.G1?.cgColor
            case "體重紀錄":
                cellB.layer.backgroundColor = UIColor.B0?.cgColor
            default:
                cellB.layer.backgroundColor = UIColor.P0?.cgColor
            }
                cellB.subitemLabel.text = subitemData[indexPath.row]
            
            return cellB
        }
    }
}

extension HistoryPageController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.choosePetCollection {
            return CGSize(width: 70, height: 90)
        }
        return CGSize(width: 100, height: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == self.choosePetCollection {
            return 16
        }
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayot: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == self.choosePetCollection {
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
        
        guard let itemCount = currentDateData[section].subitem?.count else { return UIEdgeInsets() }
        
        return UIEdgeInsets(top: 0, left: (UIScreen.main.bounds.width - 100 * CGFloat(itemCount) - 20 * CGFloat(itemCount - 1) - 40) / 2, bottom: 0, right: (UIScreen.main.bounds.width - 100 * CGFloat(itemCount) - 20 * CGFloat(itemCount - 1) - 40) / 2)
    }
}
