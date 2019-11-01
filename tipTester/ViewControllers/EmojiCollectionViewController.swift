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
	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var blurView: UIView!

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
		isModalInPresentation = true
		let blurEffect = UIBlurEffect(style: .regular)
		let blurEffectView = UIVisualEffectView(effect: blurEffect)
		blurEffectView.frame = blurView.bounds
		blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		blurView.addSubview(blurEffectView)
		emojiButtonSelected(emojiOne)
    }

	@IBAction func emojiButtonSelected(_ sender: EmojiButton) {
		selectEmojiButton(sender)
	}

	@IBAction func saveEmojiSet(_ sender: UIBarButtonItem) {

	}

	@IBAction func cancelTapped(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
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
		🌻🌞🌝🌚💥💫🌎⭐️✨⚡️🔥🌪🌈🍻🥂🍴🍽🥢🥇🥈🥉🏅🏆🎗🎫🎟🎪🛫🚀🛰🎢🏖🚨🚔📺📸📷💾💿📻🎙📡💵\
		💸💴💶💷💰💳💣🧨🔫🚬🧻🚽🧼🗝🔑🎊🎉📍📌🆗🆒1️⃣2️⃣3️⃣4️⃣5️⃣6️⃣7️⃣8️⃣9️⃣🔟✅✳️❎💯🚫❌🆘🛑❗️❕❓❔\
		‼️⁉️🎶🎵☑️✔️📢📣🏁🏳️
		""").map { String($0) }

}

extension EmojiCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
		for emoji in quickEmojiArray {
			if emoji.emojiSelected {
				emoji.setTitle(selectedEmoji, for: .normal)
			}
		}
	}
}
