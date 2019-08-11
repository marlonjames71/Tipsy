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

	var isDarkStatusBar = false {
		didSet {
			print(self.isDarkStatusBar)
			UIView.animate(withDuration: 0.3) {
				self.setNeedsStatusBarAppearanceUpdate()
			}
		}
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return isDarkStatusBar ? .default : .lightContent
	}


	@IBOutlet weak var themeLabel: UILabel!
	@IBOutlet weak var tableContainerView: UIView!
	@IBOutlet weak var tableView: UITableView!

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
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
		tableContainerView.layer.cornerRadius = 10
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = UIView()
		guard let indexPath = tableView.indexPathForSelectedRow else { return }
		tableView(tableView, didSelectRowAt: indexPath)
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
			isDarkStatusBar = true
		case .dark:
			themeLabel.textColor = .lightGray
			view.backgroundColor = .black
			navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
			navigationController?.navigationBar.barTintColor = .black
			navigationController?.navigationBar.tintColor = .turquoiseTwo
			isDarkStatusBar = false
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
			themeHelper.setThemePreferenceLight()
//			isDarkStatusBar.toggle()
		} else {
			themeHelper.setThemePreferenceDark()
//			isDarkStatusBar.toggle()
		}
	}
}
