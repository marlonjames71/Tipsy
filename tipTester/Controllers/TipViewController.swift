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
	@IBOutlet var resetButton: UIButton!
	@IBOutlet var emojiSegControl: UISegmentedControl!
	@IBOutlet var totalInputView: UIView!
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
		logic = CalculatorLogic()
		totalBillTextField.delegate = self
		tipTextField.delegate = self
		setUpUI()
	}

	@IBAction func firstEmojiTapped(_ sender: UIButton) {
		tipTextField.text = "2"
		let generator = UISelectionFeedbackGenerator()
		generator.selectionChanged()
	}
	@IBAction func secondEmojiTapped(_ sender: UIButton) {
		tipTextField.text = "15"
		let generator = UISelectionFeedbackGenerator()
		generator.selectionChanged()
	}
	@IBAction func thirdEmojiTapped(_ sender: UIButton) {
		tipTextField.text = "20"
		let generator = UISelectionFeedbackGenerator()
		generator.selectionChanged()
	}
	@IBAction func fourthEmojiTapped(_ sender: UIButton) {
		tipTextField.text = "25"
		let generator = UISelectionFeedbackGenerator()
		generator.selectionChanged()
	}


	
	@IBAction func emojiTipAmount(_ sender: UISegmentedControl) {
		tipErrorLabel.text = nil
		switch sender.selectedSegmentIndex {
		case 0:
			tipTextField.text = "2"
			let generator = UISelectionFeedbackGenerator()
			generator.selectionChanged()
		case 1:
			tipTextField.text = "15"
			let generator = UISelectionFeedbackGenerator()
			generator.selectionChanged()
		case 2:
			tipTextField.text = "20"
			let generator = UISelectionFeedbackGenerator()
			generator.selectionChanged()
		case 3:
			tipTextField.text = "25"
			let generator = UISelectionFeedbackGenerator()
			generator.selectionChanged()
		default:
			emojiSegControl.selectedSegmentIndex = -1
		}
	}
	
	
	@IBAction func tipCalcButtonTapped(_ sender: Any) {
		let generator = UIImpactFeedbackGenerator(style: .light)
		generator.prepare()
		generator.impactOccurred()
		guard let totalStrInput = totalBillTextField.text, !totalStrInput.isEmpty else {
			totalBillErrorLabel.text = "You must enter a total"
			return
		}
		guard let tipPercentStrInput = tipTextField.text, !tipPercentStrInput.isEmpty else {
			tipErrorLabel.text = "You must enter a tip percentage"
			return
		}
		
		guard let logic = logic else { return }
		guard let (tipOutput, totalOutput) = logic.calculateTipTotal(subTotalStr: totalStrInput, tipPercentStr: tipPercentStrInput) else { return }
		tipOutputLabel.text = tipOutput
		totalOutputLabel.text = totalOutput
	}
	
	
	@IBAction func clearButtonTapped(_ sender: UIButton) {
		clear()
		resetButton.layer.borderColor = UIColor.black.cgColor
		resetButton.tintColor = UIColor.black
		totalOutputLabel.text = "$0.00"
		tipOutputLabel.text = "$0.00"
		let generator = UISelectionFeedbackGenerator()
		generator.selectionChanged()
	}
	
	
	@IBAction func totalFieldDidChange(_ sender: UITextField) {
		guard var totalString = sender.text else { return }
		let legalChar = Set("0123456789")
		totalString = totalString.filter { legalChar.contains($0) }
		guard let totalInt = Int(totalString) else { return }
		sender.text = String.formattedPrice(with: totalInt)
		totalBillErrorLabel.text = ""
		resetButton.layer.borderColor = UIColor(red: 0.94, green: 0.09, blue: 0.35, alpha: 1).cgColor
		resetButton.tintColor = UIColor(red: 0.94, green: 0.09, blue: 0.35, alpha: 1)
	}
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
		emojiSegControl.selectedSegmentIndex = -1
	}


	private func setUpUI() {
		view.layer.backgroundColor = UIColor(red: 0.66, green: 0.73, blue: 0.78, alpha: 1.00).cgColor
		calcButton.backgroundColor = UIColor(red: 0.11, green: 0.60, blue: 0.91, alpha: 1.00)
		calcButton.layer.cornerRadius = 20.0
		calcButton.tintColor = UIColor.white
		resetButton.layer.borderWidth = 2
		resetButton.layer.borderColor = UIColor.black.cgColor
		resetButton.tintColor = UIColor.black
		resetButton.layer.cornerRadius = 10
		emojiSegControl.selectedSegmentIndex = -1
		emojiSegControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for:.selected)
		totalInputView.backgroundColor = .clear
//		totalBillTextField

		totalInputView.layer.borderWidth = 2
		totalInputView.layer.borderColor = #colorLiteral(red: 0.4352941215, green: 0.4431372583, blue: 0.4745098054, alpha: 1)
		totalInputView.layer.cornerRadius = 20
	}


}



