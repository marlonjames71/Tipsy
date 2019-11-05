//
//  HapticTableViewCell.swift
//  tipsy
//
//  Created by Marlon Raskin on 11/5/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class HapticTableViewCell: UITableViewCell {

	// MARK: - Outlets & Properties
	@IBOutlet weak var label: UILabel!
	@IBOutlet weak var hapticSwitch: UISwitch!

	var hapticIsOn = true

	// MARK: - Lifecycle
	override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
		checkForHapticPreference()
    }

	// MARK: - Save & Check Preferences for Haptic Feedback
	@IBAction func hapticPreferenceChanged(_ sender: UISwitch) {
		hapticIsOn = !hapticIsOn
		saveHapticIsOnPreference()
	}

	private func saveHapticIsOnPreference() {
		DefaultsManager.hapticFeedbackIsOn = hapticIsOn
	}

	private func checkForHapticPreference() {
		let hapticToggled = DefaultsManager.hapticFeedbackIsOn

		if hapticToggled {
			hapticIsOn = true
			hapticSwitch.isOn = true
		} else {
			hapticIsOn = false
			hapticSwitch.isOn = false
		}
	}

	// MARK: - Setup Function
	private func setupUI() {
		label.text = "Haptic Feedback"
	}
}
