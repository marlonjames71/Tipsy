//
//  QuickTipsViewController.swift
//  tipTester
//
//  Created by Marlon Raskin on 10/31/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class QuickTipsViewController: UIViewController {


	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var pageControl: UIPageControl!
	@IBOutlet var tapGesture: UITapGestureRecognizer!

	let pages: [QuickTipsView] = {
		let pageOne: QuickTipsView = Bundle.main.loadNibNamed("QuickTipsView", owner: self, options: nil)?.first as! QuickTipsView
		pageOne.image = UIImage(named: "rightEdgeDark")
		pageOne.text = "You can swipe from the right edge of the main screen to navigate to the settings page"

		let pageTwo: QuickTipsView = Bundle.main.loadNibNamed("QuickTipsView", owner: self, options: nil)?.first as! QuickTipsView
		pageTwo.image = UIImage(named: "swipeLeftRightDark")
		pageTwo.text = "When the keyboard is Active, you can swipe left or right on the main screen to change fields"

		let pageThree: QuickTipsView = Bundle.main.loadNibNamed("QuickTipsView", owner: self, options: nil)?.first as! QuickTipsView
		pageThree.image = UIImage(named: "toggleKeyboard")
		pageThree.text = "Swipe down anywhere on the main screen to hide the keyboard"

		return [pageOne, pageTwo, pageThree]
	}()

	let photoArray = [UIImage(named: "rightEdgeDark"), UIImage(named: "swipeLeftRightDark"), UIImage(named: "toggleKeyboard")]

	override func viewDidLoad() {
        super.viewDidLoad()
		scrollView.delegate = self
		scrollView.alwaysBounceVertical = false
		setupScrollView(pages: pages)
		pageControl.numberOfPages = pages.count
		pageControl.currentPage = 0
		tapGesture.numberOfTapsRequired = 2
    }

	@IBAction func doneTapped(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}

	@IBAction func screenDoubleTapped(_ sender: UITapGestureRecognizer) {
		if tapGesture.state == .recognized {
			self.dismiss(animated: true, completion: nil)
		}
	}


	private func setupScrollView(pages: [QuickTipsView]) {
		scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
		scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(pages.count), height: view.frame.height)
		scrollView.isPagingEnabled = true

		for i in 0..<pages.count {
			pages[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: 375)
			scrollView.addSubview(pages[i])
		}
	}
}

extension QuickTipsViewController: UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		scrollView.contentOffset.y = 0
		let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
		pageControl.currentPage = Int(pageIndex)
	}
}
