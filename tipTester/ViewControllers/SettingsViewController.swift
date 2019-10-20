//
//  SettingsViewController.swift
//  tipTester
//
//  Created by Marlon Raskin on 8/4/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

enum ThemeModes: String {
	case light = "Light"
	case dark = "Dark"
}

class SettingsViewController: UIViewController {

	fileprivate let themeLabelTitles: [String] = ThemeMode.allCases.map { $0.stringValue }
	var themeNotification: NSObjectProtocol?
	let interfaceStyle = UITraitCollection.current
	let defaults = UserDefaults.standard
	var roundingIsOn = false

	@IBOutlet weak var themeLabel: UILabel!
	@IBOutlet weak var themeTableContainerView: UIView!
	@IBOutlet weak var themeTableView: UITableView!
	@IBOutlet weak var roundSettingContainerView: UIView!
	@IBOutlet weak var roundedAmountsLabel: UILabel!
	@IBOutlet weak var roundSwitch: UISwitch!
	@IBOutlet weak var descriptionLabelForRoundSetting: UILabel!
	@IBOutlet weak var emojiSelectLabel: UILabel!
	@IBOutlet weak var cellContainer: UIView!
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        checkForRoundedPreference()
		setUI()
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		themeTableContainerView.layer.cornerRadius = 10
		themeTableView.delegate = self
		themeTableView.dataSource = self
		themeTableView.tableFooterView = UIView()
		themeTableView.backgroundColor = .darkJungleGreen
		roundSettingContainerView.layer.cornerRadius = 10
		guard let indexPath = themeTableView.indexPathForSelectedRow else { return }
		tableView(themeTableView, didSelectRowAt: indexPath)
    }

	@IBAction func roundSwitchToggled(_ sender: UISwitch) {
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
	

	func setUI() {
		let traitCollection = UITraitCollection()
		if traitCollection.userInterfaceStyle == .light {
			themeTableView.backgroundColor = .white
		} else {
			themeTableView.backgroundColor = .darkJungleGreen
		}
	}
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return themeLabelTitles.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = ThemeSelectionTableViewCell()
		cell.textLabel?.text = themeLabelTitles[indexPath.row]
		cell.selectionStyle = .none
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

	}
}
