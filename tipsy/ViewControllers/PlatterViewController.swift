//
//  PlatterViewController.swift
//  tipTester
//
//  Created by Marlon Raskin on 9/1/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit
import CoreMotion
import MessageUI
import Contacts
import ContactsUI

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
	@IBOutlet weak var xSymbol: UIImageView!
	@IBOutlet weak var tapToDismissLabel: UILabel!
	
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

	private var messagePrompt: String {
		guard let amount = self.eachLabel.text else { return "" }
		if DefaultsManager.includeApplePayHint {
			return "Your portion of the bill is → \(amount)\n\nHint: If you have Apple Pay enabled, tap the above dollar amount!"
		} else {
			return "Your portion of the bill is → \(amount)"
		}
	}

	weak var delegate: PlatterViewControllerDelegate?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		motionManager.startAccelerometerUpdates()
		_ = motionChecker
		setStandardUI()
		stepper.minimumValue = 1
		stepper.maximumValue = 999
		calculateSplit()
		HapticFeedback.lightFeedback.prepare()
		[totalLabel, tipLabel].forEach { $0?.font = .roundedFont(ofSize: 23, weight: .bold) }
		eachLabel.font = .roundedFont(ofSize: 30, weight: .bold)
		[eachLabel, totalLabel, tipLabel].forEach { $0?.minimumScaleFactor = 0.50 }
		dismissButton.titleLabel?.font = .roundedFont(ofSize: 16, weight: .medium)

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
		HapticFeedback.produceLightFeedback()
		partyCount = Int(sender.value)
		calculateSplit()
	}

	private func calculateSplit() {
		guard let logic = logic else { return }
		let rounding = DefaultsManager.roundingIsEnabled

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
			HapticFeedback.produceLightFeedback()
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

	private func presentMessageController() {
		let contactsStore = CNContactStore()
		contactsStore.requestAccess(for: .contacts) { (granted, error) in
			if let error = error {
				NSLog("Failed to request access: \(error)")
			}

			if granted {
				if !MFMessageComposeViewController.canSendText() {
					let messageAlert = UIAlertController(title: "Message Services are not available", message: "Your messaging services appears to not be available", preferredStyle: .alert)
					messageAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
					self.present(messageAlert, animated: true, completion: nil)
				} else {
					let composeVC = MFMessageComposeViewController()
					composeVC.messageComposeDelegate = self
					composeVC.body = self.messagePrompt
					self.present(composeVC, animated: true, completion: nil)
				}
			} else {
				NSLog("Access to contacts was denied")
			}
		}
	}

	@IBAction func requestMoneyTapped(_ sender: UIButton) {
		if eachLabel.text == "$0.00" {
			let alert = UIAlertController(title: "The dollar amount must be greater than $0.00", message: nil, preferredStyle: .alert)
			let action = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(action)
			present(alert, animated: true, completion: nil)
		} else {
			if !DefaultsManager.messageAlertWasSeen {
				let message = """
						Due to Apple's limitations with messaging, peer to peer Apple Pay functionality will not work in group messages.

						Sending the following messages one by one allows your party members to reimburse you via Apple Cash.

						Thank you for your patience as I continue to find a way to improve this feature.
						"""
				let messageAlert = UIAlertController(title: "About This Feature", message: message, preferredStyle: .alert)
				let okAction = UIAlertAction(title: "OK", style: .default) { _ in
					self.presentMessageController()
				}
				let remindMeAction = UIAlertAction(title: "Please Remind Me Again", style: .cancel) { _ in
					DefaultsManager.messageAlertWasSeen = false
					self.presentMessageController()
				}
				[okAction, remindMeAction].forEach { messageAlert.addAction($0) }
				present(messageAlert, animated: true) {
					DefaultsManager.messageAlertWasSeen = true
				}
			} else {
				DispatchQueue.main.async { [weak self] in
					self?.presentMessageController()
				}
			}
		}
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



		if UIScreen.main.bounds.height < platterView.frame.height + 205 {
			xSymbol.isHidden = true
			tapToDismissLabel.isHidden = false
			platterView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
			trailingAnchor.constant = 20
			leadingAnchor.constant = 20
		} else {
			xSymbol.isHidden = false
			tapToDismissLabel.isHidden = true
		}
	}
}

extension PlatterViewController: MFMessageComposeViewControllerDelegate {
	func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
		switch result {
		case .sent:
			controller.dismiss(animated: true, completion: nil)
		case .cancelled:
			controller.dismiss(animated: true, completion: nil)
		case .failed:
			let errorAlert = UIAlertController(title: "Uh Oh, Message failed to send", message: nil, preferredStyle: .alert)
			errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			controller.dismiss(animated: true) {
				self.present(errorAlert, animated: true, completion: nil)
			}
		@unknown default:
			fatalError()

		}
	}
}
