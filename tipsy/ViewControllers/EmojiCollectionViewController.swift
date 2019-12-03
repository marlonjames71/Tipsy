//
//  EmojiCollectionViewController.swift
//  tipTester
//
//  Created by Marlon Raskin on 10/31/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class EmojiCollectionViewController: UIViewController {

	@IBOutlet private weak var emojiCollectionView: UICollectionView!

	@IBOutlet weak var visualFXView: UIVisualEffectView!
	@IBOutlet weak var emojiOne: EmojiButton!
	@IBOutlet weak var emojiTwo: EmojiButton!
	@IBOutlet weak var emojiThree: EmojiButton!
	@IBOutlet weak var emojiFour: EmojiButton!

	lazy var quickEmojiArray = [emojiOne, emojiTwo, emojiThree, emojiFour].compactMap { $0 }

	let layer = CAGradientLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
		emojiCollectionView.delegate = self
		emojiCollectionView.dataSource = self
		navigationController?.isModalInPresentation = true
		loadEmojis()
		navigationController?.presentationController?.delegate = self
		navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.roundedFont(ofSize: 20, weight: .medium)]
    }


	private func loadEmojis() {
		emojiOne.setTitle(DefaultsManager.emojiOne, for: .normal)
		emojiTwo.setTitle(DefaultsManager.emojiTwo, for: .normal)
		emojiThree.setTitle(DefaultsManager.emojiThree, for: .normal)
		emojiFour.setTitle(DefaultsManager.emojiFour, for: .normal)
	}

	@IBAction func emojiButtonSelected(_ sender: EmojiButton) {
		selectEmojiButton(sender)
	}

	@IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
		saveEmojiSet()
	}

	private func saveEmojiSet() {
		DefaultsManager.emojiOne = emojiOne.currentTitle ?? DefaultsManager.emojiOne
		DefaultsManager.emojiTwo = emojiTwo.currentTitle ?? DefaultsManager.emojiTwo
		DefaultsManager.emojiThree = emojiThree.currentTitle ?? DefaultsManager.emojiThree
		DefaultsManager.emojiFour = emojiFour.currentTitle ?? DefaultsManager.emojiFour
		let emojiSuccessAlert = UIAlertController(title: "You emojis have been updated: \(DefaultsManager.emojiOne)\(DefaultsManager.emojiTwo)\(DefaultsManager.emojiThree)\(DefaultsManager.emojiFour)", message: nil, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .default) { _ in
			self.dismiss(animated: true, completion: nil)
		}
		emojiSuccessAlert.addAction(okAction)
		self.present(emojiSuccessAlert, animated: true, completion: nil)
	}

	@IBAction func cancelTapped(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}

	private func dismissalActionSheet() {
		let dismissActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		let saveAction = UIAlertAction(title: "Save Emojis", style: .default) { _ in
			self.saveEmojiSet()
		}

		let closeAction = UIAlertAction(title: "Close Emoji Picker", style: .default) { _ in
			self.dismiss(animated: true, completion: nil)
		}

		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

		[saveAction, closeAction, cancelAction].forEach { dismissActionSheet.addAction($0) }
		present(dismissActionSheet, animated: true, completion: nil)
	}

	private func selectEmojiButton(_ button: EmojiButton) {
		quickEmojiArray.forEach { $0.emojiSelected = false }
		button.setTitleColor(.black, for: .selected)
		button.emojiSelected = true
		button.tintColor = .turquoiseTwo
	}

	let emojiArray = Array("""
		😏😐😌🤓🤬🥳🤪😁😃😞🤢😆😁😉🤣☺️😍😛😋🤨🤓😎🤩😔😕🙁☹️😖😩🥺😤🤔🤗😬🙄🤮😡😶😐😑🤭🤤🥴\
		👺😈👿👹🤡💩👻💀👽👾🤖🎃😺😼😾😻🙌👏👍👎🤘👌🖖🤙🖕💋👄👀👅🤷‍♀️🤷‍♂️🕺💃👑🕶👓🐶🐱🐭🐹🐰🦊🐻\
		🐼🐨🐯🦁🐮🐷🐽🐸🐵🐒🐔🦆🦅🦖🦕🐙🐠🐬🐳🦈🐋🐊🐅🦍🐘🦏🐕🦌🐄🐉🐿🦚🦜🐲🌵🌲🎄🌴🌱🍀🍂🌺🌸\
		🌻🌞🌝🌚💥💫🌎⭐️✨⚡️🔥🌪🌈🍻🥂🍴🍽🥢🥇🥈🥉🏅🏆🎗🍬🍭🏀⚽️🏈🏉⚾️🎾🏐🥏🎱🎫🎟🎪🛫🚀🛰🎢🏖\
		🚨🚔📺📸📷💾💿📻🎙📡💵💸💴💶💷💰💳💣🧨🔫🚬🧻🚽🧼🗝🔑🎊🎉📍📌🆗🆒1️⃣2️⃣3️⃣4️⃣5️⃣6️⃣7️⃣8️⃣9️⃣🔟✅\
		✳️❎💯🚫❌🆘🛑❗️❕❓❔‼️⁉️🎶🎵☑️✔️📢📣🏁🏳️
		""").map { String($0) }

	private func startShadow() {
		let shadowSize: CGFloat = 10
		let contactRect = CGRect(x: -shadowSize, y: visualFXView.frame.height - (shadowSize * 0.4), width: visualFXView.frame.width + shadowSize * 2, height: shadowSize)
		visualFXView.layer.shadowPath = UIBezierPath(ovalIn: contactRect).cgPath
		visualFXView.layer.shadowRadius = 7
		visualFXView.layer.shadowOpacity = 0.4
	}

	private func endShadow() {
		visualFXView.layer.shadowOpacity = 0.0
	}

}

extension EmojiCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		UIView.animate(withDuration: 0.3) {
			self.startShadow()
		}

		if scrollView.contentOffset.y == 0 {
			UIView.animate(withDuration: 0.2) {
				self.endShadow()
			}
		}
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return emojiArray.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let emojiCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath) as? EmojiCollectionViewCell else { return UICollectionViewCell() }

		let emoji = emojiArray[indexPath.item]
		emojiCell.emojiLabel.text = emoji
		return emojiCell
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let selectedEmoji = emojiArray[indexPath.item]
		var shouldMoveToNext = false
		for emoji in quickEmojiArray {
			if emoji.emojiSelected {
				emoji.setTitle(selectedEmoji, for: .normal)
				shouldMoveToNext = true
			} else if shouldMoveToNext {
				selectEmojiButton(emoji)
				shouldMoveToNext = false
			}
		}
	}
}

extension EmojiCollectionViewController: UIAdaptivePresentationControllerDelegate {
	func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
		self.dismissalActionSheet()
	}
}
