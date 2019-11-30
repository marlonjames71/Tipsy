//
//  FontHelper.swift
//  swaap
//
//  Created by Marlon Raskin on 11/28/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit

extension UIFont {
	static func roundedFont(ofSize fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
		// Will be SF Compact or standard SF in case of failure.
//		let fontSize = UIFont.preferredFont(forTextStyle: style).pointSize
		if let descriptor = UIFont.systemFont(ofSize: fontSize, weight: weight).fontDescriptor.withDesign(.rounded) {
			return UIFont(descriptor: descriptor, size: fontSize)
		} else {
			return UIFont.systemFont(ofSize: fontSize)
		}
	}
}
