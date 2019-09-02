//
//  PlatterViewController.swift
//  tipTester
//
//  Created by Marlon Raskin on 9/1/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit
import CoreMotion

class PlatterViewController: UIViewController {

	enum PlatterPosition {
		case right
		case left
	}

	@IBOutlet weak var blurEffectView: UIVisualEffectView!
	@IBOutlet weak var platterView: UIView!
	@IBOutlet weak var dismissButton: UIButton!
	@IBOutlet weak var textFieldContainer: UIView!
	@IBOutlet weak var trailingAnchor: NSLayoutConstraint!
	@IBOutlet weak var leadingAnchor: NSLayoutConstraint!

	let motionManager = CMMotionManager()
	lazy var motionChecker: Timer = {
		let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
			guard let self = self else {
				timer.invalidate()
				return
			}
			self.updateAccelerometerData()
		}
		return timer
	}()


	var isDarkStatusBar = false {
		didSet {
			UIView.animate(withDuration: 0.3) {
				self.navigationController?.setNeedsStatusBarAppearanceUpdate()
			}
		}
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return isDarkStatusBar ? .default : .lightContent
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		motionManager.startAccelerometerUpdates()
		_ = motionChecker
		platterView.layer.cornerRadius = 12
		let blurEffect = UIBlurEffect(style: .systemThickMaterialDark)
		blurEffectView.effect = UIVibrancyEffect(blurEffect: blurEffect, style: .secondaryFill)
		platterView.backgroundColor = .darkJungleGreen
		textFieldContainer.layer.cornerRadius = textFieldContainer.frame.height / 2
    }

	deinit {
		print("Dick Farts")
	}
	

	@IBAction func stepperTapped(_ sender: UIStepper) {

	}

	@IBAction func switchSides(_ sender: UIButton) {
		UIView.animate(withDuration: 0.5) {
			self.trailingAnchor.isActive.toggle()
			self.leadingAnchor.isActive = !self.trailingAnchor.isActive
			self.view.layoutIfNeeded()
		}
	}

	func animateIn() {
		view.alpha = 0
		view.transform = CGAffineTransform(scaleX: 2, y: 2)
		UIView.animate(withDuration: 0.9, delay: 0.0, usingSpringWithDamping: 5.0, initialSpringVelocity: 2.0, options: [.curveEaseInOut], animations: {
			self.view.transform = .identity
			self.view.alpha = 1
		}, completion: nil)
	}

	func animateOut(completion: @escaping (Bool) -> Void) {
		UIView.animate(withDuration: 0.9, delay: 0.0, usingSpringWithDamping: 5.0, initialSpringVelocity: 2.0, options: [.curveEaseInOut], animations: {
			self.view.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
			self.view.alpha = 0
		}, completion: completion)
	}

	func movePlatter(to destination: PlatterPosition) {
		guard (destination == .right && !trailingAnchor.isActive) ||
		(destination == .left && trailingAnchor.isActive) else {
			return
		}
		switch destination {
		case .right:
			leadingAnchor.isActive = false
			trailingAnchor.isActive = true
		case .left:
			trailingAnchor.isActive = false
			leadingAnchor.isActive = true
		}
		UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 5.0, initialSpringVelocity: 2.0, options: [.curveEaseInOut], animations: {
			self.view.layoutIfNeeded()
		}, completion: nil)
	}

	@IBAction func tapToDismiss(_ sender: UITapGestureRecognizer) {
		dismissView()
	}

	@IBAction func dismissTapped(_ sender: UIButton) {
//		dismissView()
	}

	func updateAccelerometerData() {
		if let accelerometerData = motionManager.accelerometerData {
			let threshold = 0.4
			if accelerometerData.acceleration.x < -threshold {
				movePlatter(to: .left)
			} else if accelerometerData.acceleration.x > threshold {
				movePlatter(to: .right)
			}
		}
	}

	func dismissView(animated: Bool = true) {
		if animated {
			animateOut { _ in
				self.view.removeFromSuperview()
				self.removeFromParent()
			}
		} else {
			view.removeFromSuperview()
			removeFromParent()
		}
	}


	private func setUI() {

	}
}
