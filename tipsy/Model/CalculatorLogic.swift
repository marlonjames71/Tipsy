//
//  CalculatorLogic.swift
//  tipTester
//
//  Created by Marlon Raskin on 6/2/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation


class CalculatorLogic {
	
	var currencyFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .currency
		return formatter
	}()

    var percentFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
		formatter.maximumFractionDigits = 1
        formatter.percentSymbol = ""
        return formatter
    }()

    func totalPerPerson(billTotalString: String, tipPercentageString: String, numberOfPeople: Int = 1, isRounded: Bool) -> (totalPerPerson: String, actualTipPercentage: String, tipAmount: String, wholeBillTotal: String)? {
        guard let billSubtotal = Double(billTotalString),
            let preprocessTipPercent = Double(tipPercentageString) else { return nil }
        let tipPercentage = preprocessTipPercent / 100

        // Each Person Total
        let eachPersonSubtotal = billSubtotal / Double(numberOfPeople)
        let tipAmount = eachPersonSubtotal * tipPercentage
        var eachPersonTotal = eachPersonSubtotal + tipAmount

        // Actual Tip Percentage Value
		eachPersonTotal = isRounded ? ceil(eachPersonTotal) : eachPersonTotal.roundToNearestDecimalPlace(2)
        let actualTip = (eachPersonTotal / eachPersonSubtotal) - 1

        // The total of the bill with each person's split included
        let wholeBillAmount = eachPersonTotal * Double(numberOfPeople)

        // Tip amount
        let completeTipAmount = wholeBillAmount - billSubtotal

        // Formatting back to string
        guard let formattedEachPersonTotalStr = currencyFormatter.string(from: NSNumber(value: eachPersonTotal)),
            let formattedTipAmountStr = currencyFormatter.string(from: NSNumber(value: completeTipAmount)),
            let formattedWholeBillTotal = currencyFormatter.string(from: NSNumber(value: wholeBillAmount)),
            let formattedTipPercentageStr = percentFormatter.string(from: NSNumber(value: actualTip)) else { return nil }

        return (formattedEachPersonTotalStr, formattedTipPercentageStr, formattedTipAmountStr, formattedWholeBillTotal)
    }
}

extension Double {

	/// decimal Places is the count of decimal places to be rounded to. Example: 1 = tenths, 2 = hundredths, 3 = thousandths, etc.
	func roundToNearestDecimalPlace(_ decimalPlace: UInt8) -> Double {
		let roundedStr = String(format: "%.0\(decimalPlace)f", self)
		guard let roundedValue = Double(roundedStr) else { fatalError("Could not unwrap rounded value from string. self: \(self), decimal place: \(decimalPlace), rounded string: \(roundedStr)") }

		return roundedValue
	}
}

