//
//  UINavigationController+StatusBar.swift
//  tipTester
//
//  Created by Marlon Raskin on 8/11/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

extension UINavigationController {
	open override var preferredStatusBarStyle: UIStatusBarStyle {
		return topViewController?.preferredStatusBarStyle ?? .default
	}
}
