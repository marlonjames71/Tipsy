//
//  Alerts.swift
//  tipsy
//
//  Created by Marlon Raskin on 11/25/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit
import MessageUI

struct Alerts {

	// MARK: - Mail Compose Action Sheet
	static func showBasicContactAlert(on vc: SettingsTableViewController) {
		let alert = UIAlertController(title: "Choose One of the Following Message Types", message: #"If it's general, select "Contact Us""#, preferredStyle: .actionSheet)

		let feedbackAction = UIAlertAction(title: "Feedback", style: .default) { _ in
			let composeVC = setupComposeVC(vc: vc, subject: "Feedback For Tipsy", body: "Hey there! I have some feedback for Tipsy.")
			vc.present(composeVC, animated: true, completion: nil)
		}

		let reportABugAction = UIAlertAction(title: "Report A Bug", style: .default) { _ in
			let composeVC = setupComposeVC(vc: vc, subject: "I've Found A Bug", body: "Hi, nice people at Tipsy. I'm pretty sure I've discovered a bug.")
			vc.present(composeVC, animated: true, completion: nil)
		}

		let contactUsAction = UIAlertAction(title: "Contact Us", style: .default) { _ in
			let composeVC = setupComposeVC(vc: vc, subject: "General Inquiry", body: "What's Up, Tipsy!")
			vc.present(composeVC, animated: true, completion: nil)
		}

		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

		[contactUsAction, feedbackAction, reportABugAction, cancelAction].forEach { alert.addAction($0) }
		vc.present(alert, animated: true, completion: nil)
	}

	// MARK: - Helper Method
	static func setupComposeVC(vc: SettingsTableViewController, subject: String, body: String) -> MFMailComposeViewController {
		let composeVC = MFMailComposeViewController()
		composeVC.navigationBar.tintColor = .turquoiseTwo
		composeVC.mailComposeDelegate = vc
		composeVC.setToRecipients(["tipsysupport@august-light.com"])
		composeVC.setSubject(subject)
		composeVC.setMessageBody("\(body) \n\n\n", isHTML: false)
		return composeVC
	}
}
