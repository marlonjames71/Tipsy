//
//  String+ToImage.swift
//  tipsy
//
//  Created by Marlon Raskin on 12/1/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

extension String {
	func image(pointSize: CGFloat = 30) -> UIImage? {
		let nsString = self as NSString
		let font = UIFont.systemFont(ofSize: pointSize)

		let size = nsString.size(withAttributes: [.font: font])
		UIGraphicsBeginImageContextWithOptions(size, false, 0)
		let rect = CGRect(origin: .zero, size: size)
		nsString.draw(in: rect, withAttributes: [.font: font])
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image
	}
}
