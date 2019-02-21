//
//  DefaultSettings.swift
//  InAppPurchaseButton
//
//  Created by Paweł Kania on 17/08/16.
//
//

import Foundation
import UIKit

enum DefaultSettings {
	static let inactiveStateColor = UIColor(red: 198 / 255, green: 107 / 255, blue: 160 / 255, alpha: 1)
	static let activeStateColor = UIColor(red: 129 / 255, green: 209 / 255, blue: 216 / 255, alpha: 1)

    static let focusColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)

	static let minExpandedSize = CGSize(width: 90, height: 32)
	static let prefferedTitleMargins = CGSize(width: 26, height: 8)
	static let widthForBusyView: CGFloat = 32
	static let cornerRadiusForExpandedBorder: CGFloat = 2
	static let borderWidthForBusyView: CGFloat = 1
	static let borderWidthForProgressView: CGFloat = 2
	static let animationDuration: TimeInterval = 0.2
}
