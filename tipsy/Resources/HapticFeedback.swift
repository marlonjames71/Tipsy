//
//  HapticFeedback.swift
//  tipsy
//
//  Created by Marlon Raskin on 11/10/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

enum HapticFeedback {
	static let lightFeedback = UIImpactFeedbackGenerator(style: .light)
	static let mediumFeedback = UIImpactFeedbackGenerator(style: .medium)
	static let heavyFeedback = UIImpactFeedbackGenerator(style: .heavy)
	static let softFeedback = UIImpactFeedbackGenerator(style: .soft)
	static let feedback = UISelectionFeedbackGenerator()


	static func produceLightFeedback() {
		if DefaultsManager.hapticFeedbackIsOn {
			lightFeedback.impactOccurred()
		}
	}

	static func produceMediumFeedback() {
		if DefaultsManager.hapticFeedbackIsOn {
			mediumFeedback.impactOccurred()
		}
	}

	static func produceHeavyFeedback() {
		if DefaultsManager.hapticFeedbackIsOn {
			heavyFeedback.impactOccurred()
		}
	}

	static func produceSoftFeedback() {
		if DefaultsManager.hapticFeedbackIsOn {
			softFeedback.impactOccurred()
		}
	}

	static func produceSelectionFeedback() {
		if DefaultsManager.hapticFeedbackIsOn {
			feedback.selectionChanged()
		}
	}
}
