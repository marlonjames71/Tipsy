//
//  RoundSettingTableViewCell.swift
//  tipTester
//
//  Created by Marlon Raskin on 10/29/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class ToggleSettingsTableViewCell: UITableViewCell {

	// MARK: - Outlets & Properties
	@IBOutlet private weak var descLabel: UILabel!
	@IBOutlet private weak var toggle: UISwitch!
	@IBOutlet private weak var subtitleLabel: UILabel!
	@IBOutlet weak var iconImageView: UIImageView!

	typealias ToggleTableViewCellAction = (UISwitch) -> Void
	var action: ToggleTableViewCellAction?

	var color: UIColor?

	var isOn: Bool {
		get {
			toggle.isOn
		}
		set {
			toggle.isOn = newValue
		}
	}

	var descText: String {
		get {
			descLabel.text ?? ""
		}
		set {
			descLabel.text = newValue
		}
	}

	var subtitleText: String {
		get {
			subtitleLabel.text ?? ""
		}
		set {
			subtitleLabel.text = newValue
			subtitleLabel.isHidden = newValue.isEmpty
		}
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		action = nil
		subtitleText = ""
	}


	// MARK: - Save & Check Preferences For Rounding
	@IBAction func switchToggled(_ sender: UISwitch) {
		action?(sender)
		if let color = color {
			if sender.isOn {
				iconImageView.tintColor = color
			} else {
				iconImageView.tintColor = .systemGray3
			}
		}
	}
}
