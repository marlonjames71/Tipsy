//
//  Calculate.swift
//  tipTester
//
//  Created by Marlon Raskin on 6/2/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation


extension String {
	
	static func formattedPrice(with value: Int, with dollarSign: Bool = false) -> String {
		let dollars = value / 100
		let cents = value % 100
		let centsString = String(format: "%02d", cents)
		
		var baseValue =  "\(dollars).\(centsString)"
		if dollarSign {
			baseValue = "$\(baseValue)"
		}
		return baseValue
	}
	
	mutating func formatAsPercentage() {
		let legalChar = Set("0123456789")
		self = self.filter { legalChar.contains($0) }
		guard var number = Double(self) else { return }
		number /= 100
		
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .percent
		guard let formattedString = numberFormatter.string(from: NSNumber(value: number)) else { return }
		self = formattedString
	}
}




