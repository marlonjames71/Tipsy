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
		let baseURL = URL(string: "https://twitter.com/iOSTipsyApp")!
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
			return "Calculator & App Settings"
		case 2:
			return "Messaging Prompts"
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
			return 3
		default:
			return 1
		}
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.section {
		case 0:
			return contactCell(tableView, cellForRowAt: indexPath)
		case 1:
			switch indexPath.row {
			case 0:
				return roundingCell(tableView, cellForRowAt: indexPath)
			case 1:
				return hapticCell(tableView, cellForRowAt: indexPath)
			case 2:
				return emojiCell(tableView, cellForRowAt: indexPath)
			default:
				break
			}
		case 2:
			return applePayCell(tableView, cellForRowAt: indexPath)
		default:
			break
		}
		return UITableViewCell()
    }

	// MARK: - TableView Cells

	private func contactCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let contactCell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
		contactCell.textLabel?.text = helpAndFeedbackArray[indexPath.row]
		return contactCell
	}

	private func roundingCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let roundingCell = tableView.dequeueReusableCell(withIdentifier: "RoundingCell", for: indexPath) as? ToggleSettingsTableViewCell else { return UITableViewCell() }
		roundingCell.descText = "Round Totals Up To Nearest Dollar"
		roundingCell.isOn = DefaultsManager.roundingIsEnabled
		roundingCell.action = { sender in
			DefaultsManager.roundingIsEnabled = sender.isOn
		}
		return roundingCell
	}

	private func applePayCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let applePayCell = tableView.dequeueReusableCell(withIdentifier: "RoundingCell", for: indexPath) as? ToggleSettingsTableViewCell else { return UITableViewCell() }
		applePayCell.descText = "Include Apple Pay Hint"
		applePayCell.isOn = DefaultsManager.includeApplePayHint
		applePayCell.subtitleText = "When using the Split Bill feature you can message your party members with their portion of the bill. Messages will include a hint that Apple Pay can be used. Toggle off if you prefer not to receive Apple Cash."
		applePayCell.action = { sender in
			DefaultsManager.includeApplePayHint = sender.isOn
		}
		return applePayCell
	}

	private func hapticCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let hapticCell = tableView.dequeueReusableCell(withIdentifier: "HapticCell", for: indexPath) as? HapticTableViewCell else { return UITableViewCell() }
		hapticCell.label.text = "Haptic Feedback"
		return hapticCell
	}

	private func emojiCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let emojiCell = tableView.dequeueReusableCell(withIdentifier: "ChooseEmojiCell", for: indexPath)
		emojiCell.textLabel?.text = "Choose Quick Tip Emojis"
		return emojiCell
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
