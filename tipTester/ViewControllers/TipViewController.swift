//
//  ViewController.swift
//  tipTester
//
//  Created by Marlon Raskin on 6/2/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class TipViewController: UIViewController, UITextFieldDelegate {

	var logic: CalculatorLogic?
	var previousTip: String?
//	var cardViewController: CardViewController!

	@IBOutlet weak var tipsyTitleLabel: UILabel!
	@IBOutlet var totalBillTextField: UITextField!
	@IBOutlet var totalBillErrorLabel: UILabel!
	@IBOutlet var tipTextField: UITextField!
	@IBOutlet var tipErrorLabel: UILabel!
	@IBOutlet var calcButton: UIButton!
	@IBOutlet var tipOutputLabel: UILabel!
	@IBOutlet var totalOutputLabel: UILabel!
	@IBOutlet weak var resetButton: UIButton!
	@IBOutlet var totalInputView: UIView!
	@IBOutlet weak var tipInputView: UIView!
	@IBOutlet weak var dollarSymbol: UILabel!
	@IBOutlet weak var percentSymbol: UILabel!
	@IBOutlet weak var billAmountLabel: UILabel!
	@IBOutlet weak var tipPercentLabel: UILabel!
	@IBOutlet weak var quickTipLabel: UILabel!
	@IBOutlet weak var tipAmountLabel: UILabel!
	@IBOutlet weak var totalWithTipLabel: UILabel!
	@IBOutlet weak var firstEmoji: UIButton!
	@IBOutlet weak var twoPercentLabel: UILabel!
	@IBOutlet weak var secondEmoji: UIButton!
	@IBOutlet weak var fifteenPercentLabel: UILabel!
	@IBOutlet weak var thirdEmoji: UIButton!
	@IBOutlet weak var twentyPercentLabel: UILabel!
	@IBOutlet weak var fourthEmoji: UIButton!
	@IBOutlet weak var twentyFivePercentLabel: UILabel!
	@IBOutlet weak var emojiStackView: UIStackView!
	@IBOutlet weak var settingsButton: UIButton!


	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.isNavigationBarHidden = true
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.navigationBar.isHidden = true
		logic = CalculatorLogic()
		totalBillTextField.delegate = self
		tipTextField.delegate = self
		setUpLightUI()
		updateResetButtonTextColor()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.isNavigationBarHidden = false
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


	
	@IBAction func tipCalcButtonTapped(_ sender: Any) {
		let generator = UIImpactFeedbackGenerator(style: .light)
		generator.prepare()
		generator.impactOccurred()
		guard let totalStrInput = totalBillTextField.text, !totalStrInput.isEmpty else {
			totalBillErrorLabel.isHidden = false
			return
		}
		guard let tipPercentStrInput = tipTextField.text, !tipPercentStrInput.isEmpty else {
			tipErrorLabel.isHidden = false
			return
		}
		
		guard let logic = logic else { return }
		guard let (tipOutput, totalOutput) = logic.calculateTipTotal(subTotalStr: totalStrInput, tipPercentStr: tipPercentStrInput) else { return }
		tipOutputLabel.text = tipOutput
		totalOutputLabel.text = totalOutput
	}
	
	
	@IBAction func resetButtonTapped(_ sender: UIButton) {
		clear()
		let generator = UISelectionFeedbackGenerator()
		generator.selectionChanged()
	}

	private func tipValueChanged() {
		tipErrorLabel.isHidden = true
		updateResetButtonTextColor()
		resetTaptic()
	}

	private func updateResetButtonTextColor() {
		if totalBillTextField.text?.isEmpty == true && tipTextField.text?.isEmpty == true {
			resetButton.isEnabled = false
		} else {
			resetButton.isEnabled = true
		}
	}

	private func resetTaptic() {
		let generator = UISelectionFeedbackGenerator()
		generator.selectionChanged()
	}

	
	@IBAction func totalDidChange(_ sender: CustomTextField) {
		guard var totalString = sender.text else { return }
		let legalChar = Set("0123456789")
		totalString = totalString.filter { legalChar.contains($0) }
		guard let totalInt = Int(totalString) else { return }
		sender.text = String.formattedPrice(with: totalInt)
		totalBillErrorLabel.isHidden = true
		updateResetButtonTextColor()
	}

	private func emojiCalculate() {
		tipCalcButtonTapped(self)
	}


	@IBAction func tipFieldDidChange(_ sender: CustomTextField) {
		tipErrorLabel.isHidden = true
	}
	
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
	
	func clear() {
		totalBillTextField.text = nil
		tipTextField.text = nil
		totalOutputLabel.text = nil
		tipOutputLabel.text = nil
		totalOutputLabel.text = nil
		tipOutputLabel.text = nil
		tipErrorLabel.isHidden = true
		totalBillErrorLabel.isHidden = true
		updateResetButtonTextColor()
	}


	private func setUpLightUI() {
		view.backgroundColor = .wildSand
		tipsyTitleLabel.textColor = .black
		dollarSymbol.textColor = .turquoiseTwo
		percentSymbol.textColor = .turquoiseTwo
		totalBillErrorLabel.isHidden = true
		totalBillErrorLabel.textColor = .razzmatazz
		tipErrorLabel.isHidden = true
		tipErrorLabel.textColor = .razzmatazz
		calcButton.setTitleColor(.mako, for: .normal)
		calcButton.backgroundColor = .turquoise
		calcButton.layer.cornerRadius = 30
		resetButton.setTitleColor(.razzmatazz, for: .normal)
		resetButton.setTitleColor(.mako, for: .disabled)
		totalInputView.backgroundColor = .clear
		tipInputView.backgroundColor = .clear
		totalInputView.backgroundColor = .white
		totalInputView.layer.cornerRadius = 25
		tipInputView.backgroundColor = .white
		tipInputView.layer.cornerRadius = 25
		billAmountLabel.textColor = .mako
		tipPercentLabel.textColor = .mako
		quickTipLabel.textColor = .mako
		tipAmountLabel.textColor = .mako
		totalWithTipLabel.textColor = .mako
		twoPercentLabel.textColor = .mako
		fifteenPercentLabel.textColor = .mako
		twentyPercentLabel.textColor = .mako
		twentyFivePercentLabel.textColor = .mako
		totalBillTextField.keyboardAppearance = .light
		tipTextField.keyboardAppearance = .light
		totalBillTextField.attributedPlaceholder = NSAttributedString(string: "0.00", attributes: [NSAttributedString.Key.foregroundColor: UIColor.mako])
		tipTextField.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor: UIColor.mako])
		settingsButton.setTitleColor(.turquoiseTwo, for: .normal)
	}

	private func setupDarkUI() {
		view.backgroundColor = .black
		tipsyTitleLabel.textColor = .white
		dollarSymbol.textColor = .turquoise
		percentSymbol.textColor = .turquoise
		totalBillErrorLabel.isHidden = true
		totalBillErrorLabel.textColor = .razzmatazz
		tipErrorLabel.isHidden = true
		tipErrorLabel.textColor = .razzmatazz
		calcButton.setTitleColor(.mako, for: .normal)
		calcButton.backgroundColor = .turquoise
		calcButton.layer.cornerRadius = 30
		resetButton.setTitleColor(.razzmatazz, for: .normal)
		resetButton.setTitleColor(.mako, for: .disabled)
		totalInputView.backgroundColor = .clear
		tipInputView.backgroundColor = .clear
		totalInputView.backgroundColor = .darkJungleGreen
		totalInputView.layer.cornerRadius = 25
		tipInputView.backgroundColor = .darkJungleGreen
		tipInputView.layer.cornerRadius = 25
		billAmountLabel.textColor = .lightGray
		tipPercentLabel.textColor = .lightGray
		quickTipLabel.textColor = .lightGray
		tipAmountLabel.textColor = .lightGray
		totalWithTipLabel.textColor = .lightGray
		totalOutputLabel.textColor = .white
		tipOutputLabel.textColor = .white
		twoPercentLabel.textColor = .lightGray
		fifteenPercentLabel.textColor = .lightGray
		twentyPercentLabel.textColor = .lightGray
		twentyFivePercentLabel.textColor = .lightGray
		totalBillTextField.textColor = .white
		tipTextField.textColor = .white
		totalBillTextField.keyboardAppearance = .dark
		totalBillTextField.attributedPlaceholder = NSAttributedString(string: "0.00", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
		tipTextField.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
		tipTextField.keyboardAppearance = .dark
		settingsButton.setTitleColor(.turquoise, for: .normal)
	}
}



