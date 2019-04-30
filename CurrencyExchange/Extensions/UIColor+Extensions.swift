//
//  UIColor+Extensions.swift
//  CurrencyExchange
//
//  Created by Conrado Uraga on 2019/04/14.
//  Copyright © 2019 Conrado Uraga. All rights reserved.
//

import UIKit

extension UIColor {
    //makes the color we sent a little lighter by x amount
    func lighter(amount by: CGFloat = 0.25) -> UIColor {
        return changeHueByAmount(amount: 1 + by)
    }
    //makes the color we sent a little darker by x amount
    func darker(amount by: CGFloat = 0.25) -> UIColor {
        return changeHueByAmount(amount: 1 - by)
    }
    //actually makes the color darker/lighter by using the getHue method
    private func changeHueByAmount(amount by: CGFloat) -> UIColor {
        var hue, saturation, brightness, alpha: CGFloat
        hue = 0
        saturation = 0
        brightness = 0
        alpha = 0
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor.init(hue: hue, saturation: saturation, brightness: brightness * by, alpha: alpha)
        } else {
            return self
        }
    }
}
