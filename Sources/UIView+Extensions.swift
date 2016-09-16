//
//  UIView+Extensions.swift
//  InAppPurchaseButton
//
//  Created by Paweł Kania on 17/08/16.
//
//

import Foundation

extension UIView {

	/**
	 Stretches the view in superview by adding four constraints with attributes: *.Top*, *.Bottom*, *.Leading*, *.Trailing*

	 **Important!** View needs to have superview, before calling this method
	 */
	func fulfillSuperview() {
		assert(superview != nil, "View should have a superview")

		guard let superview = superview else {
			return
		}

		translatesAutoresizingMaskIntoConstraints = false

		let topConstraint = NSLayoutConstraint(item: self,
			attribute: .top,
			relatedBy: .equal,
			toItem: superview,
			attribute: .top,
			multiplier: 1,
			constant: 0)
		let bottomConstraint = NSLayoutConstraint(item: self,
			attribute: .bottom,
			relatedBy: .equal,
			toItem: superview,
			attribute: .bottom,
			multiplier: 1,
			constant: 0)
		let leadingConstraint = NSLayoutConstraint(item: self,
			attribute: .leading,
			relatedBy: .equal,
			toItem: superview,
			attribute: .leading,
			multiplier: 1,
			constant: 0)
		let trailingConstraint = NSLayoutConstraint(item: self,
			attribute: .trailing,
			relatedBy: .equal,
			toItem: superview,
			attribute: .trailing,
			multiplier: 1,
			constant: 0)

		superview.addConstraints([bottomConstraint, topConstraint, leadingConstraint, trailingConstraint])
	}

	/**
	 Adds two constraints to the view (with attributes: *.CenterX* and *.CenterY*).

	 **Important!** View needs to have superview, before calling this method
	 */
	func centerInSuperview() {
		assert(superview != nil, "View should have a superview")

		guard let superview = superview else {
			return
		}

		translatesAutoresizingMaskIntoConstraints = false

		let centerXConstraint = NSLayoutConstraint(item: self,
			attribute: .centerX,
			relatedBy: .equal,
			toItem: superview,
			attribute: .centerX,
			multiplier: 1,
			constant: 0)
		let centerYConstraint = NSLayoutConstraint(item: self,
			attribute: .centerY,
			relatedBy: .equal,
			toItem: superview,
			attribute: .centerY,
			multiplier: 1,
			constant: 0)

		superview.addConstraints([centerXConstraint, centerYConstraint])
	}
}
