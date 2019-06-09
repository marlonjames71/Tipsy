//
//  CalculatorLogic.swift
//  tipTester
//
//  Created by Marlon Raskin on 6/2/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation


class CalculatorLogic {
	
	var alert: AlertViewController?
	
	func calculateTipTotal(subTotalStr: String, tipPercentStr: String) -> (String, String)? {
		var tip: Double = 0.0
		var total: Double = 0.0
		if !subTotalStr.isEmpty,
			!tipPercentStr.isEmpty,
			let subTotal = Double(subTotalStr),
			let tipPercent = Double(tipPercentStr) {
			
			tip = subTotal * tipPercent / 100
			total = subTotal + tip
			
		} else {
			// TODO: Add some kind of alert message maybe?
		}
		
		guard let formattedTip = currencyFormatter.string(from: NSNumber(value: tip)) else { return nil}
		guard let formattedTotal = currencyFormatter.string(from: NSNumber(value: total)) else { return nil }
		
		let result = (formattedTip, formattedTotal)

		return result
	}
	
	var currencyFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .currency
		return formatter
	}()
	
}

