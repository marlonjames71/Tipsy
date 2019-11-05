//
//  SettingsTableViewController.swift
//  tipTester
//
//  Created by Marlon Raskin on 10/29/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit
import MessageUI
import Social

class SettingsTableViewController: UITableViewController {

	@IBOutlet weak var buildVersionLabel: UILabel!

	fileprivate let helpAndFeedbackArray = ["Follow Tipsy on Twitter", "Send Feedback", "Contact Us", "Quick Tipsies"]
	fileprivate let twitterUrl: URL = {
		let baseURL = URL(string: "https://twitter.com/marlonjames71")!
		return baseURL
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] else { return }
        guard let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") else { return }
        buildVersionLabel.text = "Version: \(version) ⌇ Build: \(buildNumber)"
	}


    // MARK: - Table view data source

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case 0:
			return "Help & Feedback"
		case 1:
			return "Calculator"
		case 2:
			return "Quick tip emojis"
		default:
			return ""
		}
	}

    override func numberOfSections(in tableView: UITableView) -> Int {
		return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return helpAndFeedbackArray.count
		case 1:
			return 1
		case 2:
			return 1
		default:
			return 0
		}
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.section {
		case 0:
			let contactCell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
			contactCell.textLabel?.text = helpAndFeedbackArray[indexPath.row]
			return contactCell
		case 1:
			guard let roundingCell = tableView.dequeueReusableCell(withIdentifier: "RoundingCell", for: indexPath) as? RoundSettingTableViewCell else { return UITableViewCell() }
			roundingCell.descLabel.text = "Round Totals Up To Nearest Dollar"
			return roundingCell
		case 2:
			let emojiCell = tableView.dequeueReusableCell(withIdentifier: "ChooseEmojiCell", for: indexPath)
			emojiCell.textLabel?.text = "Choose Quick Tip Emojis"
			return emojiCell
		default:
			break
		}
		return UITableViewCell()
    }


	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard indexPath.section == 0 else { return }
		switch indexPath.row {
		case 0:
			if UIApplication.shared.canOpenURL(twitterUrl) {
				UIApplication.shared.open(twitterUrl, options: [:], completionHandler: nil)
			}
			break
		case 1:
			if MFMailComposeViewController.canSendMail() {
				let composeVC = MFMailComposeViewController()
				composeVC.navigationBar.tintColor = .turquoiseTwo
				composeVC.mailComposeDelegate = self
				composeVC.setToRecipients(["tipsysupport@august-light.com"])
				composeVC.setSubject("Feedback for Tipsy")
				composeVC.setMessageBody("Hey there! I have some feedback for Tipsy:\n\n", isHTML: false)
				present(composeVC, animated: true, completion: nil)
			} else {
				let mailAlert = UIAlertController(title: "Mail Services are not available", message: "Your mail app appears to not be configured", preferredStyle: .alert)
				mailAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
				present(mailAlert, animated: true, completion: nil)
			}
		case 2:
			if MFMailComposeViewController.canSendMail() {
				let composeVC = MFMailComposeViewController()
				composeVC.navigationBar.tintColor = .turquoiseTwo
				composeVC.mailComposeDelegate = self
				composeVC.setToRecipients(["tipsysupport@august-light.com"])
				composeVC.setSubject("Tipsy Issue")
				composeVC.setMessageBody("Hi, nice people at Tipsy. I'm having an issue I'd like help with: \n\n\n", isHTML: false)
				present(composeVC, animated: true, completion: nil)
			} else {
				let mailAlert = UIAlertController(title: "Mail services are not available", message: "Your mail app appears to not be configured", preferredStyle: .alert)
				mailAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
				present(mailAlert, animated: true, completion: nil)
			}
		case 3:
			performSegue(withIdentifier: "QuickTipsModalSegue", sender: self)
		default:
			break
		}
	}
}

extension SettingsTableViewController: MFMailComposeViewControllerDelegate {
	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		switch result {
		case .cancelled:
			controller.dismiss(animated: true, completion: nil)
		case .saved:
			controller.dismiss(animated: true, completion: nil)
		case .sent:
			let sentAlert = UIAlertController(title: "Your email has been sent", message: nil, preferredStyle: .alert)
			sentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			controller.dismiss(animated: true) {
				self.present(sentAlert, animated: true, completion: nil)
			}
		case .failed:
			let errorAlert = UIAlertController(title: "Oops, an error has occured", message: nil, preferredStyle: .alert)
			errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			controller.dismiss(animated: true) {
				self.present(errorAlert, animated: true, completion: nil)
			}
		@unknown default:
			fatalError()
		}
	}
}
