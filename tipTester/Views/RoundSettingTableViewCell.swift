//
//  RoundSettingTableViewCell.swift
//  tipTester
//
//  Created by Marlon Raskin on 10/29/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class RoundSettingTableViewCell: UITableViewCell {

	// MARK: - Outlets & Properties
	@IBOutlet weak var descLabel: UILabel!
	@IBOutlet weak var roundSwitch: UISwitch!

	let defaults = UserDefaults.standard
	var roundingIsOn = false

	// MARK: - Lifecycle
	override func awakeFromNib() {
        super.awakeFromNib()
		setupUI()
		checkForRoundedPreference()
    }

	// MARK: - Save & Check Preferences For Rounding
	@IBAction func roundingSwitched(_ sender: UISwitch) {
		roundingIsOn = !roundingIsOn
		saveRoundedPreference()
	}

	private func saveRoundedPreference() {
        defaults.set(roundingIsOn, forKey: .roundingKey)
		defaults.synchronize()
	}

	func checkForRoundedPreference() {
        let roundingToggled = defaults.bool(forKey: .roundingKey)

		if roundingToggled {
			roundingIsOn = true
			roundSwitch.isOn = true
		} else {
			roundingIsOn = false
			roundSwitch.isOn = false
		}
	}

	// MARK: - Setup Function
	private func setupUI() {
		descLabel.text = "Round To Nearest Dollar"
	}
}
