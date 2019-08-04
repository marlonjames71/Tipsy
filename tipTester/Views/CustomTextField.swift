//
//  CustomTextField.swift
//  tipTester
//
//  Created by Marlon Raskin on 8/2/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit


@IBDesignable
class CustomTextField: UITextField {
	@IBInspectable var insetX: CGFloat = 0
	@IBInspectable var insetY: CGFloat = 0

	// placeholder position
	override func textRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.insetBy(dx: insetX, dy: insetY)
	}

	// text position
	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.insetBy(dx: insetX, dy: insetY)
	}

//	self.layer.borderWidth = 2
//	self.layer.borderColor = #colorLiteral(red: 0.4352941215, green: 0.4431372583, blue: 0.4745098054, alpha: 1)
//	self.layer.cornerRadius = 20
}

