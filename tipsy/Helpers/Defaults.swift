//
//  Defaults.swift
//  tipTester
//
//  Created by Marlon Raskin on 10/31/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation
import UIKit

fileprivate extension String {
	static let defaultsVersion = "com.augustLight.defaultsVersion"

	static let emojiOneKey = "emojiOne"
	static let emojiTwoKey = "emojiTwo"
	static let emojiThreeKey = "emojiThree"
	static let emojiFourKey = "emojiFour"
	static let roundingKey = "toggleRounding"
	static let hapticFeedbackIsOnKey = "hapticIsOn"
	static let includeApplePayHint = "ApplePayHint"
}

enum DefaultsManager {
	fileprivate static let defaults = UserDefaults.standard
	static let lightFeedback = UIImpactFeedbackGenerator(style: .light)
	static let mediumFeedback = UIImpactFeedbackGenerator(style: .medium)
	static let heavyFeedback = UIImpactFeedbackGenerator(style: .heavy)
	static let softFeedback = UIImpactFeedbackGenerator(style: .soft)
	static let feedback = UISelectionFeedbackGenerator()

	static var defaultsVersion: Int {
		get {
			return defaults.integer(forKey: .defaultsVersion)
		}
		set {
			defaults.set(newValue, forKey: .defaultsVersion)
		}
	}

	static var roundingIsEnabled: Bool {
		get {
			return defaults.bool(forKey: .roundingKey)
		}
		set {
			defaults.set(newValue, forKey: .roundingKey)
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

	static var hapticFeedbackIsOn: Bool {
		get {
			return defaults.object(forKey: .hapticFeedbackIsOnKey) as? Bool ?? true
		}
		set {
			defaults.set(newValue, forKey: .hapticFeedbackIsOnKey)
		}
	}

	static var includeApplePayHint: Bool {
		get {
			return defaults.object(forKey: .includeApplePayHint) as? Bool ?? true
		}
		set {
			defaults.set(newValue, forKey: .includeApplePayHint)
		}
	}

	static func produceLightFeedback() {
		if hapticFeedbackIsOn {
			lightFeedback.impactOccurred()
		}
	}

	static func produceMediumFeedback() {
		if hapticFeedbackIsOn {
			mediumFeedback.impactOccurred()
		}
	}

	static func produceHeavyFeedback() {
		if hapticFeedbackIsOn {
			heavyFeedback.impactOccurred()
		}
	}

	static func produceSoftFeedback() {
		if hapticFeedbackIsOn {
			softFeedback.impactOccurred()
		}
	}

	static func produceSelectionFeedback() {
		if hapticFeedbackIsOn {
			feedback.selectionChanged()
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
