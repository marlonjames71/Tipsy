//
//  ThemeHelper.swift
//  tipTester
//
//  Created by Marlon Raskin on 8/4/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation

protocol ThemeHelperAccessable: AnyObject {
	var themeHelper: ThemeHelper? { set get }
}

enum ThemeMode: Int, CaseIterable {
	case light = 0
	case dark

	var stringValue: String {
		switch self {
		case .light:
			return "Light"
		case .dark:
			return "Dark"
		}
	}
}

class ThemeHelper {

	let themePreferenceKey = "selectTheme"

	var themePreference: ThemeMode {
		let defaults = UserDefaults.standard
		let themeRawValue = (defaults[themePreferenceKey] as? Int) ?? 0
		return ThemeMode(rawValue: themeRawValue) ?? ThemeMode.light
	}

	func setThemePreferenceLight() {
		let defaults = UserDefaults.standard
		defaults[themePreferenceKey] = ThemeMode.light.rawValue
		NotificationCenter.default.post(name: .themeChanged, object: nil)
	}

	func setThemePreferenceDark() {
		let defaults = UserDefaults.standard
		defaults[themePreferenceKey] = ThemeMode.dark.rawValue
		NotificationCenter.default.post(name: .themeChanged, object: nil)
	}
}

extension NSNotification.Name {
	static let themeChanged = NSNotification.Name("com.marlon.tipsy.themeChanged")
}
