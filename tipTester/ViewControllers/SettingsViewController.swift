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
	var themeHelper: ThemeHelper?
	var themeNotification: NSObjectProtocol?

	// TODO: - Fix This!
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return setStatusBarStyle()
	}

	@IBOutlet weak var themeLabel: UILabel!
	@IBOutlet weak var tableParentView: UIView!
	@IBOutlet weak var tableView: UITableView!

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setNeedsStatusBarAppearanceUpdate()
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.isNavigationBarHidden = false
		setUI()
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		themeNotification = NotificationCenter.default.addObserver(forName: .themeChanged, object: nil, queue: nil, using: { [weak self](_) in
			guard let self = self else { return }
			UIView.animate(withDuration: 0.3, animations: self.setUI)
		})
		tableParentView.layer.cornerRadius = 10
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = UIView()
		guard let indexPath = tableView.indexPathForSelectedRow else { return }
		tableView(tableView, didSelectRowAt: indexPath)
    }

	// TODO: - Fix this too!
	func setStatusBarStyle() -> UIStatusBarStyle {
		guard let themeHelper = themeHelper else { return .default }

		switch themeHelper.themePreference {
		case .dark:
			return .lightContent
		case .light:
			return .default
		}
	}

	func setUI() {
		guard let themeHelper = themeHelper else { return }
		switch themeHelper.themePreference {
		case .light:
			themeLabel.textColor = .mako
			view.backgroundColor = .wildSand
			navigationController?.navigationBar.barTintColor = .wildSand
			navigationController?.navigationBar.tintColor = .turquoiseTwo
			navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
		case .dark:
			themeLabel.textColor = .lightGray
			view.backgroundColor = .black
			navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
			navigationController?.navigationBar.barTintColor = .black
			navigationController?.navigationBar.tintColor = .turquoiseTwo
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
		cell.themeHelper = themeHelper
		cell.selectionStyle = .none
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let themeHelper = themeHelper,
			let cell = tableView.cellForRow(at: indexPath) else { return }
		if cell.textLabel?.text == ThemeModes.light.rawValue {
			setNeedsStatusBarAppearanceUpdate()
			themeHelper.setThemePreferenceLight()
		} else {
			themeHelper.setThemePreferenceDark()
		}
	}
}
