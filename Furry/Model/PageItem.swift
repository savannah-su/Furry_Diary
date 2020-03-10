//
//  CellModel.swift
//  Furry
//
//  Created by Savannah Su on 2020/3/7.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import Foundation

struct DailyPageContent {
    
    let titel: String
    let image: String
    let selectedImage: String
    var status: Bool = false
    
    init(lbl: String, image: String, selectedImage: String) {
        self.titel = lbl
        self.image = image
        self.selectedImage = selectedImage
    }
}

struct RecordCategoryPage {
    
    let title: String
    let image: String
    
    init(title: String, image: String) {
        self.title = title
        self.image = image
    }
}
