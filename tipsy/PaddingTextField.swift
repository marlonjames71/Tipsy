//
//  PaddingTextField.swift
//  tipTester
//
//  Created by Marlon Raskin on 6/10/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class PaddingTextField: UITextField {

	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func textRect(forBounds bounds: CGRect) -> CGRect {
		return frame.inset(by: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
	}
	
	override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
		return frame.inset(by: UIEdgeInsets(top: 1, left: 15, bottom: 1, right: 15))
	}

//	override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
//		return frame.inset(by: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
//	}
	
	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		return frame.inset(by: UIEdgeInsets(top: 1, left: 15, bottom: 1, right: 15))
	}
	
	
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
