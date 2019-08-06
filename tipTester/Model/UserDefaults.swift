//
//  File.swift
//  tipTester
//
//  Created by Marlon Raskin on 8/5/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation


extension UserDefaults {
	subscript(key: String) -> Any? {
		get {
			return object(forKey: key)
		}
		set {
			set(newValue, forKey: key)
		}
	}
}

let defaults = UserDefaults.standard

let darkModeEnabled = (defaults["darkModeEnabled"] as? Bool) ?? false

let lightModeEnabled = (defaults["lightModeEnabled"] as? Bool) ?? false


