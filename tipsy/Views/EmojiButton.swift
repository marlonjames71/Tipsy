//
//  EmojiButton.swift
//  tipTester
//
//  Created by Marlon Raskin on 10/31/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class EmojiButton: UIButton {
	
	var emojiSelected: Bool = false {
		didSet {
			updateViews()
		}
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		updateViews()
	}
	
	private func updateViews() {
		if emojiSelected {
			layer.cornerRadius = 10
			layer.cornerCurve = .continuous
			layer.borderColor = tintColor.cgColor
			layer.borderWidth = 2.5
			backgroundColor = .turquoiseTwo.withAlphaComponent(0.2)
		} else {
			layer.borderWidth = 0
			backgroundColor = nil
		}
	}
}
