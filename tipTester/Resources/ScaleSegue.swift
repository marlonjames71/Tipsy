//
//  ScaleSegue.swift
//  tipTester
//
//  Created by Marlon Raskin on 9/1/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class ScaleSegue: UIStoryboardSegue {

	override func perform() {
		scale()
	}

	func scale() {
		let toViewController = self.destination
		let fromViewController = self.source

		let containerView = fromViewController.view.superview
		let originalCenter = fromViewController.view.center

		toViewController.view.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
		toViewController.view.center = originalCenter

		containerView?.addSubview(toViewController.view)

		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 5.0, initialSpringVelocity: 2.0, options: [.curveEaseInOut], animations: {
			toViewController.view.transform = CGAffineTransform.identity
		}) { (success) in
//			fromViewController.present(toViewController, animated: false, completion: nil)
		}
	}
}

class UnwindScaleSegue: UIStoryboardSegue {
	override func perform() {

	}

//	func unwindScale() {
//		let toViewController = self.destination
//		let originalCenter = self.sourceq
//
//		let containerView = fromView
//	}
}
