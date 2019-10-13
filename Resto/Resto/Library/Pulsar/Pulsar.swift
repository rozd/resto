//
//  Pulsar.swift
//  UITableViewSectionOnVeryBottom
//
//  Created by Max Rozdobudko on 10/12/19.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import UIKit

public class Pulsar: CAReplicatorLayer {

    struct Constants {
        static let animationKey = "pulsarAnimation"
    }

    // MARK: Pulse

    fileprivate lazy var pulse: CALayer = {
        let layer = CALayer()
        layer.opacity = 0
        layer.contentsScale = UIScreen.main.scale
        updatePulse(pulse: layer)
        return layer
    }()

    fileprivate weak var storedSuperlayer: CALayer?
    fileprivate var storedLayerIndex: Int?

    fileprivate var superlayerIsHiddenObservation: NSKeyValueObservation?

    // MARK: Animation Group

    fileprivate var animationGroup: CAAnimationGroup!

    // MARK: Customizatons

    var numberOfPulses: Int = 1 {
        didSet {
            updateInstanceCount()
            updateInstanceDelay()
        }
    }

    var animationDuration: TimeInterval = 2.0 {
        didSet {
            updateInstanceDelay()
        }
    }

    var radiusOfPulse: CGFloat = 20.0 {
        didSet {
            updatePulse(pulse: pulse)
        }
    }

    var radiusOfPulseAnimationStartKey: Float = .zero {
        didSet {
            if radiusOfPulseAnimationStartKey < 0.0 || radiusOfPulseAnimationStartKey >= 1.0{
                radiusOfPulseAnimationStartKey = 0.0
            }
        }
    }

    override public var backgroundColor: CGColor? {
        didSet {
            updatePulse(pulse: pulse)
        }
    }

    // MARK: Overridden properties

    override open var bounds: CGRect {
        didSet {
            pulse.frame.origin = CGPoint(x: bounds.midX - radiusOfPulse, y: bounds.midY - radiusOfPulse)
        }
    }

    // MARK: Lifecycle

    override public init() {
        super.init()
        updateInstanceCount()
        updateInstanceDelay()
        subscribeToApplicationNotifications()
    }

    override public init(layer: Any) {
        super.init(layer: layer)
        updateInstanceCount()
        updateInstanceDelay()
        subscribeToApplicationNotifications()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        unsubscribeNotifications()
    }

}

// MARK: Pulse

extension Pulsar {

    fileprivate func updatePulse(pulse: CALayer) {
        let diameter = radiusOfPulse * 2
        pulse.bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: diameter, height: diameter))
        pulse.cornerRadius = radiusOfPulse
        pulse.backgroundColor = backgroundColor
    }

}

// MARK: - CAReplicatorLayer

extension Pulsar {

    fileprivate func updateInstanceCount() {
        instanceCount = numberOfPulses
    }

    fileprivate func updateInstanceDelay() {
        guard numberOfPulses > 0 else {
            fatalError()
        }
        instanceDelay = animationDuration / Double(numberOfPulses)
    }

}

// MARK: Start

extension Pulsar {

    func start() {
        addSublayer(pulse)
        createAimationGroupIfNeeded()
        superlayerIsHiddenObservation = superlayer?.observe(\.isHidden, options: [.new], changeHandler: { [weak self] layer, change in
            guard let newValue = change.newValue, newValue == false else {
                return
            }

            self?.start()
        })
    }

    func stop() {
        removeAnimationGroupIfExists()
        pulse.removeFromSuperlayer()
    }

    var isAnimationSuspended: Bool {
        return storedSuperlayer != nil || storedLayerIndex != nil
    }

    func suspendAnimation() {
        storedSuperlayer = superlayer
        storedLayerIndex = superlayer?.sublayers?.firstIndex(of: self)
    }

    func restoreAnimation() {
        if let superlayer = storedSuperlayer, let index = storedLayerIndex {
            superlayer.insertSublayer(self, at: UInt32(index))
        }

        storedSuperlayer = nil
        storedLayerIndex = nil

        if pulse.superlayer == nil {
            addSublayer(pulse)
        }

        if animationGroup != nil && pulse.animation(forKey: Constants.animationKey) == nil {
            pulse.add(animationGroup, forKey: Constants.animationKey)
        }
    }

}

// MARK: Animation

extension Pulsar {

    fileprivate func createAimationGroupIfNeeded() {
        guard animationGroup == nil else {
            return
        }

        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = animationDuration
        scaleAnimation.fromValue = radiusOfPulseAnimationStartKey
        scaleAnimation.toValue = 1.0

        let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        opacityAnimation.duration = animationDuration
        opacityAnimation.fromValue = 1.0
        opacityAnimation.toValue = 0.0

        animationGroup = CAAnimationGroup()
        animationGroup.animations = [scaleAnimation, opacityAnimation]
        animationGroup.repeatCount = .greatestFiniteMagnitude
        animationGroup.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animationGroup.duration = animationDuration
        animationGroup.delegate = self

        pulse.add(animationGroup, forKey: Constants.animationKey)
    }

    fileprivate func removeAnimationGroupIfExists() {
        guard animationGroup != nil else {
            return
        }

        pulse.removeAllAnimations()
        animationGroup = nil
    }

    fileprivate func detachAnimationGroupIfNeeded() {
        if let keys = pulse.animationKeys(), keys.count > 0 {
            pulse.removeAllAnimations()
        }
        pulse.removeFromSuperlayer()
    }

    fileprivate func recreateAnimationGroupIfExists() {
        guard animationGroup != nil else {
            return
        }
        stop()
        DispatchQueue.main.async {
            self.start()
        }
    }
}

// MARK: - CAAnimationDelegate

extension Pulsar: CAAnimationDelegate {

    public func animationDidStart(_ anim: CAAnimation) {

    }

    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if isAnimationSuspended {
            detachAnimationGroupIfNeeded()
        } else {
            stop()
        }
    }

}

// MARK: - Application Background State

extension Pulsar {

    fileprivate func subscribeToApplicationNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleApplicationDidEnterBackground),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handlApplicationWillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }

    fileprivate func unsubscribeNotifications() {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func handleApplicationDidEnterBackground() {
        suspendAnimation()
    }

    @objc func handlApplicationWillEnterForeground() {
        restoreAnimation()
    }
}
