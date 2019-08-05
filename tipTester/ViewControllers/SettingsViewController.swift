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

	fileprivate let themeLabelTitles: [ThemeModes] = [.light, .dark]

	@IBOutlet weak var themeLabel: UILabel!
	@IBOutlet weak var tableParentView: UIView!
	@IBOutlet weak var tableView: UITableView!

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.isNavigationBarHidden = false
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		setupLightUI()
		tableParentView.layer.cornerRadius = 10
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = UIView()
    }

	private func setupLightUI() {
		navigationController?.navigationBar.tintColor = .turquoiseTwo
		view.backgroundColor = .wildSand
	}

}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell()
		cell.textLabel?.text = "\(themeLabelTitles[indexPath.row].rawValue)"
		cell.selectionStyle = .none
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath) else { return }
		if cell.isSelected {
			cell.tintColor = .turquoiseTwo
			cell.accessoryType = .checkmark
		}
//		tableView.reloadData()
	}

	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath) else { return }
		if cell.isSelected == false {
			cell.accessoryType = .none
		}
	}


}
