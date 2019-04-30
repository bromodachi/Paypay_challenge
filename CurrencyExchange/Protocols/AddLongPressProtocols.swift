//
//  AddLongPressProtocols.swift
//  CurrencyExchange
//
//  Created by Conrado Uraga on 2019/04/14.
//  Copyright © 2019 Conrado Uraga. All rights reserved.
//

import UIKit

/// helps creates a long pressure gesture given a view. In your selector function, you should always use isValid.
protocol AddLongPressToSimulateTouchUpInside: class { }
extension AddLongPressToSimulateTouchUpInside {
    typealias VoidFunction = ()->Void
    /// Creates a long pressure to be added to the view. Purpose is to team up with isValid
    ///
    /// - Parameters:
    ///   - view: add a long pressure to
    ///   - selector: what should happen when the user presses the view
    ///   - target: automatically assumed to be self if nil
    public func createLongPresssRecognizer(forview view: UIView, selector: Selector, target: Any? = nil, minimumPressDuration: TimeInterval = 0) {
        view.isUserInteractionEnabled = true
        let longPress = UILongPressGestureRecognizer(target: target == nil ? self : target, action: selector)
        longPress.minimumPressDuration = minimumPressDuration
        view.addGestureRecognizer(longPress)
    }
    
    
    /// Given a long press, checks when the state ends, if it still within the logn pressure bounds view bounds.
    /// - Parameters:
    ///   - additionalFunction: clean up function for when the long pressure ends.
    public func isValid(longPress: UILongPressGestureRecognizer, needsAnimation: Bool = true, _ additionalFunction: @escaping VoidFunction = { ()-> Void in }) -> Bool {
        guard let view = longPress.view, longPress.state == .ended else { return false }
        if needsAnimation {
            UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve, animations: {
                additionalFunction()
            }, completion: nil)
        }
        else {
            additionalFunction()
        }
        let point = longPress.location(in: view)
        return view.bounds.contains(point)
    }
}
