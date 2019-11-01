//
//  Defaults.swift
//  tipTester
//
//  Created by Marlon Raskin on 10/31/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation


fileprivate extension String {
	static let defaultsVersion = "com.augustLight.defaultsVersion"

	static let emojiOneKey = "emojiOne"
	static let emojiTwoKey = "emojiTwo"
	static let emojiThreeKey = "emojiThree"
	static let emojiFourKey = "emojiFour"
}

enum DefaultsManager {
	fileprivate static let defaults = UserDefaults.standard

	static var defaultsVersion: Int {
		get {
			return defaults.integer(forKey: .defaultsVersion)
		}
		set {
			defaults.set(newValue, forKey: .defaultsVersion)
		}
	}

	static var emojiOne: String {
		get {
			return defaults.string(forKey: .emojiOneKey) ?? "🤬"
		}
		set {
			defaults.set(newValue, forKey: .emojiOneKey)
		}
	}

	static var emojiTwo: String {
		get {
			return defaults.string(forKey: .emojiTwoKey) ?? "😐"
		}
		set {
			defaults.set(newValue, forKey: .emojiTwoKey)
		}
	}

	static var emojiThree: String {
		get {
			return defaults.string(forKey: .emojiThreeKey) ?? "😁"
		}
		set {
			defaults.set(newValue, forKey: .emojiThreeKey)
		}
	}

	static var emojiFour: String {
		get {
			return defaults.string(forKey: .emojiFourKey) ?? "😜"
		}
		set {
			defaults.set(newValue, forKey: .emojiFourKey)
		}
	}


	/**
	Imperative that this function is called as early as possible in app startup. At time of writing, was part of Singlenator init
	*/
	static func migrateDefaults() {
		if defaultsVersion == 0 {
			defaults.set(1, forKey: String.defaultsVersion)
		}
	}
}
