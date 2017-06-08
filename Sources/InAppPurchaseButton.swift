//
//  InAppPurchaseButton.swift
//  InAppPurchaseButton
//
//  Created by Paweł Kania on 17/08/16.
//
//

import UIKit

public enum ButtonState {
    case regular(animate: Bool, intermediateState: IntermediateState)
    case busy(animate: Bool)
    case downloading(progress: CGFloat)
}

public enum IntermediateState {
    case inactive
    case active
}

public func == (left: ButtonState, right: ButtonState) -> Bool {
    switch (left, right) {
    case (.regular(_, let intermediateStateLeft), .regular(_, let intermediateStateRight)) where intermediateStateLeft == intermediateStateRight:
        return true
    case (.busy(_), .busy(_)):
        return true
    case (.downloading(let progressLeft), .downloading(let progressRight)) where progressLeft == progressRight:
        return true
    default:
        return false
    }
}

open class InAppPurchaseButton: UIButton {

    // MARK: - Public properties

    /// The button won't be smaller than *minExpandedSize* (concerns *.Regular(animate: _, intermediateState: _)* state only).
    ///
    /// Set to *.zero* if this feature shouldn't be applied.
    open var minExpandedSize: CGSize = DefaultSettings.minExpandedSize

    /// Text close to edge doesn't look good. Use this property to add some space.
    /// Default value means: 13 points on the left and right, 4 points on the top and bottom.
    /// Set to *.zero* if this feature shouldn't be applied.
    open var prefferedTitleMargins: CGSize = DefaultSettings.prefferedTitleMargins

    /// The color of border in case when *buttonState* is in *.Regular(animate: _, intermediateState: .Inactive)* state.
    open var borderColorForInactiveState: UIColor = DefaultSettings.inactiveStateColor

    /// The color of border in case when *buttonState* is in *.Regular(animate: _, intermediateState: .Active)* state.
    open var borderColorForActiveState: UIColor = DefaultSettings.activeStateColor

    /// Fill color of the button in case when *buttonState* is in *.Regular(animate: _, intermediateState: .Inactive)* state.
    /// Might be *nil*, which is equivalent to *.clearColor()*.
    open var backgroundColorForInactiveState: UIColor?

    /// Fill color of the button in case when *buttonState* is in *.Regular(animate: _, intermediateState: .Active)* state.
    /// Might be *nil*, which is equivalent to *.clearColor()*
    open var backgroundColorForActiveState: UIColor?

    /// Background image of the button in case when *buttonState* is in *.Regular(animate: _, intermediateState: .Inactive)* state.
    /// Might be *nil*
    open var imageForInactiveState: UIImage?

    /// Background image of the button in case when *buttonState* is in *.Regular(animate: _, intermediateState: .Active)* state.
    /// Might be *nil*
    open var imageForActiveState: UIImage?

    /// Determines the actual diameter of the button in case when *buttonState* is in *.Busy(animate: _)* state.
    open var widthForBusyView = DefaultSettings.widthForBusyView

    /// Determines corner radius when button is in transition state (from *.Regular(animate: _, intermediateState: _)* to *.Busy(animate: _)* and in opposite side)
    open var cornerRadiusForExpandedBorder = DefaultSettings.cornerRadiusForExpandedBorder

    /// Border width in case when *buttonState* is in *.Busy(animate: _)* state.
    open var borderWidthForBusyView = DefaultSettings.borderWidthForBusyView

    /// Border width in case when *buttonState* is in *.Busy(animate: _)* state.
    open var borderWidthForProgressView = DefaultSettings.borderWidthForProgressView

    /// Color of the ring in case when *buttonState* is in *.Downloading(progress: _)* state.
    open var ringColorForProgressView: UIColor = DefaultSettings.activeStateColor

    /// Attributed text displayed in case when *buttonState* is in *.Downloading(progress: _)* state.
    /// Might be *nil*
    open var attributedTextForProgressView: NSAttributedString?

    /// Image displayed in case when *buttonState* is in *.Downloading(progress: _)* state.
    /// Might be *nil*
    open var indicatorImageForProgressMode: UIImage?

    /// Determines the duration of the transition animation
    open var transitionAnimationDuration: TimeInterval = DefaultSettings.animationDuration

    /// Determines whether border should be visible all the time or only during transition.
    /// **Important!** By default border is visible only during transition.
    open var shouldAlwaysDisplayBorder: Bool = false {
        didSet {
            if shouldAlwaysDisplayBorder {
                // In this case we need to force redrawing
                // You must set this flag before setting `borderColorForInactiveState`
                setupBorderView(cornerRadius: cornerRadiusForExpandedBorder, borderColor: borderColorForInactiveState)
            }
        }
    }

    /// Attributed text displayed in case when *buttonState* is in *.Regular(animate: _, intermediateState: .Inactive)*  state.
    /// Might be *nil*
    open var attributedTextForInactiveState: NSAttributedString?

    /// Attributed text displayed in case when *buttonState* is in *.Regular(animate: _, intermediateState: .Active)*  state.
    /// Might be *nil*
    open var attributedTextForActiveState: NSAttributedString?

    /// Use this to determine button state.
    /// - Remark:
    /// Following transitions support animation:
    /// 1. From *.Regular(animate: _, intermediateState: .Inactive)* to *.Processing(animate: true)*
    /// 2. From *.Regular(animate: _, intermediateState: .Active)* to *.Processing(animate: true)*
    /// 3. From *.Processing(animate: _)* to *.Regular(animate: true, intermediateState: .Inactive)*
    /// 4. From *.Processing(animate: _)* to *.Regular(animate: true, intermediateState: .Active)*
    /// 5. From *.Downloading(progress: _)* to *.Regular(animate: true, intermediateState: .Inactive)*
    /// 6. From *.Downloading(progress: _)* to *.Regular(animate: true, intermediateState: .Active)*
    /// - SeeAlso: `ButtonState`
    /// - SeeAlso: `IntermediateState`
    open var buttonState = ButtonState.regular(animate: false, intermediateState: .inactive) {
        didSet {
            switch buttonState {
            case let .regular(animate: animate, intermediateState: .inactive):
                if oldValue == buttonState { break }
                transitionFromBusyToRegular(animate, intermediateState: .inactive)
            case let .regular(animate: animate, intermediateState: .active):
                if oldValue == buttonState { break }
                transitionFromBusyToRegular(animate, intermediateState: .active)
            case let .busy(animate: animate):
                if oldValue == buttonState { break }
                switch oldValue {
                case .downloading(_):
                    transitionFromNormalToBusy(false, intermediateState: lastIntermediateState)
                    break
                default:
                    transitionFromNormalToBusy(animate)
                }
            case let .downloading(progress: progress):
                switch oldValue {
                case .downloading(_) where (oldValue == buttonState) == false: // Workaround to avoid overloading `!=`
                    progressView.progress = progress
                case .regular(animate: false, intermediateState: .inactive):
                    fallthrough
                case .regular(animate: false, intermediateState: .active):
                    transitionFromNormalToBusy(false, intermediateState: lastIntermediateState)
                    fallthrough
                default:
                    transitionFromBusyToDownloading(progress)
                }
            }
        }
    }

    // MARK: - Private properties

    private lazy var once: () = {
        guard let titleLabel = self.titleLabel else {
            return
        }

        titleLabel.fulfillSuperview()
        self.setAttributedTitle(self.attributedTextForInactiveState, for: UIControlState())

        self.colouredBackgroundView = PassthroughView(frame: self.bounds)
        self.insertSubview(self.colouredBackgroundView, belowSubview: titleLabel)
        self.colouredBackgroundView.fulfillSuperview()
        self.colouredBackgroundView.layer.cornerRadius = self.cornerRadiusForExpandedBorder
        self.colouredBackgroundView.backgroundColor = self.backgroundColorForInactiveState

        self.backgroundImageView = UIImageView(image: self.imageForInactiveState)
        self.insertSubview(self.backgroundImageView, belowSubview: titleLabel)
        self.backgroundImageView.fulfillSuperview()
    }()

    private var lastRegularButtonState = ButtonState.regular(animate: false, intermediateState: .inactive) {
        didSet {
            switch lastRegularButtonState {
            case .regular(animate: _, intermediateState: _):
                break
            default:
                lastRegularButtonState = oldValue
            }
        }
    }

    private var lastIntermediateState: IntermediateState? {
        switch lastRegularButtonState {
        case .regular(animate: _, intermediateState: .inactive):
            return .inactive
        case .regular(animate: _, intermediateState: .active):
            return .active
        default:
            return nil
        }
    }

    private var cornerRadiusForBusyView: CGFloat {
        return widthForBusyView / 2
    }

    private var expandedSize: CGSize! {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    private var backgroundImageView: UIImageView!
    private var colouredBackgroundView: PassthroughView!
    private var borderView: PassthroughView!
    private var busyView: PassthroughView!
    private var progressView: ProgressView!
    private var layoutToken: Int = 0

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitle(nil, for: UIControlState()) // Clear placeholder
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setTitle(nil, for: UIControlState()) // Clear placeholder
    }

    // MARK: - Layout

    override open var intrinsicContentSize: CGSize {
        if let expandedSize = expandedSize {
            return expandedSize
        }

        return super.intrinsicContentSize
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        _ = self.once
    }

    // MARK: - Overwritten methods

    open override func setAttributedTitle(_ title: NSAttributedString?, for state: UIControlState) {
        super.setAttributedTitle(title, for: state)

        if let title = title {
            expandedSize = calculatePrefferedSize(title)
        }
    }

    // MARK: - Helpers

    private func calculatePrefferedSize(_ attributedString: NSAttributedString) -> CGSize {
        var prefferedSize = attributedString.minSizeForAttributedString

        if prefferedSize.width + prefferedTitleMargins.width < minExpandedSize.width {
            prefferedSize.width = minExpandedSize.width
        } else {
            prefferedSize.width += prefferedTitleMargins.width
        }

        if prefferedSize.height + prefferedTitleMargins.height < minExpandedSize.height {
            prefferedSize.height = minExpandedSize.height
        } else {
            prefferedSize.height += prefferedTitleMargins.height
        }

        return prefferedSize
    }

    private func setupBorderView(cornerRadius: CGFloat, borderColor: UIColor) {
        borderView?.removeFromSuperview()
        borderView = PassthroughView(frame: bounds.insetBy(dx: borderWidthForBusyView, dy: borderWidthForBusyView))
        addSubview(borderView)
        borderView.fulfillSuperview()
        borderView.layer.cornerRadius = cornerRadius
        borderView.layer.borderColor = borderColor.cgColor
        borderView.layer.borderWidth = borderWidthForBusyView
    }

    private func setupBusyView(_ progress: CGFloat = 0.8) {
        busyView?.removeFromSuperview()
        busyView = PassthroughView(frame: bounds)
        addSubview(busyView)
        busyView.fulfillSuperview()
        let bezierPath = UIBezierPath(ovalIn: bounds.insetBy(dx: borderWidthForBusyView - borderWidthForBusyView / 2, dy: borderWidthForBusyView - borderWidthForBusyView / 2)).cgPath
        let progressLayer = CAShapeLayer()
        progressLayer.path = bezierPath
        progressLayer.strokeColor = borderColorForActiveState.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = borderWidthForBusyView
        progressLayer.strokeEnd = progress
        busyView.layer.addSublayer(progressLayer)
    }

    private func setupBusyViewAnimation() {
        let spinAnimation = CABasicAnimation(keyPath: "transform.rotation")
        spinAnimation.toValue = 2 * Double.pi
        spinAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        spinAnimation.duration = 1
        spinAnimation.repeatCount = Float.infinity
        busyView.layer.add(spinAnimation, forKey: "transform.rotation")
    }

    private func setupProgressView() {
        progressView?.removeFromSuperview()
        progressView = ProgressView(frame: bounds, progressColor: ringColorForProgressView, progressBorderWidth: borderWidthForProgressView, attributedText: attributedTextForProgressView, indicatorImage: indicatorImageForProgressMode)
        addSubview(progressView)
        progressView.fulfillSuperview()
        progressView.progress = 0
    }

    // MARK: - Transitions

    private func transitionFromNormalToBusy(_ animate: Bool, intermediateState: IntermediateState? = nil) {
        busyView?.removeFromSuperview()
        progressView?.removeFromSuperview()

        var borderColor: UIColor?

        if let intermediateState = intermediateState {
            switch intermediateState {
            case .inactive:
                borderColor = borderColorForInactiveState
            case .active:
                borderColor = borderColorForActiveState
            }
        }

        setupBorderView(cornerRadius: cornerRadiusForExpandedBorder, borderColor: borderColorForInactiveState)
        borderView.alpha = shouldAlwaysDisplayBorder ? 1 : 0

        let animBlock1: () -> Void = {
            self.borderView.alpha = 1
            self.setAttributedTitle(nil, for: UIControlState())
            self.backgroundImageView?.alpha = 0
            self.colouredBackgroundView?.alpha = 0
        }

        let setupBusyViewWithAnimation: () -> Void = {
            self.borderView.alpha = 0
            self.setupBusyView()
            self.setupBusyViewAnimation()
        }

        let animBlock2: () -> Void = {
            if animate {
                CATransaction.begin()
                CATransaction.setCompletionBlock {
                    setupBusyViewWithAnimation()
                }

                let cornerAnimation = CABasicAnimation(keyPath: "cornerRadius")
                cornerAnimation.fromValue = self.cornerRadiusForExpandedBorder
                cornerAnimation.toValue = self.cornerRadiusForBusyView
                cornerAnimation.duration = self.transitionAnimationDuration
                cornerAnimation.fillMode = kCAFillModeForwards
                cornerAnimation.isRemovedOnCompletion = false
                self.borderView.layer.add(cornerAnimation, forKey: "cornerRadius")

                let colorAnimation = CABasicAnimation(keyPath: "borderColor")
                colorAnimation.fromValue = self.borderView.layer.borderColor
                colorAnimation.toValue = borderColor != nil ? borderColor!.cgColor : self.borderColorForActiveState.cgColor
                colorAnimation.duration = self.transitionAnimationDuration
                colorAnimation.fillMode = kCAFillModeForwards
                colorAnimation.isRemovedOnCompletion = false
                self.borderView.layer.add(colorAnimation, forKey: "borderColor")

                let borderAnimation = CABasicAnimation(keyPath: "borderWidth")
                borderAnimation.fromValue = self.borderView.layer.borderWidth
                borderAnimation.toValue = self.borderWidthForBusyView
                borderAnimation.duration = self.transitionAnimationDuration
                borderAnimation.fillMode = kCAFillModeForwards
                borderAnimation.isRemovedOnCompletion = false
                self.borderView.layer.add(borderAnimation, forKey: "borderWidth")

                CATransaction.commit()
            } else {
                self.borderView.layer.removeAllAnimations()
                self.borderView.layer.cornerRadius = self.cornerRadiusForBusyView
                self.borderView.layer.borderColor = self.borderColorForActiveState.cgColor
                self.borderView.layer.borderWidth = self.borderWidthForProgressView
            }
        }

        let animBlock3: () -> Void = {
            self.expandedSize = CGSize(width: self.widthForBusyView, height: self.widthForBusyView)
            self.superview?.layoutIfNeeded()

            // If animation is disabled, animation of the circle should start after `layoutIfNeeded()` method call
            if !animate {
                setupBusyViewWithAnimation()
            }
        }

        if animate {
            UIView.animateKeyframes(withDuration: transitionAnimationDuration, delay: 0, options: [.beginFromCurrentState], animations: {
                animBlock1()
                }, completion: { _ in
                    animBlock2()
                    UIView.animateKeyframes(withDuration: self.transitionAnimationDuration, delay: 0, options: [.beginFromCurrentState], animations: {
                        animBlock3()
                        }, completion: nil)
            })
        } else {
            animBlock1()
            animBlock2()
            animBlock3()
        }
    }

    private func transitionFromBusyToRegular(_ animate: Bool, intermediateState: IntermediateState) {
        progressView?.removeFromSuperview()

        var borderColor: UIColor!
        var attributedTextForCurrentState: NSAttributedString?

        switch intermediateState {
        case .inactive:
            borderColor = borderColorForInactiveState
            backgroundImageView?.image = imageForInactiveState
            colouredBackgroundView?.backgroundColor = backgroundColorForInactiveState
            attributedTextForCurrentState = attributedTextForInactiveState
        case .active:
            borderColor = borderColorForActiveState
            backgroundImageView?.image = imageForActiveState
            colouredBackgroundView?.backgroundColor = backgroundColorForActiveState
            attributedTextForCurrentState = attributedTextForActiveState
        }

        let animBlock1: () -> Void = {
            if animate {
                self.busyView?.removeFromSuperview()
                self.borderView?.alpha = 1

                CATransaction.begin()

                let cornerAnimation = CABasicAnimation(keyPath: "cornerRadius")
                cornerAnimation.fromValue = self.cornerRadiusForBusyView
                cornerAnimation.toValue = self.cornerRadiusForExpandedBorder
                cornerAnimation.duration = self.transitionAnimationDuration
                cornerAnimation.fillMode = kCAFillModeForwards
                cornerAnimation.isRemovedOnCompletion = false
                self.borderView?.layer.add(cornerAnimation, forKey: "cornerRadius")

                let colorAnimation = CABasicAnimation(keyPath: "borderColor")
                colorAnimation.fromValue = self.borderView?.layer.borderColor
                colorAnimation.toValue = borderColor.cgColor
                colorAnimation.duration = self.transitionAnimationDuration
                colorAnimation.fillMode = kCAFillModeForwards
                colorAnimation.isRemovedOnCompletion = false
                self.borderView?.layer.add(colorAnimation, forKey: "borderColor")

                let borderAnimation = CABasicAnimation(keyPath: "borderWidth")
                borderAnimation.fromValue = self.borderView?.layer.borderWidth
                borderAnimation.toValue = self.borderWidthForBusyView
                borderAnimation.duration = self.transitionAnimationDuration
                borderAnimation.fillMode = kCAFillModeForwards
                borderAnimation.isRemovedOnCompletion = false
                self.borderView?.layer.add(borderAnimation, forKey: "borderWidth")

                CATransaction.commit()
            } else {
                self.busyView?.removeFromSuperview()
                self.borderView?.layer.removeAllAnimations()
                self.borderView?.alpha = self.shouldAlwaysDisplayBorder ? 1 : 0
                self.borderView?.layer.cornerRadius = self.cornerRadiusForExpandedBorder
                self.borderView?.layer.borderColor = borderColor.cgColor
                self.borderView?.layer.borderWidth = self.borderWidthForBusyView
            }
        }

        let animBlock2: () -> Void = {
            if let attributedTextForCurrentState = attributedTextForCurrentState {
                self.expandedSize = self.calculatePrefferedSize(attributedTextForCurrentState)
            } else {
                self.expandedSize = self.minExpandedSize
            }

            self.superview?.layoutIfNeeded()
        }

        let animBlock3: () -> Void = {
            self.setAttributedTitle(attributedTextForCurrentState, for: UIControlState())
            self.backgroundImageView?.alpha = 1
            self.colouredBackgroundView?.alpha = 1
        }

        let animBlock4: () -> Void = {
            self.borderView?.alpha = self.shouldAlwaysDisplayBorder ? 1 : 0
        }

        if animate {
            animBlock1()
            UIView.animateKeyframes(withDuration: self.transitionAnimationDuration, delay: 0, options: [.beginFromCurrentState], animations: {
                animBlock2()
                }, completion: { (finished) in
                    UIView.animateKeyframes(withDuration: self.transitionAnimationDuration, delay: 0, options: [.beginFromCurrentState], animations: {
                        animBlock3()
                        }, completion: { _ in
                            UIView.animateKeyframes(withDuration: self.transitionAnimationDuration, delay: 0, options: [.beginFromCurrentState], animations: {
                                animBlock4()
                                }, completion: nil)
                    })
            })
        } else {
            animBlock1()
            animBlock2()
            animBlock3()
            animBlock4()
        }
    }

    private func transitionFromBusyToDownloading(_ progress: CGFloat) {
        busyView?.removeFromSuperview()
        setupBorderView(cornerRadius: cornerRadiusForBusyView, borderColor: borderColorForActiveState)
        setupProgressView()
        progressView.progress = progress
    }
}
