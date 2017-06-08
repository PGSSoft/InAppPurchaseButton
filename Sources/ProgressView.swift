//
//  ProgressView.swift
//  InAppPurchaseButton
//
//  Created by Paweł Kania on 17/08/16.
//
//

import Foundation

class ProgressView: PassthroughView {

	// MARK: - Properties

	private let progressLayer = CAShapeLayer()
	private var progressColor: UIColor = DefaultSettings.activeStateColor
	private var progressBorderWidth: CGFloat = 2
	private var attributedText: NSAttributedString?
	private var indicatorImage: UIImage?

	var progress: CGFloat = 0 {
		didSet {
			var value = progress
			if progress > 1 {
				value = 1
			} else if value < 0 {
				value = 0
			}
			progress = value
			progressLayer.strokeEnd = progress
		}
	}

	// MARK: - Initializers

	init(frame: CGRect, progressColor: UIColor, progressBorderWidth: CGFloat, attributedText: NSAttributedString?, indicatorImage: UIImage?) {
		super.init(frame: frame)
		self.progressColor = progressColor
		self.progressBorderWidth = progressBorderWidth
		self.attributedText = attributedText
		self.indicatorImage = indicatorImage
		setupView()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupView()
	}

	// MARK: - Layout

	override func layoutSubviews() {
		super.layoutSubviews()
		progressLayer.frame = bounds
		progressLayer.path = UIBezierPath(ovalIn: bounds.insetBy(dx: progressBorderWidth - progressBorderWidth / 2, dy: progressBorderWidth - progressBorderWidth / 2)).cgPath
	}

	// MARK: - Helpers

	fileprivate func setupView() {
		// Setup ring
		progressLayer.frame = bounds
		progressLayer.lineWidth = progressBorderWidth
		progressLayer.fillColor = UIColor.clear.cgColor
		progressLayer.strokeColor = progressColor.cgColor
		progressLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		progressLayer.transform = CATransform3DRotate(progressLayer.transform, -CGFloat(Double.pi/2), 0, 0, 1)
		layer.addSublayer(progressLayer)

		if let attributedString = attributedText {
			let ringLabel = UILabel(frame: bounds)
			ringLabel.attributedText = attributedString
			addSubview(ringLabel)
			ringLabel.centerInSuperview()
		}

		if let ringImage = indicatorImage {
			let ringImageView = UIImageView(image: ringImage)
			addSubview(ringImageView)
			ringImageView.centerInSuperview()
		}
	}
}
