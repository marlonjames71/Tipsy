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
	private var editingTipPercentage = false
	var calculatedTipPercentage: String = "20" {
		didSet {
			guard editingTipPercentage == false else { return }
			tipTextField.text = calculatedTipPercentage
			calculateTip()
		}
	}
	
	lazy var emojiButtons = [firstEmoji, secondEmoji, thirdEmoji, fourthEmoji].compactMap { $0 }
	lazy var percentLabels = [twoPercentLabel, fifteenPercentLabel, twentyPercentLabel, twentyFivePercentLabel].compactMap { $0 }
	
	// MARK: - Outlets (In order on screen)
	
	@IBOutlet weak var tipsyTitleLabel: UILabel!
	@IBOutlet weak var settingsButton: UIButton!
	@IBOutlet weak var totalInputView: UIStackView!
	@IBOutlet weak var totalBillTextField: UITextField!
	@IBOutlet weak var dollarSymbol: UILabel!
	@IBOutlet weak var billAmountLabel: UILabel!
	@IBOutlet weak var totalBillErrorLabel: UILabel!
	@IBOutlet weak var tipInputView: UIStackView!
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
	@IBOutlet weak var leftSwipeGesture: UISwipeGestureRecognizer!
	@IBOutlet weak var rightSwipeGesture: UISwipeGestureRecognizer!
	@IBOutlet weak var downSwipeGesture: UISwipeGestureRecognizer!
	@IBOutlet weak var screenEdgeGestureRecognizer: UIScreenEdgePanGestureRecognizer!
	@IBOutlet weak var mainStackView: UIStackView!
	@IBOutlet weak var subMainStackView: UIStackView!
	@IBOutlet weak var titleFieldsAndEmojisStackView: UIStackView!
	@IBOutlet weak var mainSTackViewLeadingConstraint: NSLayoutConstraint!
	@IBOutlet weak var mainStackViewTrailingConstraint: NSLayoutConstraint!
	
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
		HapticFeedback.lightFeedback.prepare()
		resetHighlightTipPercentLabels()
		
		
		let toolbar: UIToolbar = UIToolbar(frame: .zero)
		
		let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let hideKeyboardButton = UIBarButtonItem(image: UIImage(systemName: "keyboard.chevron.compact.down"), style: .done, target: self, action: #selector(hideKeyboardAction))
		hideKeyboardButton.tintColor = .darkTurquoise
		toolbar.setItems([flexSpace, hideKeyboardButton], animated: false)
		toolbar.sizeToFit()
		[totalBillTextField, tipTextField].forEach { $0?.inputAccessoryView = toolbar }
		
		if UIScreen.main.bounds.height <= 667 {
			subMainStackView.spacing = 16
			titleFieldsAndEmojisStackView.spacing = 12
			calcButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
			mainSTackViewLeadingConstraint.constant = 25
			mainStackViewTrailingConstraint.constant = 25
			calcButton.setTitle("Calculate", for: .normal)
			mainStackView.spacing = 20
			toolbar.barTintColor = .systemBackground
		} else {
			toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
			toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
			toolbar.backgroundColor = .clear
			subMainStackView.spacing = 50
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(true, animated: true)
		setUI()
		tipTextField.text = calculatedTipPercentage
		calculateTip()
		loadEmojis()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		setUI()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		//		navigationController?.isNavigationBarHidden = true
		navigationController?.setNavigationBarHidden(false, animated: true)
		totalBillTextField.resignFirstResponder()
		tipTextField.resignFirstResponder()
		showHideKeyboard(show: false)
	}
	
	@objc func hideKeyboardAction() {
		self.view.endEditing(true)
		showHideKeyboard(show: false)
	}
	
	
	// MARK: - IBActions
	
	@IBAction func tipCalcButtonTapped(_ sender: Any) {
		resetButton.isEnabled = true
		calculateTip()
		totalBillTextField.resignFirstResponder()
		tipTextField.resignFirstResponder()
		showHideKeyboard(show: false)
	}
	
	
	@IBAction func resetButtonTapped(_ sender: UIButton) {
		clear()
		calculatedTipPercentage = "20"
		resetHighlightTipPercentLabels()
	}
	
	@IBAction func firstEmojiTapped(_ sender: UIButton) {
		HapticFeedback.produceLightFeedback()
		calculatedTipPercentage = "2"
		highlightLabelForButton(button: sender)
	}
	
	@IBAction func secondEmojiTapped(_ sender: UIButton) {
		HapticFeedback.produceLightFeedback()
		calculatedTipPercentage = "15"
		highlightLabelForButton(button: sender)
	}
	
	@IBAction func thirdEmojiTapped(_ sender: UIButton) {
		HapticFeedback.produceLightFeedback()
		calculatedTipPercentage = "20"
		highlightLabelForButton(button: sender)
	}
	
	@IBAction func fourthEmojiTapped(_ sender: UIButton) {
		HapticFeedback.produceLightFeedback()
		calculatedTipPercentage = "25"
		highlightLabelForButton(button: sender)
	}
	
	@IBAction func totalDidChange(_ sender: UITextField) {
		guard var totalString = sender.text else { return }
		let legalChar = Set("0123456789")
		totalString = totalString.filter { legalChar.contains($0) }
		
		guard let totalInt = Int(totalString) else { return }
		sender.text = String.formattedPrice(with: totalInt)
		totalBillErrorLabel.isHidden = true
		calculateTip()
		updateResetButtonEnabled()
	}
	
	@IBAction func tipFieldDidChange(_ sender: UITextField) {
		percentLabels.forEach { $0.textColor = .tipsySecondaryLabelColor }
		tipErrorLabel.isHidden = true
		editingTipPercentage = true
		calculatedTipPercentage = sender.text ?? ""
		editingTipPercentage = false
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
		guard let logic = logic else { return }
		let rounding = DefaultsManager.roundingIsEnabled
		
		guard let valueInfo = logic.totalPerPerson(billTotalString: totalStrInput, tipPercentageString: calculatedTipPercentage, isRounded: rounding) else {
			tipOutputLabel.text = "$0.00"
			totalOutputLabel.text = "$0.00"
			tipTextField.text = "$0.00"
			return
		}
		
		tipOutputLabel.text = valueInfo.tipAmount
		totalOutputLabel.text = valueInfo.wholeBillTotal
		tipTextField.text = valueInfo.actualTipPercentage
		
		if (Int(tipPercentStrInput) ?? 0) >= 40 && (Double(valueInfo.tipAmount) ?? 0 > 10.00) {
			let alert = UIAlertController(title: "Wow! You are one generous person!!", message: "🔥💫🙌", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Heck yeah, I'm awesome!", style: .default, handler: nil))
			present(alert, animated: true, completion: nil)
		}
	}
	
	private func highlightLabelForButton(button: UIButton) {
		guard let buttonIndex = emojiButtons.firstIndex(of: button) else { return }
		let label = percentLabels[buttonIndex]
		highlightPercentLabel(label: label)
	}
	
	private func highlightPercentLabel(label: UILabel) {
		percentLabels.forEach { $0.textColor = .tipsySecondaryLabelColor }
		label.textColor = .tipsyDarkerAccents
	}
	
	private func resetHighlightTipPercentLabels() {
		for label in percentLabels {
			if label != twentyPercentLabel {
				label.textColor = .tipsySecondaryLabelColor
			} else {
				label.textColor = .tipsyDarkerAccents
			}
		}
	}
	
	private func showSplitPlatter() {
		guard let platterViewController = storyboard?.instantiateViewController(withIdentifier: "PlatterViewController") as? PlatterViewController,
				let total = totalOutputLabel.text,
				let originalTotal = totalBillTextField.text else { return }
		platterViewController.totalAmount = total
		platterViewController.originalTotal = originalTotal
		platterViewController.tipPercentage = calculatedTipPercentage
		platterViewController.logic = logic
		platterViewController.delegate = self
		addChild(platterViewController)
		view.addSubview(platterViewController.view)
		platterViewController.animateIn()
		[leftSwipeGesture, rightSwipeGesture, downSwipeGesture].forEach { $0?.isEnabled = false }
	}
	
	private func showHideKeyboard(show: Bool) {
		if show {
			UIView.animate(withDuration: 0.6) {
				self.activateKeyboardButton.alpha = 0
			}
		} else {
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
	
	private func loadEmojis() {
		firstEmoji.setTitle(DefaultsManager.emojiOne, for: .normal)
		secondEmoji.setTitle(DefaultsManager.emojiTwo, for: .normal)
		thirdEmoji.setTitle(DefaultsManager.emojiThree, for: .normal)
		fourthEmoji.setTitle(DefaultsManager.emojiFour, for: .normal)
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
		tipsyTitleLabel.font = .roundedFont(ofSize: 40, weight: .heavy)
		calcButton.titleLabel?.font = .roundedFont(ofSize: 25, weight: .bold)
		[tipOutputLabel, totalOutputLabel].forEach { $0?.font = .roundedFont(ofSize: 40, weight: .heavy) }
		[tipOutputLabel, totalOutputLabel].forEach { $0?.minimumScaleFactor = 0.50 }
		splitButton.titleLabel?.font = .roundedFont(ofSize: 18, weight: .regular)
		calcButton.layer.cornerRadius = calcButton.frame.height / 2
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

extension UIView {
	func allSubviews() -> Set<UIView> {
		var childSubviews = Set(subviews)
		for subview in subviews {
			childSubviews = childSubviews.union(subview.allSubviews())
		}
		return childSubviews
	}
}
