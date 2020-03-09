//
//  Banner.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/10.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit

protocol BannerViewDataSource: AnyObject {
    
    func numberOfPages(in bannerView: BannerView) -> Int
    
    func viewFor(bannerView: BannerView, at index: Int) -> UIView
}

protocol BannerViewDelegate: AnyObject {
    
    func didScrollToPage(_ bannerView: BannerView, page: Int)
}

class BannerView: UIView {
    
    weak var delegate: BannerViewDelegate?
    
    weak var dataSource: BannerViewDataSource? {
        
        didSet {
        
            guard self.dataSource != nil else {
                
                unitViews.forEach { $0.removeFromSuperview() }
                
                return
            }
            
            setupBasicBannerPageViews()
        }
    }
    
    var unitViews: [BannerUnitView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBaseScrollView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupBaseScrollView()
    }
    
    lazy var scrollView: UIScrollView = {
        
        let scrollView = UIScrollView()
        
        scrollView.contentInsetAdjustmentBehavior = .never
        
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.delegate = self
        
        self.addSubview(scrollView)
        
        return scrollView
    }()
    
    func manipulateWidthConstraints(with constant: CGFloat) {
        
        for unitView in unitViews {
            
            unitView.widthConstraint?.constant = constant
        }
    }
    
    func reloadData() {
        
        setupBasicBannerPageViews()
    }
    
    private func setupBaseScrollView() {
        
        scrollView.isPagingEnabled = true

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupBasicBannerPageViews() {
        
        unitViews.forEach { $0.removeFromSuperview() }
        
        unitViews.removeAll()
        
        guard let dataSource = dataSource else { return }
        
        let pages = dataSource.numberOfPages(in: self)
        
        for index in 0 ..< pages {
            
            let unitView = generateUnitView()
            
            unitView.contentView = dataSource.viewFor(bannerView: self, at: index)
            
            unitViews.append(unitView)
        
            scrollView.addSubview(unitView)
        }
        
        for (index, unitView) in unitViews.enumerated() {
            
            if index == 0 {
                
                NSLayoutConstraint.activate([
                    unitView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                    unitView.heightAnchor.constraint(equalTo: heightAnchor)
                ])
                
            } else {
                
                NSLayoutConstraint.activate([
                    unitView.leadingAnchor.constraint(equalTo: unitViews[index - 1].trailingAnchor)
                ])
            }
            
            if index == unitViews.count - 1 {
                
                NSLayoutConstraint.activate([
                    unitView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
                ])
            }
            
            NSLayoutConstraint.activate([
                unitView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                unitView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                unitView.widthAnchor.constraint(equalTo: widthAnchor)
            ])
        }
    }
    
    private func generateUnitView() -> BannerUnitView {
        
        let unitView = BannerUnitView()
        
        unitView.translatesAutoresizingMaskIntoConstraints = false
        
        return unitView
    }
}

extension BannerView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    
        delegate?.didScrollToPage(self, page: page)
    }
}

class BannerUnitView: UIView {
    
    var widthConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        clipsToBounds = true
    }
    
    var contentView: UIView? {
        
        willSet {
            
            contentView?.removeFromSuperview()
            
            widthConstraint?.isActive = false
            
            widthConstraint = nil
        }
        
        didSet {
            
            guard let contentView = contentView else {
                
                return
            }
            
            addSubview(contentView)
            
            contentView.translatesAutoresizingMaskIntoConstraints = false
            
            widthConstraint = contentView.widthAnchor.constraint(equalTo: widthAnchor)
            
            NSLayoutConstraint.activate([
                contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
                widthConstraint!,
                contentView.topAnchor.constraint(equalTo: topAnchor),
                contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    }
}
