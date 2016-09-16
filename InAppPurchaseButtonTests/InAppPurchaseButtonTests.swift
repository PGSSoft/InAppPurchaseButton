//
//  InAppPurchaseButtonTests.swift
//  InAppPurchaseButtonTests
//
//  Created by Paweł Kania on 18/08/16.
//
//

import XCTest
@testable import InAppPurchaseButton

class InAppPurchaseButtonTests: XCTestCase {

	func testInAppPurchaseButtonStates() {
		let inAppPurchaseButton = InAppPurchaseButton()

		XCTAssertTrue(inAppPurchaseButton.buttonState == .regular(animate: true, intermediateState: .inactive))

		inAppPurchaseButton.buttonState = .busy(animate: true)
		XCTAssertTrue(inAppPurchaseButton.buttonState == .busy(animate: true))

		inAppPurchaseButton.buttonState = .downloading(progress: 0.25)
		XCTAssertTrue(inAppPurchaseButton.buttonState == .downloading(progress: 0.25))

		inAppPurchaseButton.buttonState = .downloading(progress: 0.5)
		XCTAssertTrue(inAppPurchaseButton.buttonState == .downloading(progress: 0.5))

		inAppPurchaseButton.buttonState = .downloading(progress: 0.75)
		XCTAssertTrue(inAppPurchaseButton.buttonState == .downloading(progress: 0.75))

		inAppPurchaseButton.buttonState = .downloading(progress: 1)
		XCTAssertTrue(inAppPurchaseButton.buttonState == .downloading(progress: 1))

		inAppPurchaseButton.buttonState = .regular(animate: true, intermediateState: .active)
		XCTAssertTrue(inAppPurchaseButton.buttonState == .regular(animate: true, intermediateState: .active))

		inAppPurchaseButton.buttonState = .regular(animate: true, intermediateState: .inactive)
		XCTAssertTrue(inAppPurchaseButton.buttonState == .regular(animate: true, intermediateState: .inactive))
	}
}
