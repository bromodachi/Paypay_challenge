//
//  NSLayoutConstraint+Extensions.swift
//  CurrencyExchange
//
//  Created by Conrado Uraga on 2019/04/13.
//  Copyright © 2019 Conrado Uraga. All rights reserved.
//

import UIKit
extension NSLayoutConstraint.Attribute {
    func getOpposite(_ isParent: Bool, value: CGFloat) -> (NSLayoutConstraint.Attribute, CGFloat) {
        switch self {
            case .left:
                return isParent ? (.left, value) : (.right, value)
            case .right:
                return isParent ? (.right, value * -1) : (.left, value * -1)
            case .top:
                return isParent ? (.top, value * 1) : (.bottom, value * 1)
            case .bottom:
                return isParent ? (.bottom, value * -1) : (.top, value * -1)
            case .height:
                return isParent ? (.height, value) : (.notAnAttribute, value)
            case .width:
                return isParent ? (.width, value) : (.notAnAttribute, value)
            default:
                return (self, value)
        }
    }
}
