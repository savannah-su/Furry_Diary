//
//  PrivateWebViewController.swift
//  Furry
//
//  Created by Savannah Su on 2020/3/2.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit
import WebKit

class PrivateWebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupWebView()
        // Do any additional setup after loading the view.
    }
    
    func setupWebView() {
        
        guard let webURL = URL(string: "https://github.com/savannah-su/Furry") else {
            return
        }
        
        let request = URLRequest.init(url: webURL)
        
        self.webView.load(request)
        
    }
}
