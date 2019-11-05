//
//  PlatterViewController.swift
//  tipTester
//
//  Created by Marlon Raskin on 9/1/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit
import CoreMotion

protocol PlatterViewControllerDelegate: AnyObject {
	func didFinishShowing()
}

class PlatterViewController: UIViewController {

	enum PlatterPosition {
		case right
		case left
	}

	@IBOutlet weak var eachLabel: UILabel!
	@IBOutlet weak var eachDescLabel: UILabel!
	@IBOutlet weak var totalLabel: UILabel!
	@IBOutlet weak var totalDescLabel: UILabel!
	@IBOutlet weak var blurEffectView: UIVisualEffectView!
	@IBOutlet weak var platterView: UIView!
	@IBOutlet weak var dismissButton: UIButton!
	@IBOutlet weak var partyCountLabelContainer: UIView!
	@IBOutlet weak var partyCountLabel: UILabel!
	@IBOutlet weak var trailingAnchor: NSLayoutConstraint!
	@IBOutlet weak var leadingAnchor: NSLayoutConstraint!
	@IBOutlet weak var stepper: UIStepper!
	@IBOutlet weak var tipLabel: UILabel!
	@IBOutlet weak var tipDescLabel: UILabel!

	let generator = UIImpactFeedbackGenerator(style: .medium)
	let motionManager = CMMotionManager()
    let defaults = UserDefaults.standard
    var tipPercentage: String?
	var logic: CalculatorLogic?
	var totalAmount: String?
	var originalTotal: String?
	var eachAmount: Double = 0.00
	var partyCount: Int = 2 {
		didSet {
			partyCountLabel.text = "\(partyCount)"
		}
	}

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

	weak var delegate: PlatterViewControllerDelegate?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		motionManager.startAccelerometerUpdates()
		_ = motionChecker
		setStandardUI()
		stepper.minimumValue = 1
		stepper.maximumValue = 10
		calculateSplit()
		generator.prepare()

		platterView.layer.shadowColor = UIColor.black.cgColor
		platterView.layer.shadowOpacity = 0.3
		platterView.layer.shadowOffset = .zero
		platterView.layer.shadowRadius = 10
		platterView.layer.shadowPath = UIBezierPath(rect: platterView.bounds).cgPath
		platterView.layer.shouldRasterize = true
		platterView.layer.rasterizationScale = UIScreen.main.scale
    }

	deinit {
		print("Deinit")
	}
	

	@IBAction func stepperTapped(_ sender: UIStepper) {
		generator.impactOccurred()
		partyCount = Int(sender.value)
		calculateSplit()
	}

	private func calculateSplit() {
		guard let logic = logic else { return }
		let rounding = defaults.bool(forKey: .roundingKey)

		if let totalValueString = originalTotal?.replacingOccurrences(of: "$", with: ""),
			let tipPercentage = tipPercentage,
			let amountInfo = logic.totalPerPerson(billTotalString: totalValueString, tipPercentageString: tipPercentage, numberOfPeople: partyCount, isRounded: rounding) {
			eachLabel.text = amountInfo.totalPerPerson
			totalLabel.text = amountInfo.wholeBillTotal
			tipLabel.text = amountInfo.tipAmount
		} else {
			eachLabel.text = "$0.00"
			totalLabel.text = "$0.00"
			tipLabel.text = "$0.00"
		}
	}

	private func getAmountFromEachLabel() -> Double {
		guard let stringValueFromEachLabel = eachLabel.text else { return 0.00 }
		let cleanStringFromEachValueLabel = stringValueFromEachLabel.replacingOccurrences(of: "$", with: "")
		let cleanEachValue = Double(cleanStringFromEachValueLabel)
		guard let eachValueUnwrapped = cleanEachValue else { return 0.00 }
		return eachValueUnwrapped
	}

	private func newTipAmount(newTotal: Double) -> Double {
		guard let originalTotalString = originalTotal else { return 0.00 }
		let originalTotalValue = Double(originalTotalString)
		guard let total = originalTotalValue else { return 0.00 }
		return newTotal - total
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
		view.transform = CGAffineTransform(scaleX: 4.0, y: 4.0)
		UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 2.0, initialSpringVelocity: 5.0, options: [.curveEaseInOut], animations: {
			self.view.transform = .identity
			self.view.alpha = 1
		}, completion: nil)
	}

	func animateOut(completion: @escaping (Bool) -> Void) {
		UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 2.0, initialSpringVelocity: 5.0, options: [.curveEaseInOut], animations: {
			self.view.transform = CGAffineTransform(scaleX: 5.0, y: 2.5)
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
		dismissView()
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
		delegate?.didFinishShowing()
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

	private func setStandardUI() {
		loadViewIfNeeded()
		if originalTotal == nil {
			totalLabel.text = "$0.00"
			tipLabel.text = "$0.00"
			eachLabel.text = "$0.00"
		}
		dismissButton.layer.cornerRadius = dismissButton.frame.height / 2
		partyCountLabel.text = "2"
		partyCountLabelContainer.layer.cornerRadius = partyCountLabelContainer.frame.height / 2
        partyCountLabelContainer.layer.cornerCurve = .continuous
		platterView.layer.cornerRadius = 12
        platterView.layer.cornerCurve = .continuous

		guard let total = totalAmount else { return }
		totalLabel.text = "\(total)"
		stepper.value = 2
	}
}
