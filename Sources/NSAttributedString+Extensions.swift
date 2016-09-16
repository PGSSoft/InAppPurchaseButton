//
//  NSAttributedString+Extensions.swift
//  InAppPurchaseButton
//
//  Created by Paweł Kania on 17/08/16.
//
//

import Foundation

extension NSAttributedString {

	/// Gives minimal possible size required to display inside UILabel
	var minSizeForAttributedString: CGSize {
		let label = UILabel(frame: .zero)
		label.attributedText = self
		label.sizeToFit()
		return label.frame.size
	}
}
