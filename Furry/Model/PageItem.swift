//
//  CellModel.swift
//  Furry
//
//  Created by Savannah Su on 2020/3/7.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import Foundation

struct PageContent {
    
    let lbl: String
    let image: String
    let selectedImage: String
    var status: Bool = false
    
    init(lbl: String, image: String, selectedImage: String) {
        self.lbl = lbl
        self.image = image
        self.selectedImage = selectedImage
    }
}
