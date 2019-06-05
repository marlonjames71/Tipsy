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
	
	@IBOutlet var totalTextField: UITextField!
	@IBOutlet var totalErrorLabel: UILabel!
	@IBOutlet var tipTextField: UITextField!
	@IBOutlet var tipErrorLabel: UILabel!
	@IBOutlet var calcButton: UIButton!
	@IBOutlet var totalOutputView: UIView!
	@IBOutlet var tipOutputLabel: UILabel!
	@IBOutlet var totalOutputLabel: UILabel!
	@IBOutlet var clearButton: UIButton!
	@IBOutlet var emojiSegControl: UISegmentedControl!
	
	@IBAction func emojiTipAmount(_ sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
		case 0:
			tipTextField.text = "2"
		case 1:
			tipTextField.text = "15"
		case 2:
			tipTextField.text = "20"
		case 3:
			tipTextField.text = "25"
		default:
			emojiSegControl.selectedSegmentIndex = -1
		}
	}
	
	
	@IBAction func tipCalcButtonTapped(_ sender: Any) {
		guard let totalStrInput = totalTextField.text, !totalStrInput.isEmpty else {
			totalErrorLabel.text = "You must enter a total"
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
		clearButton.layer.borderColor = UIColor.black.cgColor
		clearButton.tintColor = UIColor.black
		totalOutputLabel.text = "$0.00"
		tipOutputLabel.text = "$0.00"
	}
	
	
	@IBAction func totalFieldDidChange(_ sender: UITextField) {
		guard var totalString = sender.text else { return }
		let legalChar = Set("0123456789")
		totalString = totalString.filter { legalChar.contains($0) }
		guard let totalInt = Int(totalString) else { return }
		sender.text = String.formattedPrice(with: totalInt)
		totalErrorLabel.text = ""
		clearButton.layer.borderColor = UIColor(red: 0.94, green: 0.09, blue: 0.35, alpha: 1).cgColor
		clearButton.tintColor = UIColor(red: 0.94, green: 0.09, blue: 0.35, alpha: 1)
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		logic = CalculatorLogic()
		calcButton.backgroundColor = UIColor(red: 0.35, green: 0.82, blue: 0.77, alpha: 1.00)
		calcButton.layer.cornerRadius = 20.0
		calcButton.tintColor = UIColor.white
		totalOutputView.layer.cornerRadius = 12.0
		clearButton.layer.borderWidth = 2
		clearButton.layer.borderColor = UIColor.black.cgColor
		clearButton.tintColor = UIColor.black
		clearButton.layer.cornerRadius = 10
		emojiSegControl.selectedSegmentIndex = -1
		emojiSegControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for:.selected)
		totalTextField.delegate = self
		tipTextField.delegate = self
	}
	
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
	
	
	func clear() {
		totalTextField.text = nil
		tipTextField.text = nil
		totalOutputLabel.text = nil
		tipOutputLabel.text = nil
		emojiSegControl.selectedSegmentIndex = -1
	}
}



