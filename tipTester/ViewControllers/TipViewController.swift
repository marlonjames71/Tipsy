//
//  ViewController.swift
//  tipTester
//
//  Created by Marlon Raskin on 6/2/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class TipViewController: UIViewController, UITextFieldDelegate {

	// MARK: - Properties

	var logic: CalculatorLogic?
	var previousTip: String?
	let clearValue = "$0.00"
    let defaults = UserDefaults.standard
    

	// MARK: - Outlets (In order on screen)

	@IBOutlet weak var tipsyTitleLabel: UILabel!
	@IBOutlet weak var settingsButton: UIButton!
	@IBOutlet weak var totalInputView: UIView!
	@IBOutlet weak var totalBillTextField: UITextField!
	@IBOutlet weak var dollarSymbol: UILabel!
	@IBOutlet weak var billAmountLabel: UILabel!
	@IBOutlet weak var totalBillErrorLabel: UILabel!
	@IBOutlet weak var tipInputView: UIView!
	@IBOutlet weak var tipTextField: UITextField!
	@IBOutlet weak var percentSymbol: UILabel!
	@IBOutlet weak var tipErrorLabel: UILabel!
	@IBOutlet weak var tipPercentLabel: UILabel!
	@IBOutlet weak var quickTipLabel: UILabel!
	@IBOutlet weak var firstEmoji: UIButton!
	@IBOutlet weak var twoPercentLabel: UILabel!
	@IBOutlet weak var secondEmoji: UIButton!
	@IBOutlet weak var fifteenPercentLabel: UILabel!
	@IBOutlet weak var thirdEmoji: UIButton!
	@IBOutlet weak var twentyPercentLabel: UILabel!
	@IBOutlet weak var fourthEmoji: UIButton!
	@IBOutlet weak var twentyFivePercentLabel: UILabel!
	@IBOutlet weak var emojiStackView: UIStackView!
	@IBOutlet weak var tipOutputLabel: UILabel!
	@IBOutlet weak var totalOutputLabel: UILabel!
	@IBOutlet weak var totalWithTipLabel: UILabel!
	@IBOutlet weak var tipAmountLabel: UILabel!
	@IBOutlet weak var calcButton: UIButton!
	@IBOutlet weak var resetButton: UIButton!
	@IBOutlet weak var splitButton: UIButton!
	@IBOutlet weak var activateKeyboardButton: UIButton!
	@IBOutlet weak var hideKeyboardButton: UIButton!
	@IBOutlet weak var leftSwipeGesture: UISwipeGestureRecognizer!
	@IBOutlet weak var rightSwipeGesture: UISwipeGestureRecognizer!
	@IBOutlet weak var downSwipeGesture: UISwipeGestureRecognizer!
	@IBOutlet weak var screenEdgeGestureRecognizer: UIScreenEdgePanGestureRecognizer!

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.navigationBar.isHidden = true
		logic = CalculatorLogic()
		totalBillTextField.delegate = self
		tipTextField.delegate = self
		totalBillTextField.becomeFirstResponder()
		updateResetButtonEnabled()
		screenEdgeGestureRecognizer.edges = .right
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.isNavigationBarHidden = true
		setUI()
		if UIScreen.main.bounds.height < 667 {
			view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
		} else if UIScreen.main.bounds.height == 667 {
			view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
		}
		hideKeyboardButton.alpha = 0
		tipTextField.text = "20"
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		setUI()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.isNavigationBarHidden = false
	}


	// MARK: - IBActions

	@IBAction func tipCalcButtonTapped(_ sender: Any) {
		let generator = UIImpactFeedbackGenerator(style: .light)
		generator.prepare()
		generator.impactOccurred()
		resetButton.isEnabled = true
		calculateTip()
		totalBillTextField.resignFirstResponder()
		tipTextField.resignFirstResponder()
		showHideKeyboard(show: false)
	}


	@IBAction func resetButtonTapped(_ sender: UIButton) {
		clear()
		let generator = UISelectionFeedbackGenerator()
		generator.selectionChanged()
		tipTextField.text = "20"
	}

	@IBAction func firstEmojiTapped(_ sender: UIButton) {
		tipTextField.text = "2"
		emojiCalculate()
	}

	@IBAction func secondEmojiTapped(_ sender: UIButton) {
		tipTextField.text = "15"
		emojiCalculate()
	}

	@IBAction func thirdEmojiTapped(_ sender: UIButton) {
		tipTextField.text = "20"
		emojiCalculate()
	}

	@IBAction func fourthEmojiTapped(_ sender: UIButton) {
		tipTextField.text = "25"
		emojiCalculate()
	}

	@IBAction func totalDidChange(_ sender: CustomTextField) {
		guard var totalString = sender.text else { return }
		let legalChar = Set("0123456789")
		totalString = totalString.filter { legalChar.contains($0) }

		guard let totalInt = Int(totalString) else { return }
		sender.text = String.formattedPrice(with: totalInt)
		totalBillErrorLabel.isHidden = true
		calculateTip()
		updateResetButtonEnabled()
	}

	@IBAction func tipFieldDidChange(_ sender: CustomTextField) {
		tipErrorLabel.isHidden = true
		tipValueChanged()
	}

	@IBAction func splitButtonTapped(_ sender: UIButton) {
		showSplitPlatter()
	}

	@IBAction func activateKeyboard(_ sender: UIButton) {
		totalBillTextField.becomeFirstResponder()
		showHideKeyboard(show: true)
	}

	@IBAction func hideKeyboard(_ sender: UIButton) {
		showHideKeyboard(show: false)
		totalBillTextField.resignFirstResponder()
		tipTextField.resignFirstResponder()
	}

	@IBAction func leftSwipe(_ sender: UISwipeGestureRecognizer) {
		if tipTextField.isFirstResponder {
			totalBillTextField.becomeFirstResponder()
		}
	}
	@IBAction func rightSwipe(_ sender: UISwipeGestureRecognizer) {
		if totalBillTextField.isFirstResponder {
			tipTextField.becomeFirstResponder()
		}
	}
	@IBAction func downSwipe(_ sender: UISwipeGestureRecognizer) {
		tipTextField.resignFirstResponder()
		totalBillTextField.resignFirstResponder()
		showHideKeyboard(show: false)
	}

	@IBAction func screenEdgeGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
		if screenEdgeGestureRecognizer.state == .ended {
			print("I'm printing stuff")
			performSegue(withIdentifier: "ShowSettingsSegue", sender: nil)
		}
	}

	// MARK: - Navigation

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//		guard let settingsVC = segue.destination as? SettingsViewController else { return }
	}


	// MARK: - Helper Methods

	private func calculateTip() {
		guard let totalStrInput = totalBillTextField.text, !totalStrInput.isEmpty else {
			totalBillErrorLabel.isHidden = false
			return
		}
		guard let tipPercentStrInput = tipTextField.text, !tipPercentStrInput.isEmpty else {
			tipErrorLabel.isHidden = false
			return
		}
		if (Int(tipPercentStrInput) ?? 0) >= 40 {
			let alert = UIAlertController(title: "Wow! You are one generous person!!", message: "🔥💫🙌", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Heck yeah, I'm awesome!", style: .default, handler: nil))
			present(alert, animated: true, completion: nil)
		}
		guard let logic = logic else { return }
        let rounding = defaults.bool(forKey: .roundingKey)

        let valueInfo = logic.totalPerPerson(billTotalString: totalStrInput, tipPercentageString: tipPercentStrInput, isRounded: rounding)
        tipOutputLabel.text = valueInfo.tipAmount
        totalOutputLabel.text = valueInfo.wholeBillTotal
        tipTextField.text = valueInfo.actualTipPercentage
        
//		guard let (tipOutput, totalOutput) = logic.calculateTipTotal(subTotalStr: totalStrInput, tipPercentStr: tipPercentStrInput) else { return }
//		tipOutputLabel.text = tipOutput
//		totalOutputLabel.text = totalOutput
	}

	private func showSplitPlatter() {
		guard let platterViewController = storyboard?.instantiateViewController(withIdentifier: "PlatterViewController") as? PlatterViewController,
			let total = totalOutputLabel.text,
			let originalTotal = totalBillTextField.text else { return }
		platterViewController.totalAmount = total
		platterViewController.originalTotal = originalTotal
		platterViewController.logic = logic
		platterViewController.delegate = self
		addChild(platterViewController)
		view.addSubview(platterViewController.view)
		platterViewController.animateIn()
		[leftSwipeGesture, rightSwipeGesture, downSwipeGesture].forEach { $0?.isEnabled = false }
	}

	private func tipValueChanged() {
		tipErrorLabel.isHidden = true
		updateResetButtonEnabled()
		resetTaptic()
	}

	private func resetTaptic() {
		let generator = UISelectionFeedbackGenerator()
		generator.selectionChanged()
	}

	private func showHideKeyboard(show: Bool) {
		if show {
			UIView.animate(withDuration: 0.4) {
				self.hideKeyboardButton.alpha = 1
			}
			UIView.animate(withDuration: 0.6) {
				self.activateKeyboardButton.alpha = 0
			}
		} else {
			UIView.animate(withDuration: 0.3) {
				self.hideKeyboardButton.alpha = 0
			}
			UIView.animate(withDuration: 0.8) {
				self.activateKeyboardButton.alpha = 1
			}
		}
	}

	private func updateResetButtonEnabled() {
		if totalBillTextField.text?.isEmpty == true && tipTextField.text?.isEmpty == true {
			resetButton.isEnabled = false
		} else  if totalBillTextField.text?.isEmpty == true && tipTextField.text?.isEmpty == false {
			resetButton.isEnabled = true
		} else {
			resetButton.isEnabled = true
		}
	}

	private func emojiCalculate() {
		tipCalcButtonTapped(self)
		if tipErrorLabel.isHidden == false {
			tipErrorLabel.isHidden = true
		}
	}
	
	func clear() {
		totalBillTextField.text = nil
		tipTextField.text = nil
		totalOutputLabel.text = nil
		tipOutputLabel.text = clearValue
		totalOutputLabel.text = clearValue
		tipErrorLabel.isHidden = true
		totalBillErrorLabel.isHidden = true
		updateResetButtonEnabled()
	}

	func textFieldDidBeginEditing(_ textField: UITextField) {
		showHideKeyboard(show: true)
	}


	// MARK: - Theme Function

	func setUI() {
		let traitCollection = UITraitCollection()
		calcButton.layer.cornerRadius = calcButton.frame.height / 2
		calcButton.setTitleColor(.mako2, for: .normal)
		splitButton.layer.cornerRadius = splitButton.frame.height / 2
        splitButton.layer.cornerCurve = .continuous
		[totalBillErrorLabel, tipErrorLabel].forEach( { $0?.isHidden = true} )
		totalInputView.layer.cornerRadius = totalInputView.frame.height / 2
		tipInputView.layer.cornerRadius = tipInputView.frame.height / 2

		if traitCollection.userInterfaceStyle == .light {
			// Light
			totalBillTextField.attributedPlaceholder = NSAttributedString(string: "0.00", attributes: [NSAttributedString.Key.foregroundColor: UIColor.mako])
			tipTextField.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor: UIColor.mako])
			[totalInputView, tipInputView].forEach( { $0?.layer.cornerRadius = 25 } )
            [totalInputView, tipInputView].forEach( { $0?.layer.cornerCurve = .continuous } )
			splitButton.layer.shadowColor = UIColor.lightGray.cgColor
			splitButton.layer.shadowOpacity = 0.2
			splitButton.layer.shadowRadius = 16
		} else {
			// Dark
			totalBillTextField.attributedPlaceholder = NSAttributedString(string: "0.00", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
			tipTextField.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
			splitButton.layer.shadowColor = nil
			splitButton.layer.shadowOpacity = 0
			splitButton.layer.shadowRadius = 0
		}
	}
}

extension TipViewController: PlatterViewControllerDelegate {
	func didFinishShowing() {
		[leftSwipeGesture, rightSwipeGesture, downSwipeGesture].forEach { $0?.isEnabled = true }
	}
}
