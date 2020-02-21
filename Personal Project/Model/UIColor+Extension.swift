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
    case R0
    case P0
    case B0
}

extension UIColor {
    static let G0 = GHColor(.G0)
    static let G1 = GHColor(.G1)
    static let G2 = GHColor(.G2)
    static let G3 = GHColor(.G3)
    static let R0 = GHColor(.R0)
    static let P0 = GHColor(.P0)
    static let B0 = GHColor(.B0)

    // swiftlint:enable identifier_name
    private static func GHColor(_ color: GHColor) -> UIColor? {
        return UIColor(named: color.rawValue)
    }
}






