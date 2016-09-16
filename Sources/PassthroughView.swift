//
//  PassthroughView.swift
//  InAppPurchaseButton
//
//  Created by Paweł Kania on 17/08/16.
//
//

import Foundation

class PassthroughView: UIView {

	override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		let hitView = super.hitTest(point, with: event)
		if hitView == self {
			return nil
		}
		return hitView
	}
}
