//
//  ThemeSelectionTableViewCell.swift
//  tipTester
//
//  Created by Marlon Raskin on 8/5/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class ThemeSelectionTableViewCell: UITableViewCell {

	var themeHelper: ThemeHelper? {
		didSet {
			updateViews()
		}
	}

	var themeNotification: NSObjectProtocol?

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		commonInit()
	}

	private func commonInit() {
		themeNotification = NotificationCenter.default.addObserver(forName: .themeChanged, object: nil, queue: nil, using: { (_) in
			self.updateViews()
		})
	}


	deinit {
		themeNotification = nil
		print("Poopy")
	}


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

	private func updateViews() {
		guard let themeHelper = themeHelper else { return }
		switch themeHelper.themePreference {
		case .light:
			tintColor = .turquoiseTwo
			textLabel?.textColor = .mako
			backgroundColor = .white
		case .dark:
			tintColor = .turquoise
			textLabel?.textColor = .wildSand
			backgroundColor = .darkJungleGreen
		}
		accessoryType = textLabel?.text == themeHelper.themePreference.stringValue ? .checkmark : .none
	}
}
