//
//  SettingsTableViewController.swift
//  tipTester
//
//  Created by Marlon Raskin on 10/29/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

	fileprivate let helpAndFeedbackArray = ["Quick Help Via Twitter", "Send Feedback", "Quick Tips"]

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case 0:
			return "Help & Feedback"
		case 1:
			return "When this setting is turned on, it will round *up* to the nearest dollar"
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
			roundingCell.descLabel.text = "Round To Nearest Dollar"
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
