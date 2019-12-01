//
//  QuickTipsView.swift
//  tipTester
//
//  Created by Marlon Raskin on 11/4/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class QuickTipsView: UIView {

	@IBOutlet private weak var imageView: UIImageView!
	@IBOutlet private weak var label: UILabel!
	@IBOutlet private weak var imageViewHeightAnchor: NSLayoutConstraint!

	var text: String {
		get {
			label.text ?? ""
		}
		set {
			label.text = newValue
		}
	}

	var image: UIImage? {
		get {
			imageView.image
		}
		set {
			imageView.image = newValue
		}
	}

    override func draw(_ rect: CGRect) {
		imageView.layer.cornerRadius = 12
		imageView.layer.cornerCurve = .continuous

		if UIScreen.main.bounds.height <= 667 {
			imageViewHeightAnchor.constant = 300
		}
    }
}
