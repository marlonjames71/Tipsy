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
//	var cardViewController: CardViewController!

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
	@IBOutlet weak var secondEmoji: UIButton!
	@IBOutlet weak var thirdEmoji: UIButton!
	@IBOutlet weak var fourthEmoji: UIButton!


	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.navigationBar.isHidden = true
		logic = CalculatorLogic()
		totalBillTextField.delegate = self
		tipTextField.delegate = self
		setUpUI()
		updateResetButtonTextColor()
	}

	@IBAction func firstEmojiTapped(_ sender: UIButton) {
		tipTextField.text = "2"
//		tipCalcButtonTapped()
		tipValueChanged()
	}
	@IBAction func secondEmojiTapped(_ sender: UIButton) {
		tipTextField.text = "15"
		tipValueChanged()
	}
	@IBAction func thirdEmojiTapped(_ sender: UIButton) {
		tipTextField.text = "20"
		tipValueChanged()
	}
	@IBAction func fourthEmojiTapped(_ sender: UIButton) {
		tipTextField.text = "25"
		tipValueChanged()
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

//	@IBAction func totalFieldDidChange(_ sender: UITextField) {
//		guard var totalString = sender.text else { return }
//		let legalChar = Set("0123456789")
//		totalString = totalString.filter { legalChar.contains($0) }
//		guard let totalInt = Int(totalString) else { return }
//		sender.text = String.formattedPrice(with: totalInt)
//		totalBillErrorLabel.isHidden = true
////		resetButton.layer.borderColor = UIColor(red: 0.94, green: 0.09, blue: 0.35, alpha: 1).cgColor
//		resetButton.tintColor = .razzmatazz
//	}

	@IBAction func tipFieldDidChange(_ sender: UITextField) {
		tipErrorLabel.text = ""
	}
	
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
	
	func clear() {
		totalBillTextField.text = nil
		tipTextField.text = nil
		totalOutputLabel.text = nil
		tipOutputLabel.text = nil
		totalOutputLabel.text = "$0.00"
		tipOutputLabel.text = "$0.00"
		tipErrorLabel.isHidden = true
		totalBillErrorLabel.isHidden = true
		updateResetButtonTextColor()
	}


	private func setUpUI() {
		view.backgroundColor = .wildSand
		totalBillErrorLabel.isHidden = true
		totalBillErrorLabel.textColor = .razzmatazz
		tipErrorLabel.isHidden = true
		tipErrorLabel.textColor = .razzmatazz
		calcButton.backgroundColor = .turquoise
		calcButton.layer.cornerRadius = 30
		resetButton.setTitleColor(.razzmatazz, for: .normal)
		resetButton.setTitleColor(.mako, for: .disabled)
		totalInputView.backgroundColor = .clear
		tipInputView.backgroundColor = .clear
		totalInputView.backgroundColor = .white
		totalInputView.layer.cornerRadius = 20
		tipInputView.backgroundColor = .white
		tipInputView.layer.cornerRadius = 20
	}


}



