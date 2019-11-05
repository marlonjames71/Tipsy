//
//  CustomButtons.swift
//  tipTester
//
//  Created by Marlon Raskin on 8/11/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

	override var isHighlighted: Bool {
		didSet {
			UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 5.0, options: [.allowUserInteraction], animations: {
				self.transform = self.isHighlighted ? .init(scaleX: 0.95, y: 0.95) : .identity
			}, completion: nil)
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

}

