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

class ThemeHelper {

	let themePreferenceKey = "selectTheme"

	init() {
		if themePreference == nil {
			setThemePreferenceDark()
		}
	}

	var themePreference: String? {
		let defaults = UserDefaults.standard
		let theme = defaults.string(forKey: themePreferenceKey)
		return theme
	}

	func setThemePreferenceLight() {
		let defaults = UserDefaults.standard
		defaults["lightModeEnabled"] = true
//		defaults.register(defaults: ["LightTheme" : true])
		defaults.set("Light", forKey: themePreferenceKey)
	}

	func setThemePreferenceDark() {
		let defaults = UserDefaults.standard
		defaults["darkModeEnabled"] = true
//		defaults.register(defaults: ["DarkTheme" : false])
		defaults.set("Dark", forKey: themePreferenceKey)
	}
}
