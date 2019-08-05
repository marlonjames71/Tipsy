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
}

