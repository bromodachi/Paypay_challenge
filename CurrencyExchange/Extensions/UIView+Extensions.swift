import UIKit

///My custom auto constraint helper. Just makes it easier for me to type and add views.
extension UIView {
    @discardableResult func activateConstraintAutomatically(_ toView: Any?, attribute: NSLayoutConstraint.Attribute, multiplier: CGFloat, constant: CGFloat, toParent: Bool, _ relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let tuple = attribute.getOpposite(toParent, value: constant)
        let constraint = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: relatedBy, toItem: toView, attribute: tuple.0, multiplier: multiplier, constant: tuple.1)
        NSLayoutConstraint.activate([constraint])
        return constraint
    }
    @discardableResult func centerX(to view: UIView) -> NSLayoutConstraint{
        return self.activateConstraintAutomatically(view, attribute: .centerX, multiplier: 1.0, constant: 0, toParent: true)
    }
    @discardableResult func centerY(to view: UIView)-> NSLayoutConstraint {
        return self.activateConstraintAutomatically(view, attribute: .centerY, multiplier: 1.0, constant: 0, toParent: true)
    }
    @discardableResult func setHeight(to value: CGFloat, withMultiplier: CGFloat = 1.0, parentView: UIView? = nil)-> NSLayoutConstraint{
        let toParent = parentView != nil
        return self.activateConstraintAutomatically(parentView, attribute: .height, multiplier: withMultiplier, constant: value, toParent: toParent)
    }
    @discardableResult func setWidth(to value: CGFloat, withMultiplier: CGFloat = 1.0, parentView: UIView? = nil) -> NSLayoutConstraint {
        let toParent = parentView != nil
        return self.activateConstraintAutomatically(parentView, attribute: .width, multiplier: withMultiplier, constant: value, toParent: toParent)
    }
    @discardableResult func setLeft(of view: UIView?, distance: CGFloat, withMultiplier: CGFloat = 1.0, isParent: Bool = true) -> NSLayoutConstraint {
        return self.activateConstraintAutomatically(view, attribute: .left, multiplier: withMultiplier, constant: distance, toParent: isParent)
    }
    @discardableResult func setRight(of view: UIView?, distance: CGFloat, withMultiplier: CGFloat = 1.0, isParent: Bool = true) -> NSLayoutConstraint {
        return self.activateConstraintAutomatically(view, attribute: .right, multiplier: withMultiplier, constant: distance, toParent: isParent)
    }
    @discardableResult private func _constraintTo(view: UIView, attribute: NSLayoutConstraint.Attribute, multiplier: CGFloat = 1.0, constant: CGFloat = 0, isParent: Bool = true) -> NSLayoutConstraint {
        return self.activateConstraintAutomatically(view, attribute: attribute, multiplier: multiplier, constant: constant, toParent: isParent)
    }
    @discardableResult func setHeightEqualToWidth(forView: UIView, multiplier: CGFloat = 1.0, constant: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint.init(item: self, attribute: .height, relatedBy: .equal, toItem: forView, attribute: .width, multiplier: multiplier,  constant: constant)
        NSLayoutConstraint.activate([constraint])
        return constraint
    }
    @discardableResult func setWidthEqualToHeight(forView: UIView, multiplier: CGFloat = 1.0, constant: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint.init(item: self, attribute: .width, relatedBy: .equal, toItem: forView, attribute: .height, multiplier: multiplier,  constant: constant)
        NSLayoutConstraint.activate([constraint])
        return constraint
    }
    @discardableResult func setWidth(_ width: CGFloat, multiplier: CGFloat = 1.0) -> NSLayoutConstraint {
        return self.activateConstraintAutomatically(nil, attribute: .width, multiplier: multiplier, constant: width, toParent: false)
    }
    
    /// sets the height to the value. It doesn't set the heigh to the parent!!
    ///
    /// - Parameters:
    ///   - height: <#height description#>
    ///   - multiplier: <#multiplier description#>
    @discardableResult func setHeight(_ height: CGFloat, multiplier: CGFloat = 1.0) -> NSLayoutConstraint {
        return self.activateConstraintAutomatically(nil, attribute: .height, multiplier: multiplier, constant: height, toParent: false)
    }
    @discardableResult func setHeightPorpotionTo(view: UIView, _ height: CGFloat, multiplier: CGFloat = 1.0) -> NSLayoutConstraint {
        return self.activateConstraintAutomatically(view, attribute: .height, multiplier: multiplier, constant: height, toParent: true)
    }
    @discardableResult func setHeightPorpotionTo(view: UIView, multiplier: CGFloat) -> NSLayoutConstraint {
        return self.activateConstraintAutomatically(view, attribute: .height, multiplier: multiplier, constant: 0, toParent: true)
    }
    @discardableResult func setWidthPorpotionTo(view: UIView, _ height: CGFloat, multiplier: CGFloat = 1.0) -> NSLayoutConstraint {
        return self.activateConstraintAutomatically(view, attribute: .width, multiplier: multiplier, constant: height, toParent: true)
    }
    @discardableResult func setWidthPorpotionTo(view: UIView, multiplier: CGFloat = 1.0) -> NSLayoutConstraint {
        return self.activateConstraintAutomatically(view, attribute: .width, multiplier: multiplier, constant: 0, toParent: true)
    }
    /// Center a view to its parent
    @discardableResult func centerXToParent(given view: UIView, multiplier: CGFloat = 1.0, constant: CGFloat = 0) -> NSLayoutConstraint {
        return _constraintTo(view: view, attribute: .centerX,  multiplier: multiplier, constant: constant, isParent: true)
    }
    
    /// Center to a view THAT IS NOT THE PARENT
    @discardableResult func centerXTo(given view: UIView, multiplier: CGFloat = 1.0, constant: CGFloat = 0) -> NSLayoutConstraint {
        return _constraintTo(view: view, attribute: .centerX,  multiplier: multiplier, constant: constant, isParent: false)
    }
    @discardableResult func centerYTo(given view: UIView, multiplier: CGFloat = 1.0, constant: CGFloat = 0) -> NSLayoutConstraint {
        return _constraintTo(view: view, attribute: .centerY,  multiplier: multiplier, constant: constant, isParent: false)
    }
    @discardableResult func centerYToParent(given view: UIView, multiplier: CGFloat = 1.0, constant: CGFloat = 0) -> NSLayoutConstraint {
        return _constraintTo(view: view, attribute: .centerY,  multiplier: multiplier, constant: constant, isParent: true)
    }
    @discardableResult func topToParent(given view: UIView, multiplier: CGFloat = 1.0, constant: CGFloat = 0) -> NSLayoutConstraint {
        return _constraintTo(view: view, attribute: .top,  multiplier: multiplier, constant: constant, isParent: true)
    }
    @discardableResult func topOf(given view: UIView, multiplier: CGFloat = 1.0, constant: CGFloat = 0) -> NSLayoutConstraint {
        return _constraintTo(view: view, attribute: .bottom,  multiplier: multiplier, constant: constant, isParent: false)
    }
    @discardableResult func leftToParent(given view: UIView, multiplier: CGFloat = 1.0, constant: CGFloat = 0) -> NSLayoutConstraint {
        return _constraintTo(view: view, attribute: .left,  multiplier: multiplier, constant: constant, isParent: true)
    }
    @discardableResult func leftOf(given view: UIView, multiplier: CGFloat = 1.0, constant: CGFloat = 0) -> NSLayoutConstraint {
        return _constraintTo(view: view, attribute: .right,  multiplier: multiplier, constant: constant, isParent: false)
    }
    
    @discardableResult func rightToParent(given view: UIView, multiplier: CGFloat = 1.0, constant: CGFloat = 0) -> NSLayoutConstraint {
        return _constraintTo(view: view, attribute: .right,  multiplier: multiplier, constant: constant, isParent: true)
    }
    @discardableResult func rightOf(given view: UIView, multiplier: CGFloat = 1.0, constant: CGFloat = 0) -> NSLayoutConstraint {
        return _constraintTo(view: view, attribute: .left,  multiplier: multiplier, constant: constant, isParent: false)
    }
    @discardableResult func bottomToParent(given view: UIView, multiplier: CGFloat = 1.0, constant: CGFloat = 0) -> NSLayoutConstraint {
        return _constraintTo(view: view, attribute: .bottom,  multiplier: multiplier, constant: constant, isParent: true)
    }
    @discardableResult func bottomOf(given view: UIView, multiplier: CGFloat = 1.0, constant: CGFloat = 0) -> NSLayoutConstraint {
        return _constraintTo(view: view, attribute: .top,  multiplier: multiplier, constant: constant, isParent: false)
    }
    @discardableResult func leftAndRightOfParent(_ parent: Any?, constant: CGFloat) -> (NSLayoutConstraint, NSLayoutConstraint) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let left = self.activateConstraintAutomatically(parent, attribute: .left, multiplier: 1.0, constant: constant, toParent: true)
        let right = self.activateConstraintAutomatically(parent, attribute: .right, multiplier: 1.0, constant: constant, toParent: true)
        return (left, right)
    }
    @discardableResult func topAndBottomOfParent(_ parent: Any?, constant: CGFloat) -> (NSLayoutConstraint, NSLayoutConstraint) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let top = self.activateConstraintAutomatically(parent, attribute: .top, multiplier: 1.0, constant: constant, toParent: true)
        let bottom = self.activateConstraintAutomatically(parent, attribute: .bottom, multiplier: 1.0, constant: constant, toParent: true)
        return (top, bottom)
    }
    @discardableResult func setTopToLayoutGuide(controller: UIViewController ,distance: CGFloat, withMultiplier: CGFloat = 1.0) -> NSLayoutConstraint
    {
        if #available(iOS 11.0, *) {
            return self.activateConstraintAutomatically(controller.view.safeAreaLayoutGuide, attribute: .top, multiplier: withMultiplier, constant: distance, toParent: true)
        } else {
            return self.activateConstraintAutomatically(controller.topLayoutGuide, attribute: .top, multiplier: withMultiplier, constant: distance, toParent: false)
        }
    }
}
