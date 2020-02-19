//
//  UIColor+Extension.swift
//  Personal Project
//
//  Created by Savannah Su on 2020/2/6.
//  Copyright © 2020 Savannah Su. All rights reserved.
//

import UIKit

private enum GHColor: String {
    // swiftlint:disable identifier_name
    case G0
    case G1
    case G2
    case G3
}

extension UIColor {
    static let G0 = GHColor(.G0)
    static let G1 = GHColor(.G1)
    static let G2 = GHColor(.G2)
    static let G3 = GHColor(.G3)

    // swiftlint:enable identifier_name
    private static func GHColor(_ color: GHColor) -> UIColor? {
        return UIColor(named: color.rawValue)
    }
}






