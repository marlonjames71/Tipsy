//
//  SettingsHelper.swift
//  tipsy
//
//  Created by Marlon Raskin on 11/29/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

struct Settings {
	let title: String
	let icon: UIImage
	let subtitleText: String?
}

class SettingsHelper {

	init() {
		helpAndFeedbackArray = [rateTipsy, followTipsy, shareTipsy, contactTipsy, quickTips]
		calcAndAppSettings = [roundTotals, hapticFeedback, chooseEmojis]
	}

	// MARK: - Help & Feedback
	let rateTipsy = Settings(title: "Rate Tipsy on the App Store", icon: UIImage(systemName: "star")!, subtitleText: nil)
	let followTipsy = Settings(title: "Follow Tipsy on Twitter", icon: UIImage(named: "twitter")!, subtitleText: nil)
	let shareTipsy = Settings(title: "Share Tipsy", icon: UIImage(systemName: "square.and.arrow.up")!, subtitleText: nil)
	let contactTipsy = Settings(title: "Contact Us", icon: UIImage(systemName: "paperplane")!, subtitleText: nil)
	let quickTips = Settings(title: "Quick Tipsies", icon: UIImage(systemName: "checkmark.seal")!, subtitleText: nil)

	let helpAndFeedbackArray: [Settings]


	// MARK: - Calculator & App Settings
	let roundTotals = Settings(title: "Round Totals", icon: UIImage(systemName: "arrow.uturn.up.circle.fill")!, subtitleText: "This setting will round up the total bill as well as the split total for each person. This setting exists to eliminate any change in the total amount each person would have to pay")

	let hapticFeedback = Settings(title: "Haptic Feedback", icon: UIImage(systemName: "dot.radiowaves.left.and.right")!, subtitleText: "Turn vibrations on/off")

	let chooseEmojis = Settings(title: "Choose Quick Tip Emojis", icon: UIImage(systemName: "smiley")!, subtitleText: nil)

	let calcAndAppSettings: [Settings]

	// MARK: - Messaging Prompts
	let applePayHint = Settings(title: "Include Apple Pay Hint", icon: UIImage(systemName: "lightbulb.fill")!, subtitleText: "When using the Split Bill feature you can message your party members with their portion of the bill. Messages will include a hint that Apple Pay can be used. Toggle off if you prefer not to receive Apple Cash")



// dot.radiowaves.left.and.right
}
