//
//  ThemeSelectionTableViewCell.swift
//  tipTester
//
//  Created by Marlon Raskin on 8/5/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class ThemeSelectionTableViewCell: UITableViewCell {

	override func awakeFromNib() {
		super.awakeFromNib()
		backgroundColor = .darkJungleGreen
		setUI()
	}

	var themeNotification: NSObjectProtocol?

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

	private func setUI() {
		let traitCollection = UITraitCollection()
		backgroundColor = .darkJungleGreen
		if traitCollection.userInterfaceStyle == .light {
			tintColor = .turquoiseTwo
			textLabel?.textColor = .mako
			backgroundColor = .white
		} else {
			tintColor = .turquoise
			textLabel?.textColor = .wildSand
			backgroundColor = .darkJungleGreen
		}
	}
}
