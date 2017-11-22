//
//  ViewController.swift
//  iOS Example
//
//  Created by Pawel Kania on 06/05/16.
//  Copyright © 2016 PGS Software. All rights reserved.
//

import UIKit
import InAppPurchaseButton

class ViewController: UIViewController {

	// MARK: - Outlets

	@IBOutlet weak var inAppPurchaseButton1: InAppPurchaseButton! {
		didSet {
			inAppPurchaseButton1.attributedTextForInactiveState = generateAttributedString("$1.99", fontColor: .white)
			inAppPurchaseButton1.attributedTextForActiveState = generateAttributedString("Open", fontColor: .white)
			inAppPurchaseButton1.imageForInactiveState = UIImage(named: "pinkbutton")
			inAppPurchaseButton1.imageForActiveState = UIImage(named: "bluebutton")
			inAppPurchaseButton1.attributedTextForProgressView = generateAttributedString("⇣", fontColor: defaultActiveColor)
		}
	}
	@IBOutlet weak var inAppPurchaseButton2: InAppPurchaseButton! {
		didSet {
			inAppPurchaseButton2.attributedTextForInactiveState = generateAttributedString("$0.99", fontColor: defaultInactiveColor)
			inAppPurchaseButton2.attributedTextForActiveState = generateAttributedString("Open", fontColor: defaultActiveColor)
			inAppPurchaseButton2.cornerRadiusForExpandedBorder = 8
			inAppPurchaseButton2.borderWidthForProgressView = 4
			inAppPurchaseButton2.shouldAlwaysDisplayBorder = true
		}
	}
	@IBOutlet weak var inAppPurchaseButton3: InAppPurchaseButton! {
		didSet {
			inAppPurchaseButton3.attributedTextForInactiveState = generateAttributedString("$4.99", fontColor: .white)
			inAppPurchaseButton3.attributedTextForActiveState = generateAttributedString("Open", fontColor: .white)
			inAppPurchaseButton3.cornerRadiusForExpandedBorder = 10
			inAppPurchaseButton3.borderWidthForProgressView = 3
			inAppPurchaseButton3.backgroundColorForInactiveState = defaultInactiveColor
			inAppPurchaseButton3.backgroundColorForActiveState = defaultActiveColor
			inAppPurchaseButton3.attributedTextForProgressView = generateAttributedString("◼︎", fontColor: defaultActiveColor)
		}
	}
	@IBOutlet weak var inAppPurchaseButton4: InAppPurchaseButton! {
		didSet {
			let activeColor = UIColor(red: 130 / 255, green: 184 / 255, blue: 59 / 255, alpha: 1)
			let inactiveColor = UIColor(red: 89 / 255, green: 116 / 255, blue: 146 / 255, alpha: 1)

			inAppPurchaseButton4.attributedTextForInactiveState = generateAttributedString("$6.99", fontColor: .white)
			inAppPurchaseButton4.attributedTextForActiveState = generateAttributedString("Open", fontColor: .white)
			inAppPurchaseButton4.backgroundColorForInactiveState = inactiveColor
			inAppPurchaseButton4.backgroundColorForActiveState = activeColor
			inAppPurchaseButton4.borderColorForInactiveState = inactiveColor
			inAppPurchaseButton4.borderColorForActiveState = activeColor
			inAppPurchaseButton4.ringColorForProgressView = activeColor
			inAppPurchaseButton4.indicatorImageForProgressMode = UIImage(named: "progress-indicator")
		}
	}
	@IBOutlet weak var inAppPurchaseButton5: InAppPurchaseButton! {
		didSet {
			let activeColor = UIColor(red: 141 / 255, green: 19 / 255, blue: 81 / 255, alpha: 1)
			let inactiveColor = UIColor(red: 89 / 255, green: 89 / 255, blue: 94 / 255, alpha: 1)

			inAppPurchaseButton5.attributedTextForInactiveState = generateAttributedString("$9.99", fontColor: .white)
			inAppPurchaseButton5.attributedTextForActiveState = generateAttributedString("Open", fontColor: .white)
			inAppPurchaseButton5.cornerRadiusForExpandedBorder = 0
			inAppPurchaseButton5.backgroundColorForInactiveState = inactiveColor
			inAppPurchaseButton5.backgroundColorForActiveState = activeColor
			inAppPurchaseButton5.borderColorForInactiveState = inactiveColor
			inAppPurchaseButton5.borderColorForActiveState = activeColor
			inAppPurchaseButton5.ringColorForProgressView = activeColor
			inAppPurchaseButton5.minExpandedSize = .zero
			inAppPurchaseButton5.prefferedTitleMargins = .zero
			inAppPurchaseButton5.widthForBusyView = 20
		}
	}

	// MARK: - Actions

	@IBAction func inAppPurchaseButton1Touched(_ sender: InAppPurchaseButton) {
		switch sender.buttonState {
		case .regular(animate: _, intermediateState: .inactive):
			sender.buttonState = .busy(animate: true)
		case .busy(animate: _):
			sender.buttonState = .downloading(progress: 0.25)
		case .downloading(progress: 0.25):
			sender.buttonState = .downloading(progress: 0.5)
		case .downloading(progress: 0.5):
			sender.buttonState = .downloading(progress: 0.75)
		case .downloading(progress: 0.75):
			sender.buttonState = .downloading(progress: 1)
		case .downloading(progress: _):
			sender.buttonState = .regular(animate: true, intermediateState: .active)
		case .regular(animate: _, intermediateState: .active):
			sender.buttonState = .regular(animate: false, intermediateState: .inactive)
		}
	}

	// MARK: - Helpers

	func generateAttributedString(_ string: String, fontColor: UIColor = .white) -> NSAttributedString {
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = .center
		return NSAttributedString(string: string, attributes: [NSAttributedStringKey.font: UIFont(name: "Helvetica", size: 17)!, NSAttributedStringKey.foregroundColor: fontColor, NSAttributedStringKey.paragraphStyle: paragraphStyle])
	}

	var defaultInactiveColor: UIColor {
		return UIColor(red: 198 / 255, green: 107 / 255, blue: 160 / 255, alpha: 1)
	}

	var defaultActiveColor: UIColor {
		return UIColor(red: 129 / 255, green: 209 / 255, blue: 216 / 255, alpha: 1)
	}

}
